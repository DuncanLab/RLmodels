% script first loads and transforms data into an output that may be 
% processed by TD_ModelFit

% load the dataset 
% create a new 2D array with 4 columns: subject, choice, pay1Back, PairNum

filename = '/Volumes/homes/Eugenia/TD_Models/GroupOutput.txt';
delimiterIn = '\t';
headerlinesIn = 1;
data = importdata(filename,delimiterIn,headerlinesIn);

data_RL = []; % 2D array to hold 
subject = cellfun(@str2num,data.textdata(2:length(data.textdata), 11));
choice = data.data(1:length(data.data), 2) + 1;
pay = cellfun(@str2num,data.textdata(2:length(data.textdata), 13));
PairNum = cellfun(@str2num,data.textdata(2:length(data.textdata), 2));
novelty = cellfun(@str2num,data.textdata(2:length(data.textdata), 1));
deckSwitch = cellfun(@str2num,data.textdata(2:length(data.textdata), 9));
delay = cellfun(@str2num,data.textdata(2:length(data.textdata), 8));

data_RL = [subject, choice, pay, PairNum];
data_RL_nov = [subject, choice, pay, PairNum, novelty,deckSwitch, delay];


% Need to prune rows where no response
nanInd=find(isnan(choice));
data_RL(nanInd,:)=[];
data_RL_nov(nanInd,:)=[];

% TD_ModelFit(data_RL);
 TD_ModelFit_Novelty(data_RL_nov);
 TD_ModelFit_Novelty_Alpha(data_RL_nov);
% TD_ModelFit_Novelty_WM(data_RL_nov);

load('fits_TD.mat')
load('fits_TD_nov.mat')

BIC_Basic=2*(sum(fits(:,4)))+2*32*log(11263);
BIC_Nov=2*(sum(fits_nov(:,5)))+3*32*log(11263);

AIC_Basic=2*(sum(fits(:,4)))+2*32;
AIC_Nov=2*(sum(fits_nov(:,5)))+3*32;


load('fits_TD.mat')
load('fits_TD_nov_alpha.mat')

BIC_Basic=2*(sum(fits(:,4)))+2*32*log(11263);
BIC_Nov=2*(sum(fits_nov(:,5)))+3*32*log(11263);

AIC_Basic=2*(sum(fits(:,4)))+2*32;
AIC_Nov=2*(sum(fits_nov(:,5)))+3*32;

