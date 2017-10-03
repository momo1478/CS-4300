function [mean_steps,percent_gold,variance_steps,variance_gold,...
    convidence_interval_low_steps,convidence_interval_high_steps,...
    convidence_interval_low_gold,convidence_interval_high_gold] = CS4300_run_trials_A1(num_steps)
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
%   [mean_steps, percent_gold, var_steps, var_gold, con_low_step, con_high_step, con_low_gold, con_high_gold] = CS4300_run_trials_A1(50);
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017
%

mean_steps = 0;
percent_gold = 0;
variance_steps = 0;
variance_gold = 0;
convidence_interval_low_steps = 0;
convidence_interval_high_steps = 0;
convidence_interval_low_gold = 0;
convidence_interval_high_gold = 0;
NUM_ROWS = 4;
sample_steps = zeros(2000,1);
sample_gold = zeros(2000,1);
trial = 0;

while trial<2000
    trial = trial + 1;
    t=CS4300_WW2(num_steps,'CS4300_agent1');
    mean_steps = mean_steps + length(t);
    sample_steps(trial,1) = length(t);
    for i = 1:length(t)
        loc_r = NUM_ROWS - t(i).agent.y + 1;
        loc_c = t(i).agent.x;
        if loc_r==2&&loc_c==2
            sample_gold(trial,1) = 1;
            percent_gold = percent_gold + 1;
            i = length(t);
        end
    end
end

mean_steps = mean_steps / 2000;
percent_gold = percent_gold / 2000;
variance_steps = var(sample_steps(:,1));
variance_gold = var(sample_gold(:,1));

convidence_interval_high_steps = mean_steps + 1.645 * sqrt(variance_steps/2000);
convidence_interval_low_steps = mean_steps - 1.645 * sqrt(variance_steps/2000);

convidence_interval_high_gold = percent_gold + 1.645 * sqrt(variance_gold/2000);
convidence_interval_low_gold = percent_gold - 1.645 * sqrt(variance_gold/2000);
