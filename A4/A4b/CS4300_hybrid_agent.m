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

persistent KB plan safe unvisited state have_arrow safe_board have_gold;
persistent possible_wumpus added_wumpus_spot previous_action wumpus_board;

pit_offset = 32;
wumpus_offset = 64;

if isempty(KB)
   [KB_string,KB,vars] = CS4300_BR_gen_KB();
   state = [1,1,0];
   plan = [];
   unvisited = 2:16;
   safe = [];
   have_arrow = 1;
   safe_board = ones(4, 4);
   have_gold = 0;
   added_wumpus_spot = 0;
   previous_action = 1;
   wumpus_board = zeros(4,4);
end

cell_state = (state(2) - 1) * 4 + state(1);
safe_board(4 - state(2) + 1, state(1)) = 0;
if ~ismember(cell_state,safe)
    safe = [safe,cell_state];
    not_pit(1).clauses = -(cell_state + pit_offset);
    not_wumpus(1).clauses = -(cell_state + wumpus_offset);
    KB = CS4300_Tell(KB, not_pit);
    KB = CS4300_Tell(KB, not_wumpus);
end
if ismember(cell_state, unvisited) 
    unvisited(find(unvisited == cell_state)) = [];
end

KB = CS4300_Tell(KB, CS4300_make_percept_sentence(...
    percept,state(1),state(2)));

%% ASK SAFE SPACES TO 4 ADJACENT CELLS
if previous_action == 1 || previous_action == 5
    if rem(cell_state - 1,4) == 0 %nothing to left
        neighbors = [cell_state + 4,cell_state - 4,cell_state + 1];
    elseif rem(cell_state,4) == 0 %nothing to right
        neighbors = [cell_state + 4,cell_state - 4,cell_state - 1];
    else
        neighbors = [cell_state + 4,cell_state - 4,...
            cell_state + 1,cell_state - 1];
    end
    
    wumpus_board(4 - floor((cell_state - 1)/4),...
                        rem(cell_state - 1,4) + 1) = -1;
    if percept(1) == 0
       for i = 1:length(neighbors)
           if neighbors(i) > 0 && neighbors(i) < 16
               wumpus_board(4 - floor((neighbors(i) - 1)/4),...
                            rem(neighbors(i) - 1,4) + 1) = -1;
           end
       end
    else
       for i = 1:length(neighbors)
           if neighbors(i) > 0 && neighbors(i) < 16 &&...
                   wumpus_board(4 - floor((neighbors(i) - 1)/4),...
                    rem(neighbors(i) - 1,4) + 1) >= 0
                
                current_value = wumpus_board(4 - floor((neighbors(i)...
                    - 1)/4), rem(neighbors(i) - 1,4) + 1);
                wumpus_board(4 - floor((neighbors(i) - 1)/4),...
                    rem(neighbors(i) - 1,4) + 1) = current_value + 1;
           end
       end
    end
    for i = 1:length(neighbors)  
        if ~ismember(neighbors(i),safe) &&...
                neighbors(i) > 0 && neighbors(i) < 16
            not_pit(1).clauses = -(neighbors(i) + pit_offset); 
            not_wumpus(1).clauses = -(neighbors(i) + wumpus_offset);

            pit(1).clauses = neighbors(i) + pit_offset; 
            wumpus(1).clauses = neighbors(i) + wumpus_offset;

            not_pit_result = CS4300_Ask(KB, not_pit);
            if not_pit_result == 1
                KB = CS4300_Tell(KB, not_pit);
            end

            not_wumpus_result = CS4300_Ask(KB, not_wumpus);
            if not_wumpus_result == 1
                KB = CS4300_Tell(KB, not_wumpus);
            end

            if not_pit_result && not_wumpus_result && ...
                    ~CS4300_Ask(KB, pit) && ~CS4300_Ask(KB, wumpus)
                safe = [safe,neighbors(i)];
                safe_board(4 - floor((neighbors(i) - 1)/4),...
                    rem(neighbors(i) - 1,4) + 1) = 0;
            else if percept(1) == 0 && percept(2) == 0
                safe = [safe,neighbors(i)];
                safe_board(4 - floor((neighbors(i) - 1)/4),...
                    rem(neighbors(i) - 1,4) + 1) = 0; 
                end
            end
        end
    end
end
%%

%% GLITTER? (Gold Here? Grab it!)
if percept(3) == 1 && have_gold == 0
    plan = [4,CS4300_Plan_Route(state,[1,1], safe_board),6];
    have_gold = 1;
end
%%

if percept(5) == 1 && added_wumpus_spot == 0
    safe = [safe, possible_wumpus];
    safe_board(4 - floor((possible_wumpus - 1)/4),...
        rem(possible_wumpus - 1,4) + 1) = 0;
    not_wumpus(1).clauses = -(possible_wumpus + wumpus_offset);
    KB = CS4300_Tell(KB, not_wumpus);
    added_wumpus_spot = 1;
end

%% VISIT ALL SAFE SPACES
if isempty(plan) || ~isempty(intersect(unvisited,safe)) && ~have_gold
    plan = CS4300_Plan_Route(state,...
        CS4300_Coor_To_XYList(intersect(unvisited,safe)), safe_board);
end
%%

%%FIND POSSIBLE WUMPUS PLACES + SHOOT WUMPUS
if isempty(plan) && have_arrow
    for i = 1:16
        if ~ismember(i,safe)
            Checky = 5 - (floor((i - 1)/4) + 1);
            Checkx = rem(i - 1,4) + 1;
            
            if wumpus_board(Checky, Checkx) == 2
                Wy = floor((i - 1)/4) + 1;
                Wx = rem(i - 1,4) + 1;
                possible_wumpus = i;
                plan = CS4300_Plan_Shot(safe_board, state, Wx, Wy);
                have_arrow = 0;
                break;
            end
        end
    end
end
%%

%% TAKE A RISK ON SPACES THAT ARE NOT_UNSAFE
not_unsafe = setdiff(1:16,safe);
if isempty(plan)
    plan = CS4300_Plan_Route(state,...
        CS4300_Coor_To_XYList(intersect(unvisited,not_unsafe)),safe_board);
end
%%

%% CHICKEN OUT AND CLIMB OUT OF BOARD
if isempty(plan)
    plan = [CS4300_Plan_Route(state,[1,1],safe_board),6];
end
%%
action = plan(1);
previous_action = action;
plan = plan(2:end);
state = CS4300_Wumpus_transition(state,action,safe_board);

end