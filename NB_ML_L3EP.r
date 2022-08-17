#  Create a linear, quadratic and exponential model. Assess R-squared value for each to see which of the 3 models fits best.

library("car")
library("caret")
library("gvlma")
library("predictmeans")
library("e1071")
library("lmtest")

cars <- read.csv("cars.csv")
head(cars)

# question: does weight in pounds influence the time it takes to reach 60 mph? If so, what relationship is it- linear, quadratic or exponential?

# linear regression

# testing for linearity

scatter.smooth(x=cars$weightlbs, y=cars$time.to.60, main="Time to 60 MPH by Weight")

# not super linear, but moving on for the sake of creating a model (one of the others should be better, I predict!).

# testing for homoscedasticity and homogeneity of variance

# create the linear model

lmMod <- lm(time.to.60~weightlbs, data=cars)

# graphs to help test

par(mfrow=c(2,2))
plot(lmMod)

# relatively straight lines and no cones in the left two plots. just to be sure- BP test

lmtest::bptest(lmMod)

# absolutely insignificant, so no heteroscedasticity. moving on

# screening for outliers

# x space- Cook's D

CookD(lmMod, group=NULL, plot=TRUE, idn=3, newwd=FALSE)

# 52, 96, and 236 looking like outliers. test for leverage

lev = hat(model.matrix(lmMod))
plot(lev)

# leverage values good. on to y space outliers

car::outlierTest(lmMod)

# I definitely have at least one outlier according to the Bonferroni p value and raw studentized deleted residual!

# influential outliers test

summary(influence.measures(lmMod)
        
# no values for dfb.1_ or dffit are greater than 1, so I'm going to proceed.
        
# OLS Regression
        
summary(lmMod)
        
# according to this model, the weight of the car has significant influence on the time it takes the car to reach 60 mph from 0. however, it only accounts for 23% of the variance. this model is significant but could be a lot better.
        
# quadratic regression

# graph a quadratic relationship
        
quadPlot <- ggplot(cars, aes(x = weightlbs, y = time.to.60)) + geom_point() + stat_smooth(method = "lm", formula = y ~x + I(x^2), size =1)
quadPlot
        
# not a great fit, but we'll see if it ends up working out better than the linear model.
        
weightsq <- cars$weightlbs^2
        
quadModel <- lm(cars$time.to.60~cars$weightlbs+weightsq)
summary(quadModel)
        
# not significant at all. on to exponential model
        
exMod <- lm(log(cars$time.to.60)~cars$weightlbs)
summary(exMod)
        
# this one did slightly better than the linear model! 25% of the variance in stopping time can be attributed to a car's weight.
        
        
# conclusion: there are clearly other variables at work here. as for model fit:
        # exponential model: significant at 25% of the variance represented
        # linear model: significant at 23% of the variance represented
        # quadratic model: not significant

# lesson 4 extra project: stepwise regression. I will continue with this dataset in an attempt to find a better model to predict time to 60!