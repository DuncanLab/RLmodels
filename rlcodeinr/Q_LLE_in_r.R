Q_LLE = function(Params, pin) {
  alpha = Params[2]
  iTemp = Params[1]
  LLE=0
  
  
  for (d in c(1:2)) {
    #% get data for each deck seperately
    Response=pin$choice[pin$deck==d]
    Reward=pin$payoffs[pin$deck==d]
  
  
    Q = .5*matrix(1,1,2)
    ##note on the 2 to end bit: some people also do trial 1 to n-1
    for (trial in c(2:length(Response))) { 
      choice_last=Response[trial-1]      
      Q_last = Q[trial-1, ] # %prior trial's value estimates
      Q_new = Q_last #% initiate new Qs based on last trial's Qs
  
      #% pick lrate based on outcome
      Q_new[choice_last] = Q_last[choice_last] + (alpha*((Reward[trial-1] - Q_last[choice_last])))
      Q = rbind(Q,Q_new) #% add new Q into vector of Qs
      
    }
    
    #% softmax ###########NOT SURE WHATS UP HERE?????? it doesnt like this what is itemp transpose anyways? its a single number
    Prob=1./(1+(exp(-((t(diff(t(Q))))*iTemp))))
    
    #% find choice probs ###ALSO NOT SURE WHATS UP HERE??
    Prob_choice=matrix(NA,1,length(Response)) ##added this to make somethign work. not sure if its right
    Prob_choice[Response==1] = 1-Prob[Response == 1]
    Prob_choice[Response==2] = Prob[Response == 2]
    
    LLE_Deck = abs(sum(log(Prob_choice)))
    LLE=LLE+LLE_Deck
            
  }
return(LLE)
}

print('check=1')

#% disp(alpha)
#% disp(iTemp)
#% disp(LLE)

#%or could do:
#%lik= lik + iTemp1 * Q(c1(i)) - log(sum(exp(iTemp1 * Q)));


