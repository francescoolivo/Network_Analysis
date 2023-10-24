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
		filter(startYear >= 1983, titleType %in% c('movie', 'short', 'tvMovie', 'tvSeries')) %>%
	inner_join(ratings)

tmp %>%
	summarise(
		n = n(), avg = mean(numVotes), rel = sum(numVotes >= 100000))

dataset <-
	movies %>%
		filter(startYear >= 1983, titleType %in% c('movie', 'short', 'tvMovie', 'tvSeries')) %>%
		inner_join(ratings) %>%
		filter(numVotes >= 10000) %>%
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