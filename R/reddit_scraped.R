## Script Settings and Resources
library(tidyverse)
library(rvest)


## Data Import and Cleaning
# Reads in the html data from the URL as an xml_document
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

# This series of three pipes extracts the variables of interest from the xml_document
# This pipe extracts post title elements and keeps the text
post <- rstats_html %>% 
  html_elements(xpath = "//p[@class = 'title']") %>% 
  html_text()

# This pipe extracts upvote elements, keeps the text, converts that text to numeric, and converts NAs from posts with no upvotes to 0s
upvotes <- rstats_html %>% 
  html_elements(xpath = "//div[@class = 'score unvoted']") %>% 
  html_text() %>% 
  as.numeric() %>% 
  replace_na(0)

# This pipe extracts the comment number elements, keeps the text, keeps only the parts of the text that are digits, converts those digits to numeric, and converts NAs from posts with no comments to 0s
comments <- rstats_html %>% 
  html_elements(xpath = "//a[@data-event-action = 'comments']") %>% 
  html_text() %>% 
  str_extract(pattern = "\\d*") %>% 
  as.numeric() %>% 
  replace_na(0)

# We take our three variables of interest and place them in a tibble
rstats_tbl <- tibble(post, upvotes, comments)

## Visualization


