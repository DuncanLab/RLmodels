#r code td model fit

#optimizer code is not set up particularly well, skipped all teh options.
#also currently has upper and lower bounds on parameters that can be changed or set to +/- inf


TD_ModelFit = function(v_choice) {
  subjs = unique(v_choice[,1])

  # set options for fmincon
  ###########need to fix this for r....
  #options = optimset('TolX', 0.00001, 'TolFun', 0.00001, 'MaxFunEvals', 900000000,'LargeScale','off', 'Algorithm', 'interior-point');
  
  #########NOTE KATHERINE SAID THIS HELPS GET MORE STABLE VALUES BUT NOT REALLY HOW YOU SHOULD DO IT
  ##HOWEVER IF WE DONT CARE ABOUT THE ACTUAL VALUES OF HTE PARAMETERS ITS OK TO SET THEM TO -Inf or Inf
  num_start_pts = 5 # number of different starting points
  lower_bnd = c(-20, 0) # % bounds for 1 beta and 1 alpha and 1 lambda(novelty)
  upper_bnd = c(20,  1) 
  
  #% initiate output variables
  fits=c()
  sdev_fits=c()
  
  for (subdex in c(1:length(subjs))) {
    
    this_subj=subjs[subdex] #########what is this matlab indexing doing?? [subdex, 1]
    print(paste('Subject', this_subj))
    
    #%get subject trls
    
    #% get and name relevant data for current subject & task
    subj_choice = v_choice[which(v_choice[,1]==this_subj),] ###this takes all the cols for sub n, not sure if its what we wanted
    
    choice=subj_choice[,2]
    payoffs=subj_choice[,3]
    deck=subj_choice[,4]
    pin=data.frame(choice,payoffs,deck)
    
    sub_params = c()
    sub_LLEs = c()
    
    
    #% fit model at different random starting points
    for (reps in c(1:num_start_pts)) {
      #init_params=runif(1, min=1, max=length(lower_bnd)) #get random nums
      #####above in teh matlab code was only 1 number. seems to need two.
      init_params=runif(2, min=1, max=length(lower_bnd)) #get random nums
      
  
      #########FIX THIS BITTTT
      #[params, LLE, exitflag]=fmincon(@(params) ...
      #                                Q_LLE(params, pin), init_params, ...
      #                                [],[],[],[], lower_bnd, upper_bnd, [], options);
      
      #####check out how inputs to qlle are working, also i skipped all the options and have no idea if this is right
      ##note method l-bfgs-b is used for upper and lower bounds on variables
      
      optim_output = optim(par=init_params, Q_LLE, pin=pin, method="L-BFGS-B",
            lower = lower_bnd, upper = upper_bnd) ### not sure what all the boxes and options are up there
      
      sub_params = rbind(sub_params, optim_output$par)
      sub_LLEs = rbind(sub_LLEs, optim_output$value)
    }
    
    #output 
    best_lle = min(sub_LLEs)
    
    #% if there are no best fits ##if sub_LLEs is empty
    if (best_lle==Inf) {
    best_lle = 1
    }
    
    #%if there's multiple best fits
    if (length(best_lle)>1) {
    best_lle = best_lle[1]
    }
    
    sub_output = c(this_subj, sub_params[which(sub_params==best_lle),], sub_LLEs[which(sub_params==best_lle),], sd(sub_LLEs)) ##not sure if i got the stuff with best_lle right...
    sdev_sub = c(this_subj, sd(sub_params))
    
    #% calcualte pseudo r-sqaured
    LLE_Chance = abs(sum(log(0.5*matrix(1, length(subj_choice), 1))))
    Pr2  = (sub_LLEs[which(sub_params==best_lle),] - LLE_Chance)/(-LLE_Chance) ##again not sure about bestlle indexing...
    
    fits=rbind(fits, c(sub_output, Pr2)) #check shape of this
    sdev_fits = rbind(sdev_fits, sdev_sub)
    
    #% saves best fits after each subject
    saveRDS(fits,'fits_TD.rds')
    saveRDS(sdev_fits,'sdev_TD.rds')
  }
  
  toreturn= c(fits, sdev_fits)
  return(toreturn)
}