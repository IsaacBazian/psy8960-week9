## Script Settings and Resources
library(tidyverse)
library(rvest)


## Data Import and Cleaning
# Reads in the html data from the URL as an xml_document
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

# This series of three pipes extracts the variables of interest from the xml_document
# This pipe extracts post title elements and keeps the text
post <- rstats_html %>% 
  html_elements(xpath = "//a[@data-event-action = 'title']") %>% 
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
#The correlation between upvotes and comments was r(23) = .76, p = .00. This test was statistically significant.

# We assign the df, r, and p-value from the previously conducted cor.test to objects. In theory, we could simply use these functions inside paste0(), but this way is easier to read
df <- upvComTest$parameter
cor <- str_remove(format(round(upvComTest$estimate, 2), nsmall = 2), pattern = "^0")
pvalue <- str_remove(format(round(upvComTest$p.value, 2), nsmall = 2), pattern = "^0")
# We technically break the style guide for the correlation and p-value by calling multiple functions on the same line to trim leading zeros 
# and include exactly 2 trailing zeros which round() could otherwise omits, but I elected to do it this way
# because what the code is doing is still pretty simple, and this is all just 'under the hood' for display anyway

# We combine the text and the dynamically calculated values stored in the objects
paste0("The correlation between upvotes and comments was r(", df,") = ", cor, ", p = ", pvalue, ". This test was statistically significant." )





