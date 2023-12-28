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
		n = n(), avg = mean(numVotes), rel = sum(numVotes >= 50000), pct = 100*  rel / n)

estimate <- tibble(t = numeric(), nodes = numeric(), edges = numeric())

for (threshold in c(1000, 2000, 10000, 50000, 100000)) {

	tmp_df <- tmp %>%
		filter(numVotes >= threshold) %>%
		inner_join(principals) %>%
		inner_join(actors) %>%
		select(tconst, nconst)

	estimate_for_t <-
		tmp_df  %>%
			inner_join(tmp_df, by = 'tconst', relationship = "many-to-many") %>%
			filter(nconst.x != nconst.y) %>%
			summarise(
				nodes = n_distinct(nconst.x),
				edges = n() / 2
			)

	estimate <-
		estimate %>%
			add_row(t = threshold, nodes = estimate_for_t %>% select(nodes) %>% pull(), edges = estimate_for_t %>% select(edges) %>% pull())
}

estimate
tmp %>%
	# filter(numVotes >= 50000) %>%
	ggplot(aes(x = numVotes)) +
	geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8) +
	geom_vline(xintercept = 50000) +
	scale_x_log10() +
	theme_bw()

tmp2 <-
	tmp %>%
			# filter(numVotes >= 50000) %>%
			inner_join(principals) %>%
			inner_join(actors)

tmp2 %>%
	select(nconst) %>%
	summarise(n = n_distinct(nconst))

ggsave('density.png')
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