# choose a dataset that has a continuous variable that you think would be valuable to predict. Also, this dataset must have at least 4 other variables of type numeric or Boolean that can be used as independent variables. Perform stepwise regression in R. It is your choice to do forward or backward elimination. Are there any variables you chose that can be removed without decreasing R-squared?

# using the cars dataset from L3EP, I'm going to perform hybrid stepwise regression to attempt to come up with a best-fitting model for predicting cars' time to accelerate from 0 to 60 MPH.

cars <- read.csv("cars.csv")
head(cars)

# removing any missing values

cars1 <- na.omit(cars)
cars1

# response variable: time.to.60. all others are predictor variables

# starting with baseline, all variables included.

FitAll = lm(time.to.60 ~ ., data = cars1)
summary(FitAll)

# p-value is significant but only three variables are: horsepower, weight in pounds, and cylinders.

# model with none of the predictors

fitstart = lm(time.to.60 ~ 1, data = cars1)
summary(fitstart)

# significant but it only includes the mean of all of the times to 60 mph.

# hybrid stepwise regression

step(fitstart, direction="both", scope=formula(FitAll))

# the resulting model includes the three variables I mentioned above: horsepower, weight in pounds, and cylinders.

# let's run a summary of the new model.

fitBest = lm(time.to.60 ~ hp + weightlbs + cylinders, data = cars)
summary(fitBest)

# this is a much better model than using just one of these variables, weight in pounds, alone.

# these three variables account for 66% of the variance in time to 60 mph.