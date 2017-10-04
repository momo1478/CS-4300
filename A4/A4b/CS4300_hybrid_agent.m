function action = CS4300_hybrid_agent(percept)
% CS4300_hybrid_agent - hybrid random and logic-based agent
% On input:
%   percept( 1x5 Boolean vector): percepts
% On output:
%   action (int): action selected by agent
% Call:
%   a = CS4300_hybrid_agent([0,0,0,0,0]);
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017

persistent KB;
persistent plan;
persistent safe;
persistent unvisited;

persistent state;

if isempty(KB)
   [,KB,] = CS4300_BR_gen_KB();
end

if isempty(state)
    state = [1,1,0];
end

if isempty(plan)
   plan = []; 
end

if isempty(unvisited)
    unvisited = 2:16;
end

if isempty(safe)
   safe = 1; 
end

end