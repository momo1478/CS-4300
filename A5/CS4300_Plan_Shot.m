function plan = CS4300_Plan_Shot(safe_board, state, Wx, Wy )
% CS4300_Plan_Shot - Returns a plan to navigate to a safe spot and shoot in
%                    a direction toward the Wumpus.
% On input:
%   safe_board (nxn matrix) :    safe board
%   state (1x3 vector) :    vector representing agent state
%   Wx    (int)        :    Wumpus X pos to shoot at
%   Wy    (int)        :    Wumpus Y pos to shoot at
% On output:
%   plan (int)         :    plan of actions that results in a shot at(Wx,WY)
% Call:
%   a = CS4300_Plan_Shot( 1:16, zeroes(4,4), state, 2, 2 )
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017

plan = [];
S = CS4300_find_safe_row_col_with_Wumpus(safe_board,Wx,Wy);
[so,no] = CS4300_Wumpus_A_star(abs(safe_board),...
    [state(1),state(2),state(3)],S,'CS4300_A_star_Man');
turn = CS4300_turn_plan(S, so);
if ~isempty(so)
    plan = [so(2:end,end);turn;5];
    plan = reshape(plan,[1,length(plan)]);
end

end

