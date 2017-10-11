function score = CS4300_Heuristic(current_state, goal_state)
% TODO : DO THE HEADER
% Author:
%     T. Henderson
%     UU
%     Fall 2015
%
score = abs(current_state(1) - goal_state(1)) + abs(current_state(2) - goal_state(2));
end
