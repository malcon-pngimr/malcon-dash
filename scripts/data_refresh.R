

pat_key <- ""

# Set form id and url as characters
fid <- c(form1 = "hfc_v3", form2 = "pi_v3",
         form3 = "ppa_v3", form4 = "ei_v3",
         form5 = "fvs_v1")

# Set ODK form url
fid_url <- paste("https://odk-central.swisstph.ch/v1/projects/17/forms/",
                 fid, ".svc", sep = "")

# Set current raw file url from repo 
raw_url <- "raw.githubusercontent.com/myominnoo/malcon/main/data/"


for (x in 1:length(fid)) {
    temp_file <- tempdir()
    
    temp_file <- paste(temp_file, "/", fid[x], ".csv", sep = "")
    download.file(paste("https://", pat_key, "@", raw_url, fid[x], ".csv", sep = ""), 
                  temp_file)
    
    assign(fid[x], read.csv(temp_file, stringsAsFactors = FALSE))
}
download.file(paste("https://", pat_key, "@", 
                    "raw.githubusercontent.com/myominnoo/malcon/main/scripts/templates/",
                    "vars_map.xlsx", sep = ""), 
              temp_file)
vars_map <- readxl::read_excel(temp_file, sheet = "hfc_v3")

hfc_v3[hfc_v3$hfs_008 < 99, "hfs_008"]
readxl::read_excel("./scripts/")

names(hfc_v3[, -which(vars_map$odk_autovars == 1)])


hfc <- hfc_v3[, 1:20]
names(hfc)

library(tidyverse)
hfc <- hfc_v3 %>% 
    select(hfs_00X:hfs_010) %>%
    mutate(hfs_00X = as.Date(sub("T.*", "", hfs_00X), format = "%Y-%m-%d"), 
           hfs_011 = as.Date(hfs_011, format = "%Y-%m-%d")) 


hfc 

