function [LLE] = Q_LLE(Params, pin)


alpha = Params(2);
iTemp = Params(1);
LLE=0;


for d=1:2
    % get data for each deck seperately
    Response=pin.choice(pin.deck==d);
    Reward=pin.payoffs(pin.deck==d);
    
    Q = .5*ones(1,2);
    for trial=2:length(Response);
        choice_last=Response(trial-1);      
        Q_last = Q(trial-1, :); %prior trial's value estimates
        Q_new = Q_last;  % initiate new Qs based on last trial's Qs
        
        % pick lrate based on outcome
        Q_new(choice_last) = Q_last(choice_last) + (alpha*((Reward(trial-1) - Q_last(choice_last))));
        Q(end+1,:) = Q_new; % add new Q into vector of Qs
        
    end
    
    %softmax
    Prob=1./(1+(exp(-((diff(Q')'*iTemp')))));
    %find choice probs
    Prob_choice(Response==1) = 1-Prob((Response == 1));
    Prob_choice(Response==2) = Prob((Response == 2));
    
    LLE_Deck = abs(sum(log(Prob_choice)));
    LLE=LLE+LLE_Deck;
    
end

check=1;

% disp(alpha)
% disp(iTemp)
% disp(LLE)

%or could do:
%lik= lik + iTemp1 * Q(c1(i)) - log(sum(exp(iTemp1 * Q)));


