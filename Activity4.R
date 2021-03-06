# Activity 4: Create tidy data frames from corpus objects and visualize term frequencies
install.packages("wordcloud")
install.packages("tidytext")

library(readtext)
library(tidyverse)
library(wordcloud)
library(tidytext)

################ Setup: OK to skip in class if already stored in R

reviews <- readtext("hotelreviews.csv", text_field = "reviews.text", encoding = "utf8")
reviews_corp <- corpus(reviews)

################ 


# 1. Convert corpus to a document feature matrix (dfm).

reviews_dfm <- dfm(reviews_corp, remove = stopwords(language="en"), remove_punct=TRUE, remove_numbers=TRUE)


# 2. Turn dfm into a tidy dataframe. A tidy data frame means one variable per column, one observation per row, one value per cell.

tidy_reviews <- tidy(reviews_dfm)

tidy_reviews

# 3. Filter and sort by the documents that mention breakfast most often
tidy_reviews %>%
  filter(term=="breakfast") %>% 
  arrange(desc(count))

# 4. Look up review #1053 to see what the person said about the breakfast
reviews_corp[[   ]]

# 5. Practice. Filter and sort by the documents that mention location most often. View the first review in the list.
tidy_reviews %>% 



# 6. Use tidyverse functions select(), group_by(), summarise(), arrange() to see total word counts
term_frequency <- tidy_reviews %>%
  select(-document) %>%
  group_by(term) %>%
  summarise(freq = n()) %>%
  arrange(desc(freq))

View(term_frequency)

## Visualize the word counts 

# 7. Create a word cloud
wordcloud(term_frequency$term, term_frequency$freq, max.words = 100, colors=brewer.pal(3, "Dark2"))

# 8. Practice. Re-run the word cloud with max.words = 150. 


# Create a bar chart

# 9. Create a bar chart using the top 20 terms by frequency
num <- 20
barplot(term_frequency$freq[1:num], names.arg = term_frequency$term[1:num], las=2, main="Top Terms")


# 10. Practice. Now create a bar chart showing top 40 terms. Just change num value to 40 and re-run the code!



# 11. Practice. Create a dfm from the corpus of tweets created in the last activity. 
#tweets_corp <- corpus(tweets)
tweets_dfm <- 
  
# 12. Practice. Create a tidy data frame from the dfm.
tidy_tweets <- 


# 13. Practice. Use tidyverse functions select(), group_by(), summarise(), arrange() to see total word counts as in step 6.
tweet_frequency <- 
  

# 14. Practice. Create a word cloud.

  
# 15. Let's remove the first 6 rows of most frequent terms and re-run the wordcloud.
tf_trimmed <- tweet_frequency[-c(1:6),]
wordcloud(tf_trimmed$term, term_frequency$freq, max.words = 150, colors=brewer.pal(3, "Dark2"))


