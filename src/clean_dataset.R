library(tidyverse)

movies <- read_delim('dataset/movies.tsv', delim = '\t')
principals <- read_delim('dataset/principals.tsv', delim = '\t')
actors <- read_delim('dataset/actors.tsv', delim = '\t')
ratings <- read_delim('dataset/ratings.tsv', delim = '\t')

movies_reduced <-
	movies %>%
		filter(startYear >= 2018, titleType %in% c('movie', 'short', 'tvEpisode', 'tvMovie', 'tvSeries'))

# dataset <-
# 	movies_reduced %>%
# 		inner_join(principals) %>%
# 		inner_join(actors) %>%
# 		inner_join(ratings)
#
# dataset
tmp <-
movies %>%
		filter(startYear >= 2003, titleType %in% c('movie', 'tvSeries')) %>%
	inner_join(ratings)

movies %>%
		filter(titleType %in% c('movie', 'tvSeries')) %>%
	nrow()
tmp %>%
	summarise(
		n = n(), avg = mean(numVotes), rel = sum(numVotes >= 50000))

dataset <-
	movies %>%
		filter(startYear >= 2003, titleType %in% c('movie', 'tvSeries')) %>%
		inner_join(ratings) %>%
		filter(numVotes >= 50000) %>%
		inner_join(principals) %>%
		inner_join(actors)
dataset
dataset %>%
	select(primaryTitle, titleType, primaryName, category, numVotes, averageRating) %>%
	rename(
		movie = primaryTitle,
		type =titleType,
		person = primaryName,
		votes = numVotes,
		rating = averageRating,
	) %>%
	write_csv('dataset/dataset.csv')

dataset %>%
	select(primaryTitle, titleType, primaryName, category, numVotes, averageRating) %>%
	arrange(-averageRating)
	filter(primaryTitle == 'Barbie')

dataset %>%
	filter(primaryName == 'Marco Giallini')