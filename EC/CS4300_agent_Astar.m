function action = CS4300_agent_Astar(percept)
% CS4300_agent_Astar - A* search agent example
%   Uses A* to find best path back to start
% On input:
%  percept (1x5 Boolean vector): percept values
%   (1): Stench
%   (2): Breeze
%   (3): Glitters
%   (4): Bumped
%   (5): Screamed
% On output:
%  action (int): action selected by agent
%   FORWARD = 1;
%   ROTATE_RIGHT = 2;
%   ROTATE_LEFT = 3;
%   GRAB = 4;
%   SHOOT = 5;
%   CLIMB = 6;
% Call:
%   a = CS4300_agent_Astar([0,0,0,0,0]);
% Author:
%     Monish Gupta Eric Waugh
%     u1008121 u0947296
%     Fall 2017
 
FORWARD = 1;
ROTATE_RIGHT = 2;
ROTATE_LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

persistent phase;
persistent state;

persistent pboard;
persistent solution;

if isempty(state)
    state = [1,1,0];
end

if isempty(phase)
    phase = 1;
end

if isempty(pboard)
    pboard = -ones(4, 4);
    pboard(4 - state(2) + 1, state(1)) = 0;
end

if percept(3) == 1
    phase = 2;
end

if phase == 1
    decision = randi([1,3], 1, 1);
    switch decision
    case 1
        action = FORWARD;
    case 2
        action = ROTATE_RIGHT;
    case 3
        action = ROTATE_LEFT;
    end
    state = CS4300_Wumpus_transition(state, action, zeros(4,4));
    pboard(4 - state(2) + 1, state(1)) = 0;
    return
end

if phase == 2
    if isempty(solution)
        [so,no] = CS4300_Wumpus_A_star(abs(pboard),state,[1,1,0],'CS4300_A_star_Man');
        solution = [4];
        for i = 2:size(so,1) %Start @ 2 to Skip '0' action in solution.
           solution = [solution,so(i,4)];
        end
        solution = [solution, 6];
    end
    action = solution(1);
    solution = solution(2:end);
end

