
# -------------------------------------------------------------------------
# 
#                       SET UP - MALCON DASHBOARD
#
# -------------------------------------------------------------------------

# Set up Environment  -----------------------------------------------------

# Retrieve personal access token from GitHub to access malcon data automation
pat_key <- Sys.getenv("PAT_KEY")

# Set form id and url as characters
fid <- c(form1 = "hfc", form2 = "pi",
         form3 = "ppa", form4 = "ei",
         form5 = "fvs")

# Set current raw file url from repo 
url_data_old <- "raw.githubusercontent.com/myominnoo/malcon/main/data/"

# Set team names
team1 <- c("Clara_Are", "Wilbert_Neiembe", "Florence_Lawrence")
team2 <- c("Jacob_Girupano", "Melvin_Kualawi")
team3 <- c("Micah_Muri", "Ismart_Martin")
team4 <- c("")

# import data -------------------------------------------------------------

for (id in fid) {
    assign(id, read.csv(paste0("https://", pat_key, "@", 
                        url_data_old, id, ".csv")))
}


# packages ----------------------------------------------------------------

`%>%` <- magrittr::`%>%`
library(flexdashboard)


# set up parameters -------------------------------------------------------

#------------------ Parameters ------------------
# Set colors
# https://www.w3.org/TR/css-color-3/#svg-color
tested_color <- "purple"
positive_color <- RColorBrewer::brewer.pal(9, "PuRd")[7]
active_color <- "#1f77b4"
recovered_color <- "forestgreen"
death_color <- "#660708"
intensive_care_color <- "#ba181b"
h_symptoms_color <- "#e5383b"
home_conf_color <- "#FDBBBC"

# process data ------------------------------------------------------------

# correct date format in HFC for last date submission data
hfc <- hfc %>% 
    dplyr::mutate(hfs_000X = as.Date(hfs_000X), 
                  hfs_014 = as.Date(hfs_014)) %>%
    ## remove three records for pilot hospital submissions 
    dplyr::mutate(pilot = grepl("Maprik DH|KUNDIAWA HOSPITAL", hfs_003A) | 
                      grepl("Wabag Hospital", hfs_003XA)) %>% 
    dplyr::filter(!pilot) %>%
    dplyr::mutate(hf_type = ifelse(hfs_004X == 1, "Aid Post", "Health Center"),
                  hf_type = ifelse(hfs_004 %in% c("PH", "DH"), "Hospital", hf_type)) %>% 
    dplyr::select(-pilot) 

# province completed
province_complete <- hfc %>%
    dplyr::distinct(hfs_001A) %>%
    dplyr::summarize(n = dplyr::n()) %>% 
    unlist %>%
    unname(.)

# province complete percenetage
province_complete_pct <- round(province_complete/22*100, 0)

# date and team of last submission
last_submission <- hfc %>%
    dplyr::filter(hfs_000X == max(hfs_000X)) %>% 
    dplyr::select(hfs_000X, hfs_010) %>% 
    dplyr::mutate(
        team = NA,
        team = ifelse(hfs_010 %in% team1, 1, team),
        team = ifelse(hfs_010 %in% team2, 2, team),
        team = ifelse(hfs_010 %in% team3, 3, team),
        team = ifelse(hfs_010 %in% team4, 4, team)
    )   


# separate health center and aidpost
hf_type <- hfc %>%
    dplyr::group_by(hf_type) %>%
    dplyr::summarise(n = dplyr::n()) 


# PNG map
png_prov <- hfc %>%
    dplyr::rename(province = hfs_001A) %>%
    dplyr::mutate(province = tolower(province),
                  ## Hela was under Southern Highlands
                  ## Jiwaka was under Western Highlands
                  province = ifelse(province == "hela",
                                    "southern highlands", province),
                  province = ifelse(province == "jiwaka",
                                    "chimbu", province)) %>%
    dplyr::group_by(province) %>%
    dplyr::summarise(n = dplyr::n())

png_map <- rnaturalearth::ne_states(country = "Papua New Guinea",
                                    returnclass = "sf") %>%
    dplyr::select(province = name, geometry) %>%
    dplyr::group_by(province) %>%
    dplyr::summarise(n = dplyr::n()) %>%
    dplyr::select(-n) %>%
    dplyr::mutate(
        province = tolower(province),
        province = ifelse(province == "national capital district",
                          "ncd", province),
        ## Assuming North solomons is close to bougainville
        ## TODO: check if this is correct
        province = ifelse(province == "north solomons", "bougainville",
                          province)
    ) %>%
    dplyr::left_join(png_prov, by = "province") %>% 
    dplyr::mutate(province = toupper(province),
                  n = ifelse(is.na(n), 0, n))


# create form ids
fid <- fid[-length(fid)]
form_submit <- data.frame(fid = names(fid),
                          num = c(nrow(hfc), nrow(pi),
                                  nrow(ppa), nrow(ei)))


# Field Visit Summary 

issues <- fvs %>% 
    dplyr::mutate(hfs_000XA = paste("Team ", hfs_000XA), 
                  hfs_000X = as.Date(sub("T.*", "", hfs_000X), 
                                     format = "%Y-%m-%d")) %>% 
    dplyr::select(hfs_000X, hfs_000XA, hfs_001A, 
                  hfs_43, hfs_44, hfs_45, hfs_46) %>%  
    dplyr::arrange(dplyr::desc(hfs_000X)) %>% 
    dplyr::rename(`submission date` = hfs_000X, 
                  team = hfs_000XA, 
                  province = hfs_001A) 

# overall issues
overall <- issues %>% 
    dplyr::filter(!grepl("nil|none|success", 
                         tolower(hfs_46))) %>%  
    dplyr::rename(issue = hfs_46) %>% 
    dplyr::select(-hfs_43, -hfs_44, -hfs_45)

# field budgets issues
budgets <- issues %>% 
    dplyr::filter(!grepl("nil|none|no issue|did not encounter|wasn't any|wasnt", 
                         tolower(hfs_43))) %>%
    dplyr::rename(issue = hfs_43) %>% 
    dplyr::select(-hfs_46, -hfs_44, -hfs_45)


# field supplies issues
supplies <- issues %>% 
    dplyr::filter(!grepl("nil|none|no stock-out|not stock-out|did not have|no stockout|was not|did not|were not|no stock|wasn't|wasnt",
                         tolower(hfs_44))) %>%
    dplyr::rename(issue = hfs_44) %>% 
    dplyr::select(-hfs_46, -hfs_43, -hfs_45)


# transportation issues
transport <- issues %>% 
    dplyr::filter(!grepl("nil|none|did not have|was not|did not|were not|no|wasn't|wasnt", tolower(hfs_45))) %>% 
    dplyr::rename(issue = hfs_45) %>% 
    dplyr::select(-hfs_46, -hfs_43, -hfs_44)

