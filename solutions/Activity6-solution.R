## Activity 6: Do other types of analysis using the quanteda package on SOTU speeches: 
# tokenization, n-grams, word collocations, lexical diversity, keywords in context, etc.

library(readtext)
library(tidyverse)
library(quanteda)


####################### Skip this setup section in class ###############################

docs <- readtext("*.txt", encoding = "utf8", docvarsfrom = "filenames")

docs <- docs %>%
  mutate(year= str_sub(.$docvar1, -5)) %>% # create year column
  mutate(name= str_sub(.$docvar1, 1, -6)) # create name column

docs$year <- docs$year %>%
  str_replace_all("[-ab]", "") # remove unwanted characters from the year column

docs$year <- as.integer(docs$year)

docs$name <- docs$name %>%
  str_replace_all("-", " ") %>%
  trimws()  #trim leading and trailing whitespace from terms in name field\

# Create corpus
docs_corp <- corpus(docs)

#######################################################################################

## I. Compare most frequent terms for selected presidents

# 1. We will be working with the corpus of SOTU documents for this activity.
docs_corp

## Tokenize a corpus into a set of word pairs (bigrams)
# reference: https://quanteda.io/reference/tokens.html

# 2. Subset the SOTU corpus to include only Obama speeches
obama_corpus <- corpus_subset(docs_corp, name=="barack obama")

# 3. Clean the tokens. This time, let's leave punctuation in.
obama_toks <- tokens(obama_corpus, remove_numbers = TRUE, remove_punct = TRUE)
obama_toks <- tokens_remove(obama_toks, pattern = stopwords("english"), padding=TRUE)
obama_toks <- tokens_tolower(obama_toks)

# 4. Stem the tokens
stemmed_obama_toks <- tokens_wordstem(obama_toks, language = quanteda_options("language_stemmer"))
stemmed_obama_toks

# 5. See the top terms in the stemmed tokens list
topfeatures(dfm(stemmed_obama_toks))

# 6. Turn tokens into bigrams (word pairs) and see top 20 most frequent bigrams.
obama_bigrams <- tokens_ngrams(stemmed_obama_toks, n=2)
obama_bigrams

topfeatures(dfm(obama_bigrams), 20)

## 7. Practice. Create a corpus subset of Franklin D Roosevelt's (FDR) speeches and turn that subset into a tokens object.
# Clean the tokens. Do not stem.
fdr_corpus <- corpus_subset(docs_corp, name=="franklin d roosevelt")

fdr_toks <- tokens(fdr_corpus, remove_numbers = TRUE, remove_punct = TRUE)
fdr_toks <- tokens_remove(fdr_toks, pattern = stopwords("english"), padding=TRUE)
fdr_toks <- tokens_tolower(fdr_toks)

fdr_toks

# 8. Practice. Turn the FDR tokens into bigrams and look at top 20 most frequest bigrams.

fdr_bigrams <- tokens_ngrams(fdr_toks, n=2)

topfeatures(dfm(fdr_bigrams), 20)

# 9. Practice. Now create trigrams (n=3) from the FDR tokens.

fdr_trigrams <- tokens_ngrams(fdr_toks, n=3)
fdr_trigrams

## II. Find term collocations (words that tend to appear together) from tokens

# 10. Once you turn text into a clean set of tokens, you can look at term collocations. We can use the 
# textstat_collocations() function in the quanteda package to do this.

obama_coll_2 <- textstat_collocations(obama_toks, method = "lambda", size = 2, min_count = 2,
                                      smoothing = 0.5)
View(obama_coll_2)

# 11. Graph the top 20 collocations using tidyverse package functions chained together with %>% 

obama_coll_2 %>%
  top_n(., n=20) %>%   # select the top 20 terms
  ggplot(., aes(x=reorder(collocation, count), y=count)) + geom_col() + coord_flip() +
  labs(title = "Top 20 Collocations in Obama Speeches") +
  theme_classic()


# 12. Practice. Using the tokens you created of FDR's speeches, find term collocations and graph the top 20.

fdr_coll_2 <- textstat_collocations(fdr_toks, method = "lambda", size = 2, min_count = 2,
                      smoothing = 0.5)

# 13. Practice. Graph the top 20 collocations from FDR's speeches.
fdr_coll_2 %>%
  top_n(., n=20) %>%   # select the top 20 terms
  ggplot(., aes(x=reorder(collocation, count), y=count)) + geom_col() + coord_flip() +
  labs(title = "Top 20 Collocations in FDR Speeches") +
  theme_classic()


