subjs=[1:7 9 10 12:26 28:35];
dataDir='/Volumes/home/NovBanditData/';
% codeDir='/Users/katherineduncan/Desktop/Door3/Door3_Bandit/Simulations/code';
home=pwd;

for s=1:length(subjs)
    load([dataDir num2str(subjs(s)) '_Output/Performance'])
    NaNs=nan(1,360);
    choice=Performance.choice.choice;
    pay=Performance.pay.PayDolar;
    deck=Performance.condition.PairNum;
    mat=Performance.condition.MatOldNew;
    
    % break into deck pairs
    ChoseRed=choice(deck==1);
    ChoseOrange=choice(deck==2);
    OutcomeRed=pay(deck==1);
    OutcomeOrange=pay(deck==2);
    
    % do you stick with the same deck
    StayRed=[nan (ChoseRed(1:end-1)==ChoseRed(2:end))];
    StayRed(isnan(ChoseRed(2:end)))=nan; % deal with missed responses
    StayOrange=[nan (ChoseOrange(1:end-1)==ChoseOrange(2:end))];
    StayOrange(isnan(ChoseOrange(2:end)))=nan;  % deal with missed responses
    
    % how much did you get last time
    PayRed1Back=[nan OutcomeRed(1:end-1)];
    PayOrange1Back=[nan OutcomeOrange(1:end-1)];
    
    % Put variables back into the order that they happened
    Stay(deck==1)=StayRed;
    Stay(deck==2)=StayOrange;
    Pay1Back(deck==1)=PayRed1Back;
    Pay1Back(deck==2)=PayOrange1Back;
    
    % decorative mats
    MatRed=mat(deck==1);
    MatOrange=mat(deck==1);
    MatRed1Back=[NaN MatRed(1:end-1)];
    MatOrange1Back=[NaN MatOrange(1:end-1)];
    Mat1Back(deck==1)=MatRed1Back;
    Mat1Back(deck==2)=MatOrange1Back;
    
    % make variables to indicate when decks switch
    switchDecks=[NaN deck(1:end-1)~=deck(2:end)]; % 1=deck switched 0=same deck
    delayDecks=switchDecks;
    delayDecks(switchDecks==1)=diff(find(switchDecks))'; % how many trials since the deck switched
    switchDecksRed=switchDecks(deck==1);
    switchDecksOrange=switchDecks(deck==2);
    switchDecksRed1Back=[nan switchDecksRed(1:end-1)];
    switchDecksOrange1Back=[nan switchDecksOrange(1:end-1)];
    switch1Back(deck==1)=switchDecksRed1Back;
    switch1Back(deck==2)=switchDecksOrange1Back;
    
    
    % figure out 1Back outcomes according to actual trial number - weird
    % Katherine interest
    Pay1BackTrial=[nan pay(1:end-1)];
    OutcomeRed1TrialBack=Pay1BackTrial(deck==1); %pay before choosing from each deck
    OutcomeOrange1TrialBack=Pay1BackTrial(deck==2);
    PayRed1BackTrial=[nan OutcomeRed1TrialBack(1:end-1)];
    PayOrange1BackTrial=[nan OutcomeOrange1TrialBack(1:end-1)];
    Pay1BackTrial(deck==1)=PayRed1BackTrial;
    Pay1BackTrial(deck==2)=PayOrange1BackTrial;
    
    % put everything into same output
    Performance.condition.Pay1Back=Pay1Back;
    Performance.condition.Pay1BackTrial=Pay1BackTrial;
    Performance.condition.Mat1Back=Mat1Back;
    Performance.condition.DelayDecks=delayDecks;
    Performance.condition.SwitchDecks=switchDecks;
    Performance.condition.Switch1Back=switch1Back;
    Performance.condition.Sub=ones(size(Performance.condition.PairNum))*s;
    Performance.condition.Trial=[1:length(Performance.condition.PairNum)];
    Performance.condition.Pay=pay;
    Performance.choice.Stay=Stay;
    
    % turn structures into datasets
    choice=struct2dataset(structfun(@transpose,Performance.choice,'UniformOutput',false));
    cond=struct2dataset(structfun(@transpose,Performance.condition,'UniformOutput',false));
    DS_Sub=[cond choice];
    if s==1
        DS=DS_Sub;
    else
        DS=[DS; DS_Sub];
    end   
end

cd(home);
export(DS,'file', 'GroupOutput.txt')

