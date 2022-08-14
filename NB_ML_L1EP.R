# Lesson 1: Extra Project
# Out of the 5 datasets that you chose during DSO104, choose a dataset which has 2 variables that you intuit have a linear relationship 
# of some importance. Complete all the assumption tests and create a linear model. Do this in RStudio. 
# Assess R-squared value to see if there is a linear relationship and if all assumptions are met.
# Tip: Make sure to remove NA’s after you create a dataframe with your 2 selected variables

crocodiles <- read.csv("~/Data Science/Machine Learning and Modeling/crocodiles.csv")

install.packages("car")
install.packages("caret")
install.packages("gvlma")
install.packages("predictmeans")
install.packages("e1071")
install.packages("lmtest")

library("car")
library("caret")
library("gvlma")
library("predictmeans")
library("e1071")
library("lmtest")

# question: Does head length of estuarine crocodiles affect body length? Do these two variables show a linear relationship- does a linear regression model fit?

# test for linearity

scatter.smooth(x=crocodiles$HeadLength, y=crocodiles$BodyLength, main="Head and Body Lengths of Estuarine Crocodiles")

# looks linear to me!

# test for homoscedasticity- first, create the model

lmMod <- lm(BodyLength~HeadLength, data=crocodiles)

par(mfrow=c(2,2))
plot(lmMod)

# residuals vs fitted isn't completely straight, but the points do seem random. scale-location is good. just to be sure, BP

lmtest::bptest(lmMod)

# test passed. no cone, so homogeneity passed as well

# test for outliers

CookD(lmMod, group=NULL, plot=TRUE, idn=3, newwd=TRUE)

# 2, 9, and 10 might be problems.leverage values:

lev = hat(model.matrix(lmMod))
plot(lev)

# there are two points that have a leverage value over 0.2.

crocodiles[lev>.2,]

# rows 1 and 2 are outliers in x space.

car::outlierTest(lmMod)

summary(influence.measures(lmMod))

# no values are coming up with a higher dfb or dffit than 1. let's proceed

summary(lmMod)

# there is a very clear and significant relationship between head length and body length of estuarine crocodiles.

# the adjusted R squared value is 98%. Head length explains 98% of the variance of body length.