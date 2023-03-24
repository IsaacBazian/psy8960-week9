## Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
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



## Visualization
# This pipe takes our tibble, plots number of upvotes vs number of comments, makes it a scatterplot, adds a line of best fit (not explicitly asked for or necessary but I like having it), and makes the axes titles a bit more descriptive
ggplot(rstats_tbl, aes(upvotes, comments)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Number of Upvotes", y = "Number of Comments")

## Analysis
# Computes the correlation between number of upvotes and number of comments and the p-value of that relationship. We assign this to an object to make the Publication section code cleaner
upvComTest <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
upvComTest

## Publication
#The correlation between upvotes and comments was r(23) = .74, p = .00. This test was statistically significant.

# We assign the df, r, and p-value from the previously conducted cor.test to objects. In theory, we could simply use these functions inside paste0(), but this way is easier to read
df <- upvComTest$parameter
cor <- str_remove(format(round(upvComTest$estimate, 2), nsmall = 2), pattern = "^0")
pvalue <- str_remove(format(round(upvComTest$p.value, 2), nsmall = 2), pattern = "^0")
# We technically break the style guide for the correlation and p-value by calling multiple functions on the same line to trim leading zeros 
# and include exactly 2 trailing zeros which round() could otherwise omits, but I elected to do it this way
# because what the code is doing is still pretty simple, and this is all just 'under the hood' for display anyway

# We combine the text and the dynamically calculated values stored in the objects
paste0("The correlation between upvotes and comments was r(", df,") = ", cor, ", p = ", pvalue, ". This test was statistically significant." )





