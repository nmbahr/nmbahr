import pandas as pd
import numpy as np
from scipy.stats import norm
from scipy import stats
from scipy.stats import ttest_ind
import matplotlib.pyplot as plt

anime = pd.read_csv("anime.csv")

anime.head()


# Question 1: Is a rating score of 6.2 different from the mean in this dataset?
# single sample t-test- I'm comparing a single score to the rest.

# test assumption: normality

anime['score'].hist()

# the histogram shows a bell curve. seems normal enough to me.

stats.ttest_1samp(anime['score'], 6.2)

# the p-value is exactly zero, which is less than 0.05, so a score of 6.2 is statistically different compared to the mean. higher or lower?

anime.score.mean()

# the mean is 6.85, so a score of 6.2 is lower than average. that must not be a well-liked anime (or is at least highly criticized).


# Question 2: Does anime that is still airing differ in popularity from anime that is no longer airing?
# I need to do an independent t-test because the two sets of the data are mutually exclusive; I need to determine if they are the same or different in terms of popularity.

# testing for normality

anime.status.value_counts()
anime.popularity[anime.status == 'Currently Airing'].hist()
anime.popularity[anime.status == 'Finished Airing'].hist()

# neither status has popularity scores that are normally distributed, although animes that have finished airing look like half of a bell curve. For the sake of practice, I'm going to continue.

ttest_ind(anime.popularity[anime.status == 'Currently Airing'], anime.popularity[anime.status == 'Finished Airing'])

# the popularity scores are different based on their airing status, to a highly significant degree! 

anime.popularity[anime.status == 'Currently Airing'].mean()
anime.popularity[anime.status == 'Finished Airing'].mean()

# currently airing animes are much more highly rated than ones that have finished airing. I suppose this makes sense because ones that are well-liked end up airing longer than ones that are not as well-liked.


# Question 3: Does the source of the anime influence the type of anime?
# since both of these are categorical, it's an independent chi-square test that I need to do.

# first, I need to recode the variable 'source' to have fewer levels.

# important note! After researching a little, I realized that 'original' as a source doesn't fall into one of the assignment's categories, as the anime is developed specifically to be anime. for this reason, I'm classifying it as a level all its own.
# my five levels are: manga, original, book, game, other. I'm putting "listening" into "other" as I'm more interested in the other four categories and I have no more idea of context.

anime.source.value_counts()

def source_R(source):
    if source == "Original":
        return "Original"
    if source == "Light novel":
        return "Book"
    if source == "Visual novel":
        return "Book"
    if source == "Game":
        return "Game"
    if source == "Novel":
        return "Book"
    if source == "Other":
        return "Other"
    if source == "Music":
        return "Other"
    if source == "Picture book":
        return "Book"
    if source == "Card game":
        return "Game"
    if source == "Book":
        return "Book"
    if source == "Radio":
        return "Other"
    else:
        return "Manga"
    
anime['sourceR'] = anime['source'].apply(source_R)
anime.head()

#contingency table

anime_crosstab = pd.crosstab(anime['sourceR'], anime['type'])
anime_crosstab

# running the independent chi-square; checking the array

stats.chi2_contingency(anime_crosstab)

# because the p-value is incredibly tiny, we know that there is a very significant relationship between the source material of the anime and what type of anime is produced. This makes sense because the source material will often dictate what form the anime can or should take.

# there is a limitation, though, as one of the expected cell counts is less than 5: 3.38. All of the rest are 6.9 or much higher. The misbehaving cell appears to be the intersection of Other source material and Music, which is a very small portion of the data anyway.


# Question 4: How do the variables about popularity/ranking relate to each other?
# I need to correlate the given variables.

anime1 = anime[['score', 'scored_by', 'rank', 'popularity', 'members', 'favorites']]
anime1.head()

anime1.corr(method='pearson').style.format("{:.2}").background_gradient(cmap=plt.get_cmap('coolwarm'), axis=1)

# conclusions from the matrix:

# scored_by and members has a correlation of 0.99- basically the strongest a correlation can be. Are these redundant measures?

# scored_by and favorites has the next highest positive correlation, 0.79.

# members and favorites are correlated fairly strongly as well: 0.78. This makes sense if scored_by and members are very similar to each other.

# popularity and rank are correlated at 0.78, which I'm surprised isn't higher. I need more context on how popularity is measured.

# the highest negative correlation is rank and score: as the number for rank decreases, the score increases, and vice versa. First place would have the highest score!

# popularity and score are also highly but negatively correlated, at -0.69.