## III. Keywords in Context: What words immediately precede and follow terms of interest

# 14. Create a keyword in context (kwic) list
obama_kwic_list <- kwic(obama_corpus, pattern=c("immigration", "jobs", "health", "energy"))
View(obama_kwic_list)

# 15. You can also make a kwic list out n-grams, such as bigrams. For the pattern to search, type "health_care"
obama_hc_kwic <- kwic(obama_bigrams, pattern="health_care")    


## IV. Lexical Dispersion Plot: Visualize where terms occur in a set of documents

# 16. Create a lexical dispersion plot from the obama kwic list
textplot_xray(obama_kwic_list)

# 17. Practice. Create a lexical dispersion plot of the bigram "health_care"
textplot_xray(obama_hc_kwic) 


# 18. Practice. Create a kwic list for the FDR corpus and look for the pattern "war".
fdr_war_kwic <- kwic(fdr_corpus, pattern="war")  

# 19. Practice. Create a lexical dispersion plot from the FDR kwic list you just created.
textplot_xray(fdr_war_kwic)


## V. Lexical diversity: a measure of how many different words are used in a text
# Task: Rank the lexical diversity of all of the SOTU speeches

# 20. Compute the lexical diversity score of each document using the sotu_dfm
lex_diversity_score <- textstat_lexdiv(sotu_dfm)
View(lex_diversity_score)

# 21. Sort lexical diversity scores from greatest to least
sorted_lds <- arrange(lex_diversity_score, by=desc(TTR))
View(sorted_lds)


## Practice.

# 22. Practice. Construct a quanteda corpus for Ronald Reagan's speeches using corpus_subset()
reagan_corpus <- corpus_subset(docs_corp, name=="ronald reagan")


# 23. Practice. Tokenize the Reagan corpus. Remove stopwords, numbers, and convert to lowercase.
reagan_toks <- tokens(reagan_corpus, remove_numbers = TRUE)
reagan_toks <- tokens_remove(reagan_toks, pattern = stopwords("english"), padding=TRUE)
reagan_toks <- tokens_tolower(reagan_toks)

reagan_toks

# 24. Practice. Look at term collocations (2 terms and 3 terms) using the tokens object.
reagan_coll_2 <- textstat_collocations(reagan_toks, method = "lambda", size = 2, min_count = 2,
                                       smoothing = 0.5)
View(reagan_coll_2)


reagan_coll_3 <- textstat_collocations(reagan_toks, method = "lambda", size = 3, min_count = 2,
                                       smoothing = 0.5)

View(reagan_coll_3)



# VII. Chaining functions together to perform multiple operations.

# 25. Here is an example of how to use function chaining to tokenize and clean a corpus:
obama_toks <- obama_corpus %>%
  tokens(., remove_numbers = TRUE) %>%
  tokens_remove(., pattern = stopwords("english"), padding=TRUE) %>%
  tokens_tolower()

obama_toks


# 26. Create a wordcloud using quanteda functions chained together with %>%
corpus_subset(docs_corp, 
              name %in% c("george w bush", "barack obama", "donald trump")) %>%
  dfm(groups = "name", remove = stopwords("english"), remove_punct = TRUE) %>%
  dfm_trim(min_termfreq = 5, verbose = FALSE) %>%
  textplot_wordcloud(comparison = TRUE)



## Homework Practice: Case Study
# A researcher wants to create a corpus of speeches from the years 1992-2020 and examine the following: 
# The most frequent 2-term collocations in the corpus
# Lexical dispersion plot of the bigram "social_security" (for this you will need to tokenize and create bigrams)

# 27. Subset the corpus using corpus_subset(corpus, year >= 1992 & year <= 2020)
corpus9220 <- corpus_subset(docs_corp, year >= 1992 & year <= 2020)
corpus9220


# 28. Tokenize and clean tokens using function chaining (see step 25):
speeches9220_toks <- corpus9220 %>%
  tokens(., remove_numbers = TRUE) %>%
  tokens_remove(., pattern = stopwords("english"), padding=TRUE) %>%
  tokens_tolower()

speeches9220_toks

# 29. Split tokens into bigrams
bigrams9220 <- tokens_ngrams(speeches9220_toks, n=2)

# 30. Create a kwic list of the bigrams
socialsec_kwic <- kwic(bigrams9220, pattern="social_security") 

# 31. Create a lexical dispersion plot using the kwic
textplot_xray(socialsec_kwic) 
