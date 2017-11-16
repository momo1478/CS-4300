function [percent_alive,percent_success,variance_alive,variance_success,...
    convidence_interval_low_alive,convidence_interval_high_alive,...
    convidence_interval_low_success,convidence_interval_high_success]...
    = CS4300_run_trials_EC(num_steps)
% CS4300_run_trials - run agent1 on WW1 said number of times
%   It runs agent1 on WW1 and records data on said trials
% On input:
%   num_steps (int): number of steps we will use when running 2000 times
% On output:
%   mean_steps (float): average number of steps taken
%   percent_gold (float): percent of times agent reaches the gold space
%   variance (float): variance on the number of steps taken
%   convidence_interval (float): the 95% convidence interval
% Call:
%   [per_al, per_suc, var_al, var_suc, c_low_al, c_high_al, c_low_su,
%  c_high_su] = CS4300_run_trials_EC(50);
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017
%

num_alive = 0;
num_success = 0;
sample_alive = [];
sample_success = [];
trial = 0;

while trial<50
    trial = trial + 1;
    t=CS4300_WW2(num_steps,'CS4300_agent_Astar_PC');
    sample_alive = [sample_alive,t(size(t,2)).agent.alive];
    sample_success = [sample_success, t(size(t,2)).agent.succeed];
    if t(size(t,2)).agent.alive == 1
       num_alive = num_alive + 1; 
    end
    if t(size(t,2)).agent.succeed == 1
       num_success = num_success + 1; 
    end
end

percent_alive = num_alive / trial;
percent_success = num_success / trial;
variance_alive = var(sample_alive);
variance_success = var(sample_success);

convidence_interval_high_alive = percent_alive + 1.645 *...,
    sqrt(variance_alive/trial);
convidence_interval_low_alive = percent_alive - 1.645 *...,
    sqrt(variance_alive/trial);

convidence_interval_high_success = percent_success + 1.645 *...,
    sqrt(variance_success/trial);
convidence_interval_low_success = percent_success - 1.645 *...,
    sqrt(variance_success/trial);
