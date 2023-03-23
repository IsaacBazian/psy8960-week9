# Script Settings and Resources
library(tidyverse)
library(rvest)


# Data Import and Cleaning
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

post <- rstats_html %>% 
  html_elements(xpath = "//p[@class = 'title']") %>% 
  html_text()
  
