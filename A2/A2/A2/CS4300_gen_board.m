function board = CS4300_gen_board(p)
% CS4300_gen_board - generate a Wumpus board
% On input:
%     p (float): probability of pit in room
% On output:
%     board (4x4 int array): Wumpus board
%       0: nothing in room
%       1: pit in room
%       2: gold in room
% Call:
%     b = CS4300_gen_board(0.2);
% Author:
%     Eric Waugh and Monish Gupta
%     UU
%     Summer 2017
%

PIT = 1;
GOLD = 2;

done = 0;
while done==0
    board = double(rand(4,4)<p);
    if sum(sum(board))<15
        done = 1;
    end
end
board(4,1) = 1;
[rows,cols] = find(~board);
board(4,1) = 0;
num_open = length(rows);
loc_g = randi(num_open);

board(rows(loc_g),cols(loc_g)) = GOLD;

