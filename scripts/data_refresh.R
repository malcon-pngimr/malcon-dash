
# -------------------------------------------------------------------------
# Pulling HFS data for the MalCon Project
# Source: ODK Central - Swiss TPH
# -------------------------------------------------------------------------

# install required packages
install.packages("flexdashboard", dependencies = TRUE)


# Set Global Environment --------------------------------------------------

# Set PAT_KEY
(pat_key <- Sys.getenv("PAT_KEY"))

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
    
    ds <- read.csv(temp_file, stringsAsFactors = FALSE)
    print(names(ds))
}

# rmarkdown::renders_site()

print(installed.packages())