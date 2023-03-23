## Script Settings and Resources
library(tidyverse)
library(jsonlite)



## Data Import and Cleaning
# Reads in the data as a list from Reddit via the JSON API and flattens it so that pulling out what's needed is easier
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)
# Gets the per-post data out of the list
rstats_original_tbl <- as_tibble(rstats_list$data$children)

# Takes original tbl with all variables, duplicates variables of interest with new names, and keeps only those newly named variables 
rstats_tbl <- rstats_original_tbl %>% 
  mutate(post = data.title,
         upvotes = data.score,
         comments = data.num_comments) %>% 
  select(post, upvotes, comments)




