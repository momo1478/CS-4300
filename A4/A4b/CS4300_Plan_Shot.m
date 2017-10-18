function plan = CS4300_Plan_Shot( safe, board, state, Wx, Wy )
% CS4300_Plan_Shot - Returns a plan to navigate to a safe spot and shoot in
%                    a direction toward the Wumpus.
% On input:
%   safe (1xn int vector) : vector of speces that are safe.
%   board (nxn matrix) :    game board
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

S = CS4300_find_safe_row_col_with_Wumpus(safe,board,Wx,Wy);
% S == [sx,sy,0]
[so,no] = CS4300_Wumpus_A_star(abs(board),[state(1),state(2),state(3)],S);
turn = CS4300_turn_plan(S , so);
plan = [so(2:end,end),turn,SHOOT];

end

