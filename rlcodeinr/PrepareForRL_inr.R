## script first loads and transforms data into an output that may be 
## processed by TD_ModelFit

## load the dataset 
## create a new 2D array with 4 columns: subject, choice, pay1Back, PairNum

#some stray code at the bottom runs the analysis and does some summary stats I believe.

############change me
filename = 'C:/Users/Thalia/Dropbox/RL_code_inr/RLmodels-master/TD_Models/GroupOutput.txt'
delimiterIn = '\t'
headerlinesIn = 1
data = read.table(filename,delimiterIn,header=TRUE)

#rename from the input datafile just because of how Katherine set it up
names(data)[11] <- "subject"
names(data)[13] <- "pay"
names(data)[1] <- "novelty"
names(data)[9] <- "deckSwitch"
names(data)[8] <- "delay"


data$choice=data$choice+1
#choice = data.data(1:length(data.data), 2) + 1; what was this line of matlab code doing??????????/
######## it migth be adding 1 to the second col of the data which is pairnum...

# Need to prune rows where no response
data_no_na=data[which(!is.na(data$choice)),]

data_RL = data_no_na[,c('subject','choice','pay','PairNum')]
data_RL_nov = data_no_na[,c('subject','choice','pay','PairNum','novelty','deckSwitch','delay')]
#this second one was used for something else, not the basic model

##########DONE SETTING UP DATA###########

setwd('C:/Users/Thalia/Dropbox/RL_code_inr')


#for testing code, get only 1 sub1:
data_RL_1sub = data_RL[data_RL$subject==1,]
##run rl model
TD_ModelFit(data_RL_1sub)
##done testing

####Before running this must run code for Q_LLE and TD_modelfit

##run rl model
TD_ModelFit(data_RL)
#TD_ModelFit_Novelty(data_RL_nov);
#TD_ModelFit_Novelty_Alpha(data_RL_nov);
# TD_ModelFit_Novelty_WM(data_RL_nov);

###looking at the outputs and doing model comparison (other model is not setup yet)

fits=readRDS('fits_TD.rds')
fits_nov=readRDS('fits_TD_nov.rds')

BIC_Basic=2*(sum(fits[,4))+2*32*log(11263);
BIC_Nov=2*(sum(fits_nov[,5]))+3*32*log(11263);

AIC_Basic=2*(sum(fits[,4]))+2*32;
AIC_Nov=2*(sum(fits_nov[,5]))+3*32;
