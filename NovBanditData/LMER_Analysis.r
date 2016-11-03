setwd("/Volumes/home/Eugenia/NovBanditData/")
data<-read.table("Bandit_V3_BasicNew.txt",header=T)
library(lme4)
library(lmerTest)
library(ggplot2)

# Figure out which subjects didn't do task
data$Sub<-as.factor(data$Sub)
data$PayQuad<-(data$Pay1Back-.5)^2
nSub<-length(levels(data$Sub))
Pay1Back<- vector(length = nSub) # how much you got the last time saw particular decks 
Mat1Back <-Pay1Back #was the mat novel the last time you saw particular decks

sCount=0
for (i in levels(data$Sub)){
  sCount=sCount+1
  model1 <- glm(Stay~Pay1Back,data=data,family=binomial, subset=(Sub==i))  # how much does next choice depend on feedback
  model2 <- glm(Stay~Mat1Back,data=data,family=binomial, subset=(SwitchDecks==1&Sub==i)) # how much does next choice depend on novelty
  
  Mi<-summary(model1)
  Pay1Back[sCount] <- Mi$coefficients[2, 1]
  
  Mi<-summary(model2)
  Mat1Back[sCount] <- Mi$coefficients[2, 1]
}

MatClean<-c(Mat1Back[1:14], Mat1Back[16:26], Mat1Back[28:31])

dataClean<-subset(data,Sub!=15 & Sub!=27 & Sub!=32) # figure out how to remove levels

# just novelty
summary(mod2_Deck<-glmer(Stay~Mat1Back+(Mat1Back|Sub),dataClean, family=binomial, subset=(SwitchDecks==1)))
summary(mod2_Deck<-lmer(Stay~Mat1Back+(Mat1Back|Sub),dataClean, subset=(SwitchDecks==1)))  # linear model <- easier to read but not statistically appropriate

summary(mod2_Deck<-glmer(Stay~Mat1Back+(Mat1Back|Sub),dataClean, family=binomial))

# good model - accounts for both factors
summary(mod2_Deck<-glmer(Stay~Pay1Back+Mat1Back+(Pay1Back+Mat1Back||Sub),dataClean, family=binomial, subset=(SwitchDecks==1)))

#  doesn't tell us much
summary(mod2_Deck<-glmer(Stay~Pay1Back+PayQuad*Mat1Back+(Pay1Back+PayQuad*Mat1Back||Sub),dataClean, family=binomial, subset=(SwitchDecks==1)))  #includes interaction between variables




