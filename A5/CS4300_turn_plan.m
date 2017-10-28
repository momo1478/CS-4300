function plan = CS4300_turn_plan(state, so)
%CS4300_turn_plan - Plan an action sequence to turn the agent toward Wx, Wy
% On input:
%   state (1x3 int vector) : state of safe row , col , direction
%   so    (nx4 int vector) : final state of solution of
% On output:
%   plan (nx1 int matrix)         :    plan of actions that results to turn the agent
%                           toward Wx,Wy
% Call:
%   turn = CS4300_turn_plan(state, so, Wx, Wy);
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017

plan = [];
    if isempty(so)
        return;
    else
        last_state = so(size(so,1),1:end);
        
        if last_state(3) == state(3)
            return;
        elseif rem(last_state(3) + 1,4) == state(3)
            plan = 3; %turn left
            return;
        elseif rem(last_state(3) - 1,4) == state(3)
            plan = 2; %turn right
            return;
        else
            plan(1,1) = 2;
            plan(2,1) = 2;
        end
            
    end
end

