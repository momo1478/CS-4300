function action = CS4300_MC_agent(percept)
% CS4300_MC_agent - Monte Carlo agent with a few informal rules
% On input:
%   percept (1x5 Boolean vector): percept from Wumpus world
%       (1): stench
%       (2): breeze
%       (3): glitter
%       (4): bump
%       (5): scream
% On output:
%   action (int): action to take
%       1: FORWARD
%       2: RIGHT
%       3: LEFT
%       4: GRAB
%       5: SHOOT
%       6: CLIMB
% Call:
%   a = CS4300_MC_agent(percept);
% Author:
%   Monish Gupta and Eric Waugh
%   u0947296 u1008121
%   Fall 2017
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

persistent safe pits Wumpus board have_gold have_arrow killed_wumpus
persistent state visited plan stench breezes num_trials frontier_helper

if isempty(state)
    state = [1,1,0];
    stench = -ones(4,4);
    breezes = -ones(4,4);
    num_trials = 10000;
    safe = -ones(4,4);
    pits = -ones(4,4);
    Wumpus = -ones(4,4);
    board = -ones(4,4);
    visited = zeros(4,4);
    frontier_helper = zeros(4,4);
    safe(4,1) = 1;
    pits(4,1) = 0;
    Wumpus(4,1) = 0;
    board(4,1) = 0;
    visited(4,1) = 1;
    frontier_helper(4,1) = 1;
    frontier_helper(4,2) = 1;
    frontier_helper(3,1) = 1;
    have_gold = 0;
    have_arrow = 1;
    killed_wumpus = 0;
    plan = [];
end

if percept(5)==1
    [rW,cW] = find(Wumpus==1);
    board(rW,cW) = 0;
    safe(rW,cW) = 1;
    Wumpus(rW,cW) = 0;
    killed_wumpus = 1;
end

if have_gold==0 && percept(3)==1
    plan = [GRAB];
    have_gold = 1;
    [so,no] = CS4300_Wumpus_A_star(abs(board),...
        [state(1),state(2),state(3)],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [plan;so(2:end,4)];
    plan = [plan;CLIMB];
end

if ~isempty(plan)
    action = plan(1);
    plan = plan(2:end);
    % Update agent's idea of state
    state = CS4300_Wumpus_transition(state,action,board);
    x = 4-state(2)+1; y = state(1);
    visited(x,y) = 1;
    neighbors = [[x+1,y];[x-1,y];[x,y+1];[x,y-1]];
    neighbors = min(max(neighbors,1),4);
    for i = 1:4
        frontier_helper(neighbors(i,1),neighbors(i,2)) = 1;
    end
    board(x,y) = 0;
    return
end

%Do montecarlo stuff to guess which spots are safe
stench(4-state(2)+1,state(1)) = percept(1);
breezes(4-state(2)+1,state(1)) = percept(2);
[pit_est,wumpus_est] = CS4300_WP_estimates(breezes,stench,num_trials);
for i = 1:4
    for j = 1:4
        if pit_est(i,j) == 0 && wumpus_est(i,j) == 0
           safe(i,j) = 1;
           board(i,j) = 0;
        elseif pit_est(i,j) == 1 && wumpus_est(i,j) == 1
           safe(i,j) = 0;
           board(i,j) = 1;
        end
        if pit_est(i,j) == 1 || pit_est(i,j) == 0
           pits(i,j) = pit_est(i,j); 
        end
        if wumpus_est(i,j) == 1 || wumpus_est(i,j) == 0
           Wumpus(i,j) = wumpus_est(i,j); 
        end
    end
end

[wumpus_x,wumpus_y] = find(Wumpus==1);
if ~isempty(wumpus_x) && have_arrow
    Wx = wumpus_x;
    Wy = 4 - wumpus_y + 1;
    plan = CS4300_Plan_Shot(abs(board), state, Wx, Wy);
    have_arrow = 0;
    action = plan(1);
    plan = plan(2:end);
    state = CS4300_Wumpus_transition(state,action,board);
    x = 4-state(2)+1; y = state(1);
    visited(x,y) = 1;
    neighbors = [[x+1,y];[x-1,y];[x,y+1];[x,y-1]];
    neighbors = min(max(neighbors,1),4);
    for i = 1:4
        frontier_helper(neighbors(i,1),neighbors(i,2)) = 1;
    end
    board(x,y) = 0;
    return
end

% travel to safe spot
if isempty(plan)
    [cand_rows,cand_cols] = find(safe==1&visited==0);
    if ~isempty(cand_rows)
        cand_x = cand_cols;
        cand_y = 4 - cand_rows + 1;
        [so,no] = CS4300_Wumpus_A_star(abs(board),...
            state,...
            [cand_x(1),cand_y(1),0],'CS4300_A_star_Man');
        plan = [so(2:end,4)];
        action = plan(1);
        plan = plan(2:end);
        % Update agent's idea of state
        state = CS4300_Wumpus_transition(state,action,board);
        x = 4-state(2)+1; y = state(1);
        visited(x,y) = 1;
        neighbors = [[x+1,y];[x-1,y];[x,y+1];[x,y-1]];
        neighbors = min(max(neighbors,1),4);
        for i = 1:4
            frontier_helper(neighbors(i,1),neighbors(i,2)) = 1;
        end
        board(x,y) = 0;
        return
    end
end

% Take a risk
if isempty(plan)
    %%TODO%%
    
    [y,x] = find(visited == 0 & frontier_helper == 1);
    min_index = [4,4];
    min = 1;
    
    [pp,wp] = CS4300_WP_estimates();
    estimate_averages = (pp + wp)/2;
    
    for i = 1:length(y)
        if estimate_average(y(i),x(i)) < min
            min_index = [y(i),x(i)];
            min = estimate_average(y(i),x(i));
        end
    end
    
    
    
    
    %[cand_row,cand_col] = [0,0];
    cand_x = cand_col;
    cand_y = 4 - cand_row + 1;
    indexes = find(cand_x~=state(1)|cand_y~=state(2));
    if ~isempty(indexes)
        goal_x = cand_x(indexes(1));
        goal_y = cand_y(indexes(1));
    end
    temp_board = board;
    temp_board(4-goal_y+1,goal_x) = 0;
    [so,no] = CS4300_Wumpus_A_star(abs(temp_board),...
        state,...
        [goal_x,goal_y,0],'CS4300_A_star_Man');
    if ~isempty(so)
        plan = [so(2:end,4)];
    else
        plan = randi(3);
    end
    action = plan(1);
    plan = plan(2:end);
    % Update agent's idea of state
    state = CS4300_Wumpus_transition(state,action,board);
    x = 4-state(2)+1; y = state(1);
    visited(x,y) = 1;
    neighbors = [[x+1,y];[x-1,y];[x,y+1];[x,y-1]];
    neighbors = min(max(neighbors,1),4);
    for i = 1:4
        frontier_helper(neighbors(i,1),neighbors(i,2)) = 1;
    end
    board(x,y) = 0;
    return
end

end

