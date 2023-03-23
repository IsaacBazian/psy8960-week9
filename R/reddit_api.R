# Script Settings and Resources
library(tidyverse)
library(jsonlite)





# Data Import and Cleaning
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json")

rstats_original_tbl <- rstats_list[["data"]]["children"]
