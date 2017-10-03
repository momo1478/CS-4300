function sentence = CS4300_make_percept_sentence(percept,x,y)
% CS4300_make_percept_sentence - create logical sentence from percept
% On input:
%   percept (1x5 Boolean vector): percept
%       [Stench,Breeze,Glitter,Scream,Bump]
%   x (int): x location of agent
%   y (int): y location of agent
% On output:
%   sentence (KB struct): logical sentence (CNF)
%   (1).clauses (int): 1 if stench, else 0
%   (2).clauses (int): 1 if breeze, else 0
%   (3).clauses (int): 1 if glitter, else 0
%   (4).clauses (int): 1 if scream, else 0
%   (5).clauses (int): 1 if bump, else 0
% Call:
%   s = CS4300_make_percept_sentence([0,1,0,0,0],3,2);
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017

