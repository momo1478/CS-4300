function is_ok = CS4300_board_ok(board, breezes, stenches)
% CS4300_board_ok - checks if board generated matches our breezes and
% stenches
% On input:
%     board (4x4 Int array): board generated with wumpus, gold or pits
%        1: a pit spot
%        2: a gold spot
%        3: a wumpus spot
%     breezes (4x4 Boolean array): presence of breeze percept at cell
%       -1: no knowledge
%        0: no breeze detected
%        1: breeze detected
%     stench (4x4 Boolean array): presence of stench in cell
%       -1: no knowledge
%        0: no stench detected
%        1: stench detected
% On output:
%     is_ok (Boolean): says whether board was ok or not
% Call:
%     breezes = -ones(4,4);
%     breezes(4,1) = 1;
%     stench = -ones(4,4);
%     stench(4,1) = 0;
%     board = CS4300_gen_board_no_GW(.2);
%     ok = CS4300_board_ok(board, breezes, stenches);
% Author:
%     Eric Waugh and Monish Gupta
%     u0947296 and u1008121
%     Fall 2017


for i = 1:16
    if rem(i,4) == 1 %left side no nieghbor to left
        neighbors = [i + 1, i + 4, i - 4];
    elseif rem(i,4) == 0 %right side no nieghbor to right
        neighbors = [i - 1, i + 4, i - 4];
    else
        neighbors = [i - 1, i + 1, i + 4, i - 4];
    end
    wumpus_x = rem(i - 1,4) + 1;
    wumpus_y = floor((i - 1)/4) + 1;
    
    matlab_x = 4 - wumpus_y + 1;
    matlab_y = wumpus_x;
    if stenches(matlab_x, matlab_y) == 1
        is_ok = 0;
        for j = 1:length(neighbors)
           if neighbors(j) > 0 && neighbors(j) < 17
               wumpus_x_neighbor = rem(neighbors(j) - 1,4) + 1;
               wumpus_y_neighbor = floor((neighbors(j) - 1)/4) + 1;
               
               matlab_x_neighbor = 4 - wumpus_y_neighbor + 1;
               matlab_y_neighbor = wumpus_x_neighbor;
               if board(matlab_x_neighbor, matlab_y_neighbor) == 3
                   is_ok = 1;
                   break;
               end
           end
        end
        if is_ok == 0
           return; 
        end
    elseif stenches(matlab_x, matlab_y) == 0
        is_ok = 1;
        for j = 1:length(neighbors)
           if neighbors(j) > 0 && neighbors(j) < 17
               wumpus_x_neighbor = rem(neighbors(j) - 1,4) + 1;
               wumpus_y_neighbor = floor((neighbors(j) - 1)/4) + 1;
               
               matlab_x_neighbor = 4 - wumpus_y_neighbor + 1;
               matlab_y_neighbor = wumpus_x_neighbor;
               if board(matlab_x_neighbor, matlab_y_neighbor) == 3
                   is_ok = 0;
                   break;
               end
           end
        end
        if is_ok == 0
           return; 
        end
    end
    
    if breezes(matlab_x, matlab_y) == 1
        is_ok = 0;
        for j = 1:length(neighbors)
           if neighbors(j) > 0 && neighbors(j) < 17
               wumpus_x_neighbor = rem(neighbors(j) - 1,4) + 1;
               wumpus_y_neighbor = floor((neighbors(j) - 1)/4) + 1;
               
               matlab_x_neighbor = 4 - wumpus_y_neighbor + 1;
               matlab_y_neighbor = wumpus_x_neighbor;
               if board(matlab_x_neighbor, matlab_y_neighbor) == 1
                   is_ok = 1;
                   break;
               end
           end
        end
        if is_ok == 0
           return; 
        end
    elseif breezes(matlab_x, matlab_y) == 0
        is_ok = 1;
        for j = 1:length(neighbors)
           if neighbors(j) > 0 && neighbors(j) < 17
               wumpus_x_neighbor = rem(neighbors(j) - 1,4) + 1;
               wumpus_y_neighbor = floor((neighbors(j) - 1)/4) + 1;
               
               matlab_x_neighbor = 4 - wumpus_y_neighbor + 1;
               matlab_y_neighbor = wumpus_x_neighbor;
               if board(matlab_x_neighbor, matlab_y_neighbor) == 1
                   is_ok = 0;
                   break;
               end
           end
        end
        if is_ok == 0
           return; 
        end
    end
end

end

