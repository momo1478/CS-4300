function plan = CS4300_Plan_Route(start_state, dests, safe_spots)
% CS4300_Plan_Route - Plans A Route from the current state to all
%                     destinations in dests using safe spots and A* pathfinding.
% On input:
%   start_state - (1x3 vector) starting state of agent.
%   dests       - (2xd matrix) matrix of x,y destinations to map to
%   safe_spots  - (4x4 matrix of 1s or 0s) board representation of safe
%   spots.
% On output:
%   plan (1xn vector) - A sequence of actions to reach all destinations.
% Call:
%   p = CS4300_Plan_Route([1,1,0] , [1,2;2,1;2,2] , zeros(4,4));
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017

%[so,no] = CS4300_Wumpus_A_star([0,0,0,0;0,2,1,3;0,0,0,1;0,0,0,0],...
%       [1,1,0],[2,2,1],'CS4300_A_star_Man')
persistent out_plan;

if isempty(out_plan)
   out_plan = []; 
end

last_state = start_state;

for i = 1 : size(dests,1)
    [so,no] = CS4300_Wumpus_A_star(safe_spots,...
       last_state,[dests(i,1:2),0] ,'CS4300_A_star_Man');
   
   if size(so,1) > 0
       for j = 2:size(so,1)
            out_plan = [out_plan,so(j,4)];
       end
   end
   last_state = so(size(so,1),1:3);
end

plan = out_plan;