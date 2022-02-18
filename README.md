# The MalCon Monitoring Dashboard
    
This [MalCon Monitoring Dashboard](https://myominnoo.github.io/malcon-dash/) provides an overview of the progress of the `health facility survey 2021` that is being conducted by the Malaria Control Section (`MalCon`) at the `Papua New Guinea Institute of Medical Research` (`PNGMIR`). 

This dashboard is built in the framework of reproducibile research using `Rmarkdown` and `GitHub action workflow`.

## Data
    
The input data for this dashboard is the [Data Automation site](https://github.com/myominnoo/malcon) which is a private repository on `GitHub` that is only accessible by the `MalCon` team. This repository retrieves daily data updates from the `ODK Central` platform hosted by the `Swiss TPH`. 

The updated data are then being passed through a series of data processing procedures in `R` and the final data are displayed as numbers and figures on the dashboard. 


## Technical Notes

This dashboard is built with R using [Rmakrdown](https://rmarkdown.rstudio.com/) and [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/) framework, and can easily reproduce by others. The code behind the dashboard available [here](https://github.com/myominnoo/malcon-dash)

- `GitHub Action Workflow` for automated tasks
- `docker` for reproducible environments
- `rmarkdown` for rendering the dashboard webpage
- `shell` scripting to bridge `GitHub Action Workflow`, `docker`, and `R`
- `git` for version control system 

## R Packages

- `dplyr`, and `tidyr` for data wrangling
- `flexdashboard` for the dashboard interface
- `plotly` and `ggplot2` for the plots 
- `rnaturalearth`` and `mapview` for the PNG map
- `DT` for diplaying tabular data 

## Acknowledgement

The projects by [Rami Krispin](https://github.com/RamiKrispin/) inspires this dashboard. 
