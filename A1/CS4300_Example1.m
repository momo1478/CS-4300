function action = CS4300_Example1(percept)
% CS4300_Example1 - simple agent example
%    Takes actions: right, left, climb
% On input:
%     percept (1x5 Boolean vector): percept values
%      (1): Stench (wumpus is next to you)
%      (2): Breeze (open spaces)
%      (3): Glitters (you are next the gold)
%      (4): Bumped (ran into a wall)
%      (5): Screamed (fell in a pit)
% On output:
%     action (int): action selected by agent
%       FORWARD = 1;
%       ROTATE_RIGHT = 2;
%       ROTATE_LEFT = 3;
%       GRAB = 4;
%       SHOOT = 5;
%       CLIMB = 6;
% Call:
%     a = CS4300_Example1([0,1,0,0,0]);
% Author:
%     Eric Waugh and Monish Gupta
%     UU u0947296 and u1008121
%     Fall 2017
%

persistent state

FORWARD = 1;
ROTATE_RIGHT = 2;
ROTATE_LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

if isempty(state)
    state = 0;
end

switch state
    case 0
        action = ROTATE_RIGHT;
        state = 1;
    case 1
        action = ROTATE_LEFT;
        state = 2;
    case 2
        action = FORWARD;
        state = 2;
end
