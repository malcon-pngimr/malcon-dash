install.packages("flexdashboard", dependencies = TRUE)

api_key <- commandArgs(trailingOnly = TRUE)
print(paste("this is api key", api_key, "... "))

## set form id and url as characters
fid <- c(form1 = "hfc_v3", form2 = "pi_v3", 
         form3 = "ppa_v3", form4 = "ei_v3", 
         form5 = "fvs_v1")
raw_url <- "raw.githubusercontent.com/myominnoo/malcon/main/data/"

for (x in 1:length(fid)) {
    temp <- tempdir()
    
    temp_file <- paste(temp, "/", fid[x], ".csv", sep = "")
    download.file(paste("https://", api_key, "@", raw_url, fid[x], ".csv", sep = ""), 
                  temp_file)
    
    ds <- read.csv(temp_file, stringsAsFactors = FALSE)
    names(ds)
}

rmarkdown::render_site()