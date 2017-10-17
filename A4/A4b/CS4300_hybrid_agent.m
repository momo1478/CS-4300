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
persistent have_arrow;
persistent safe_board;

glitter_offset = 16;
pit_offset = 32;
wumpus_offset = 64;

if isempty(KB)
   [KB_string,KB,vars] = CS4300_BR_gen_KB();
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

if isempty(have_arrow)
   have_arrow = 1; 
end

if isempty(safe_board)
   safe_board = ones(4, 4);
end

cell_state = (state(1) - 1) * 4 + state(2);
safe_board(4 - state(2) + 1, state(1)) = 0;

KB = CS4300_Tell(KB, CS4300_make_percept_sentence(...
    percept,state(1),state(2)));

%% ASK SAFE SPACES TO 4 ADJACENT CELLS
neighbors = [cell_state + 4, cell_state - 4, cell_state + 1, cell_state - 1];
for i = 1:4
    if ~ismember(neighbors(i),safe) && neighbors(i) > 0 && neighbors(i) < 16
        not_pit(1).clauses = -(neighbors(i) + pit_offset); 
        not_wumpus(1).clauses = -(neighbors(i) + wumpus_offset);
        
        pit(1).clauses = neighbors(i) + pit_offset; 
        wumpus(1).clauses = neighbors(i) + wumpus_offset;
        if CS4300_Ask(KB, not_pit) && CS4300_Ask(KB, not_wumpus) && ...
                ~CS4300_Ask(KB, pit) && ~CS4300_Ask(KB, wumpus)
            safe = [safe,neighbors(i)];
            safe_board(4 - floor((neighbors(i) - 1)/4),...
                rem(neighbors(i) + 1,4) + 1) = 0;
        end
    end
end
%%

%% GLITTER? (Gold Here? Grab it!)
if percept(3) == 1
    plan = [4,CS4300_Plan_Route(state,[1,1], safe_board),6];
end
%%

%% VISIT ALL SAFE SPACES
if isempty(plan)
    plan = Plan_Route(state, CS4300_Coor_To_XYList( intersect(unvisited,safe) ), safe);
end
%%

%% FIND POSSIBLE WUMPUS PLACES + SHOOT WUMPUS
possible_wumpus = [];
if isempty(plan) && have_arrow
    for i = 1:16
        if ~ismember(i,safe)
            w(1).clauses = -(i + wumpus_offset);
            if ~CS4300_Ask(KB, w) 
                possible_wumpus = [possible_wumpus,i];
            end
        end
    end
    %plan = Plan_Shot(state, possible_wumpus, safe);
end
%%

%% TAKE A RISK ON SPACES THAT ARE NOT_UNSAFE
if isempty(plan)
    not_unsafe = setdiff(1:16,safe);
    plan = Plan_Route(state, CS4300_Coor_To_XYList( intersect(unvisited,not_unsafe) ), safe);
end
%%

%% CHICKEN OUT AND CLIMB OUT OF BOARD
if isempty(plan)
    plan = [CS4300_Plan_Route(state,[1,1],safe_board),6];
end
%%
action = plan(1);
plan = plan(2:end);
state = CS4300_Wumpus_transition(state,action,safe_board);

end