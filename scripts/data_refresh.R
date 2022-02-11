install.packages("flexdashboard", dependencies = TRUE)

api_key <- commandArgs(trailingOnly = TRUE)
print(paste("this is api key", api_key, "... "))

## set form id and url as characters
fid <- c(form1 = "hfc_v3", form2 = "pi_v3", 
         form3 = "ppa_v3", form4 = "ei_v3", 
         form5 = "fvs_v1")
raw_url <- "raw.githubusercontent.com/myominnoo/malcon/main/data/"
# lapply(paste("https://", api_key, "@", raw_url, fid, ".csv", sep = ""), 
#        read.csv, stringsAsFactors = FALSE)


rmarkdown::render_site()