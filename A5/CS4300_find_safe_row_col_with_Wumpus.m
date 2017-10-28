function state = CS4300_find_safe_row_col_with_Wumpus(board,Wx,Wy)
% CS4300_Plan_Shot - Returns (x,y,dir) state that will have us pointing
%                    towards the wumpus location
% On Input:
%   board (nxn matrix) :    safe board
%   Wx    (int)        :    Wumpus X pos to shoot at
%   Wy    (int)        :    Wumpus Y pos to shoot at
% On Output:
%   state (1x3 matrix) : the x, y and dir of state returned
% Call:
%   S = CS4300_find_safe_row_col_with_Wumpus(safe_board,3,3)
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017

%checking spots to the left of wumpus spot
for i = 1:4
   if i < Wx && board(4 - Wy + 1, i) == 0
        x = i; y = Wy; dir = 0; %is facing right
        state = [x, y, dir];
        return;
   end
end

%checking spots to the right of wumpus spot
for i = 1:4
   if i > Wx && board(4 - Wy + 1, i) == 0
        x = i; y = Wy; dir = 2; %is facing left
        state = [x, y, dir];
        return;
   end
end

%checking spots above of wumpus spot
for i = 1:4
   if i > Wy && board(4 - i + 1, Wx) == 0
        x = Wx; y = i; dir = 3; %is facing down
        state = [x, y, dir];
        return;
   end
end

%checking spots below of wumpus spot
for i = 1:4
   if i < Wy && board(4 - i + 1, Wx) == 0
        x = Wx; y = i; dir = 1; %is facing up
        state = [x, y, dir];
        return;
   end
end

end

