# The MalCon Monitoring Dashboard

This [MalCon Monitoring Dashboard](https://myominnoo.github.io/malcon-dash/) provides an overview of the progress of the health facility survey 2021 conducted by the Malaria Control Section (MalCon) at the Papua New Guinea Institute of Medical Research (PNGMIR). This dashboard is built in the framework of reproducibile research using Rmarkdown and GitHub action workflows.

**Data**

The input data for this dashboard is the [Data Automation site](https://github.com/myominnoo/malcon) which is a private repository on GitHub. This repository retrieves daily data updates from the ODK Central platform hosted by the Swiss TPH. 

## Technical Notes

**Codes**
This dashboard is built with R using [Rmakrdown](https://rmarkdown.rstudio.com/) and [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/) framework, and can easily reproduce by others. The code behind the dashboard available [here](https://github.com/myominnoo/malcon-dash)

**Packages**

- Dashboard interface - the `flexdashboard` package.
- Visualization - the `plotly` package for the plots and mapview package for the map
- Data manipulation - `dplyr`, and `tidyr`
- Tables - the `DT` package

**Acknowledgement**
The projects by [Rami Krispin](https://github.com/RamiKrispin/) inspires this dashboard. 
