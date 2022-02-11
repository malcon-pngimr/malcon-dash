
# -------------------------------------------------------------------------
# Pulling HFS data for the MalCon Project
# Source: ODK Central - Swiss TPH
# -------------------------------------------------------------------------

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



# render site
rmarkdown::render_site()
