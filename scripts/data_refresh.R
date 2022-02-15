# Set PAT_KEY
(pat_key <- Sys.getenv("PAT_KEY"))

# Set form id and url as characters
fid <- c(form1 = "hfc_v3", form2 = "pi_v3",
         form3 = "ppa_v3", form4 = "ei_v3",
         form5 = "fvs_v1")


# Set current raw file url from repo 
url_data_old <- "raw.githubusercontent.com/myominnoo/malcon/main/data/"

# ## download all form submissions
# for (x in 1:length(fid)) {
#     # Compare data with current data
#     assign(fid[x], read.csv(
#         paste0("https://", pat_key, "@", url_data_old, fid[x], ".csv"), 
#         stringsAsFactors = FALSE))
#     cat("successfully imported ", fid[x], " ... \n")
# }

hfc_v3 <- readr::read_csv(paste0("https://", pat_key, "@", url_data_old, fid[1], ".csv"))
pi_v3 <- readr::read_csv(paste0("https://", pat_key, "@", url_data_old, fid[2], ".csv"))
ppa_v3 <- readr::read_csv(paste0("https://", pat_key, "@", url_data_old, fid[3], ".csv"))
ei_v3 <- readr::read_csv(paste0("https://", pat_key, "@", url_data_old, fid[4], ".csv"))
fvs_v3 <- readr::read_csv(paste0("https://", pat_key, "@", url_data_old, fid[5], ".csv"))

print(ls())

# packages ----------------------------------------------------------------

install.packages("flexdashboard")
