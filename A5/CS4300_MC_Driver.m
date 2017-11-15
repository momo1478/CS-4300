function score_info = CS4300_MC_Driver(board_runs)
% CS4300_gen_board - generate a Wumpus board
% On input:
%     board_runs (int): number of times w
% On output:
%     score info (struct): 250 of these for each board
%       scores (int X board_runs): all the scores to take mean and variance
%       avg_score (float): avgerage score for each board
%       variance (float): variance of our scores
%       num_succsess (int): num of times passed board out of board runs
%       num_failures (int): num of times failed board out of board runs
%       percent_hit (float): percentage of time hit the wumpus out of shots
% Call:
%     s = CS4300_MC_Driver(10);
% Author:
%     Eric Waugh and Monish Gupta
%     UU
%     Summer 2017
%

load('A5_boards.mat');
for i = 1:250
   score_info(i).scores = [];
   score_info(i).avg_score = 0;
   score_info(i).variance = 0;
   for j = 1:board_runs
       clear functions;
       [s,t] = CS4300_WW1(100,'CS4300_MC_agent',boards(i).board);
       score_info(i).scores = [score_info(i).scores, s];
   end
   score_info(i).avg_score = mean(score_info(i).scores);
   score_info(i).variance = var(score_info(i).scores);
end

end

