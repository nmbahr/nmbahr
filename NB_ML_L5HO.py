# Lesson 5 Hands-On: Profit Simulation!

import random
import numpy as np

# to create the simulation, first I need to create each distribution, starting with resource factor, a normal distribution 

rf = (np.random.normal(size=100))*1.2 + 3
print(rf)

# units sold, normal

us = (np.random.normal(size=100)*5.7 + 26)
print(us)

# price, discrete

# discrete distribution help from https://compucademy.net/discrete-probability-distributions-with-python/

import matplotlib.pyplot as plt
import seaborn as sns

NUM_ROLLS = 100

values = [38, 41.50, 36.25]
probs = [0.55, 0.3, 0.15]

# 1. draw a weighted sample

price = np.random.choice(values, NUM_ROLLS, p=probs)

# 2. Numpy arrays containing counts for each side
side, count = np.unique(price, return_counts=True)
probs = count / len(price)

# 3. Plot the results (I didn't really have to do this, but I was following the website tutorial)

sns.barplot(side, probs)
plt.title(
    f"Discrete Probability Distribution for Price ({NUM_ROLLS} rolls)")
plt.ylabel("Probability")
plt.xlabel("Outcome")
plt.show()

# cost, uniform

# uniform dist help from: https://numpy.org/doc/stable/reference/random/generated/numpy.random.uniform.html
# and then I clicked "Quick Start"

from numpy.random import default_rng
rng = default_rng()
cost = rng.uniform(low=26.88, high=33.72, size=100)
print(cost)

# now, I put them all together using the formula given

profit = (rf * us * price) - ((0.2) * rf * us * cost) + 320

# showing a histogram of the result

# help in showing end result as a histogram: https://www.statology.org/generate-normal-distribution-python/#:~:text=You%20can%20quickly%20generate%20a%20normal%20distribution%20in,scale%3D1.0%2C%20size%3DNone%29%20where%3A%20loc%3A%20Mean%20of%20the%20distribution.

count, bins, ignored = plt.hist(profit, 100)
plt.show()

# from this I learned that the profits will likely fall in the $2000-$4000 range.


# creating a data frame- I need to show the data in its entirety in 100 rows.

# https://www.tutorialspoint.com/python_pandas/python_pandas_dataframe.htm

import pandas as pd

data = {'Units Sold':(us),'Price':(price),'Cost':(cost),'Resource Factor':(rf),'Profit':(profit)}
df = pd.DataFrame(data)
print(df)
