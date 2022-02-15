
# -------------------------------------------------------------------------
# 
#                       SET UP - MALCON DASHBOARD
#
# -------------------------------------------------------------------------

# import data -------------------------------------------------------------


# Set up Environment  -----------------------------------------------------


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
# death_color <- "red"
intensive_care_color <- "#ba181b"
h_symptoms_color <- "#e5383b"
home_conf_color <- "#FDBBBC"

# process data ------------------------------------------------------------

# correct date format in HFC for last date submission data
hfc_v3 <- hfc_v3 %>% 
    dplyr::select(hfs_00X:hfs_010) %>%
    dplyr::mutate(hfs_00X = as.Date(sub("T.*", "", hfs_00X), format = "%Y-%m-%d"), 
                  hfs_011 = as.Date(hfs_011, format = "%Y-%m-%d")) 

last_submission <- hfc_v3 %>% 
    dplyr::filter(hfs_00X == max(hfs_00X))

# province completed
province_complete <- hfc_v3 %>% 
    dplyr::distinct(hfs_001A) %>% 
    dplyr::summarize(n = dplyr::n()) %>% 
    unlist %>% 
    unname(.)

# province complete percenetage
province_complete_pct <- round(province_complete/22*100, 2) 

# PNG map
png_prov <- hfc_v3 %>% 
    dplyr::select(hfs_001A, hfs_005X) %>% 
    dplyr::mutate(hfs_001A = tolower(hfs_001A)) %>%
    dplyr::rename(province = hfs_001A) %>% 
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
    dplyr::left_join(png_prov, by = "province") 


# create form ids 
fid <- c(form1 = "hfc_v3", form2 = "pi_v3",
         form3 = "ppa_v3", form4 = "ei_v3",
         form5 = "fvs_v1")
form_submit <- data.frame(fid = names(fid), 
                          num = c(nrow(hfc_v3), nrow(pi_v3), 
                                  nrow(ppa_v3), nrow(ei_v3), nrow(fvs_v1)))

# separate health center and aidpost
hf_num <- hfc_v3 %>% 
    dplyr::mutate(hfs_005X = ifelse(hfs_005X == 1, "Aidpost", "Health Center")) %>% 
    dplyr::group_by(hfs_005X) %>% 
    dplyr::summarise(n = dplyr::n())


print(hf_num)