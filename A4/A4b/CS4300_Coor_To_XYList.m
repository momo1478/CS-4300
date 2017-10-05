function xylist = CS4300_Coor_To_XYList( coords )
% CS4300_Coor_To_XYList - Converts a cell number list to a matrix of
% coordinates (Wumpus World coordinates) (y first, x second)
% On input:
%   coords - (1xn vector) list of cell numbers.
% On output:
%   xylist (2xn matrix) - matrix of translated coords in given order.
% Call:
%   l = CS4300_Coor_To_XYList( 1:16 )
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017
xylist = [];

for i = 1:length(coords)
    y = floor(( coords(i) - 1 )/4) + 1;
    x = rem( coords(i) - 1,4 ) + 1;
    xylist = [xylist; [y,x] ];
end

