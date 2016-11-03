function [fits, sdev_fits]=TD_ModelFit(v_choice)

subjs = unique(v_choice(:,1));

% set options for fmincon
options = optimset('TolX', 0.00001, 'TolFun', 0.00001, 'MaxFunEvals', 900000000,'LargeScale','off', 'Algorithm', 'interior-point');

num_start_pts = 5; % number of different starting points
lower_bnd = [-20 0 ]; % bounds for 1 beta and 1 alpha and 1 lambda(novelty)
upper_bnd = [20  1 ];

% initiate output variables
fits=[];
sdev_fits=[];

for subdex=1:length(subjs)
    
    this_subj=subjs(subdex, 1);
    disp(['Subject ' num2str(this_subj)]);
    
    %get subject trls
    
    % get and name relevant data for current subject & task
    subj_choice = v_choice(find((v_choice(:,1)==this_subj)), :);
    pin.choice=subj_choice(:,2);
    pin.payoffs=subj_choice(:,3);
    pin.deck=subj_choice(:,4);
   
    sub_params = [];
    sub_LLEs = [];
    
    % fit model at different random starting points
    for reps = 1:num_start_pts
        init_params=rand(1, length(lower_bnd));
        
        [params, LLE, exitflag]=fmincon(@(params) ...
            Q_LLE(params, pin), init_params, ...
            [],[],[],[], lower_bnd, upper_bnd, [], options);
        
        sub_params = [sub_params; params];
        sub_LLEs = [sub_LLEs; LLE];
    end
    
    %output 
    
    best_lle = find(sub_LLEs==min(sub_LLEs));
    % if there are no best fits
    if isempty(best_lle)
        best_lle = 1;
    end
    %if there's multiple best fits
    if length(best_lle)>1
        best_lle = best_lle(1);
    end
     
    sub_output = [this_subj sub_params(best_lle,:) sub_LLEs(best_lle,:) std(sub_LLEs)];
    sdev_sub = [this_subj std(sub_params)];
    
    % calcualte pseudo r-sqaured
    LLE_Chance = abs(sum(log(0.5*ones(length(subj_choice),1))));
    Pr2  = (sub_LLEs(best_lle,:) - LLE_Chance)/(-LLE_Chance);
    
    fits=[fits; [sub_output Pr2]];
    sdev_fits = [sdev_fits; sdev_sub];
    
    % saves best fits after each subject
    save('fits_TD','fits');
    save('sdev_TD','sdev_fits');
end

