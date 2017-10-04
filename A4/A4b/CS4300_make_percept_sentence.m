function sentence = CS4300_make_percept_sentence(percept,x,y)
% CS4300_make_percept_sentence - create logical sentence from percept
% On input:
%   percept (1x5 Boolean vector): percept
%       [Stench,Breeze,Glitter,Scream,Bump]
%   x (int): x location of agent
%   y (int): y location of agent
% On output:
%   sentence (KB struct): logical sentence (CNF)
%       (1).clauses (int): c1 (index of Sxy if stench), else -c1
%       (2).clauses (int): c2 (index of Bxy if breeze), else -c2
%       (3).clauses (int): c3 (index of Gxy if glitter), else -c3
%       (4).clauses (int): c4 (index of Cxy if scream), else -c4
%       (5).clauses (int): c5 (index of Exy if bump), else -c5
% Call:
%   s = CS4300_make_percept_sentence([0,1,0,0,0],3,2);
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017
%

breeze_offset = 0;
glitter_offset = 16;
pit_offset = 32;
stench_offset = 48;
wumpus_offset = 64;
location = (x - 1) * 4 + y;

sentence = [];

%stench case
if percept(1) == 0
    sentence(1).clauses = -1 * (location + stench_offset);
else
    sentence(1).clauses = location + stench_offset;
end

%breeze case
if percept(2) == 0
    sentence(2).clauses = -1 * (location + breeze_offset);
else
    sentence(2).clauses = location + breeze_offset;
end

%glitter case
if percept(3) == 0
    sentence(3).clauses = -1 * (location + glitter_offset);
else
    sentence(3).clauses = location + glitter_offset;
end

%sentence(4).clauses = [];
%sentence(5).clauses = [];

end