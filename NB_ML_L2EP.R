library("caret")
library("magrittr")
library("dplyr")
library("tidyr")
library("lmtest")
library("popbio")
library("e1071")

healthCare <- read.csv("/Users/nataliebahr/Documents/DS106/Lesson 2/CleanedInsurance.csv")
head(healthCare)

# already binary coded!

# I want to see if hospital charges are a good predictor of someone being a smoker. the higher the hospital charges, the higher the likelihood that the person smokes

# create the logit model

mylogit <- glm(smoker ~ charges, data=healthCare, family="binomial")

# make predictions

probabilities <- predict(mylogit, type = "response")

probabilities <- predict(mylogit, type = "response")
healthCare$Predicted <- ifelse(probabilities > .5, "pos", "neg")

# recode predicted variable

healthCare$PredictedR <- NA
healthCare$PredictedR[healthCare$Predicted=='pos'] <- 1
healthCare$PredictedR[healthCare$Predicted=='neg'] <- 0

# variables as factors

healthCare$PredictedR <- as.factor(healthCare$PredictedR)
healthCare$smoker <- as.factor(healthCare$smoker)

# confusion matrix- test sample size

conf_mat <- caret::confusionMatrix(healthCare$PredictedR, healthCare$smoker)
conf_mat

# test passed, and the accuracy is 89.9%! Not bad. Moving on to logit linearity

# set up

healthCare1 <- healthCare %>% 
  dplyr::select_if(is.numeric)

predictors <- colnames(healthCare1)

# create the logit

healthCare1 <- healthCare1 %>%
  mutate(logit=log(probabilities/(1-probabilities))) %>%
  gather(key= "predictors", value="predictor.value", -logit)

# graph to assess for linearity

ggplot(healthCare1, aes(logit, predictor.value))+
  geom_point(size=.5, alpha=.5)+
  geom_smooth(method= "loess")+
  theme_bw()+
  facet_wrap(~predictors, scales="free_y")

# 'charges' is perfectly linear. On to independent errors

# graph the errors

plot(mylogit$residuals)

# not confident about the plot- trying Durbin-Watson

dwtest(mylogit, alternative="two.sided")

# good to go. On to outliers

infl <- influence.measures(mylogit)

summary(infl)

# no abnormal values. calling the model!

summary(mylogit)

# the p-value is significant, which means the hospital charges were a significant predictor of whether or not someone smoked.

# graphing the logistic model!

logi.hist.plot(healthCare$charges,healthCare$smoker, boxp=FALSE, type="hist", col="gray")