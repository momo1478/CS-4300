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
FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

persistent safe pits Wumpus board have_gold have_arrow
persistent state visited plan
persistent stench breezes num_trials

if isempty(state)
    state = [1,1,0];

    stench = -ones(4,4);
    breezes = -ones(4,4);
    num_trials = -ones(4,4);
    
    safe = -ones(4,4);
    pits = -ones(4,4);
    Wumpus = -ones(4,4);
    board = -ones(4,4);
    visited = zeros(4,4);
    safe(4,1) = 1;
    pits(4,1) = 0;
    Wumpus(4,1) = 0;
    board(4,1) = 0;
    visited(4,1) = 1;
    have_gold = 0;
    have_arrow = 1;
    plan = [];
end

if percept(5)==1
    [rW,cW] = find(Wumpus==1);
    board(rW,cW) = 0;
    safe(rW,cW) = 1;
    Wumpus(rW,cW) = 0;
end

if have_gold==0&percept(3)==1
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
    state = CS4300_Wumpus_transition(state,action,safe);
    visited(4-state(2)+1,state(1)) = 1;
    board(4-state(2)+1,state(1)) = 0;
    return
end

%Do montecarlo stuff to guess which spots are safe


% No Wumpus shot yet
[rW,cW] = find(Wumpus==1);
if ~isempty(rW)
    r_kill = [];
    c_kill = [];
    [r_safe,c_safe] = find(safe==1);
    r_index = find(r_safe==rW);
    c_index = find(c_safe==cW);
    if ~isempty(r_index)
        r_kill = r_safe(r_index(1));
        c_kill = c_safe(r_index(1));
        x_kill = c_kill;
        y_kill = 4 - r_kill + 1;
        row_kill = 1;
        col_kill = 0;
    elseif ~isempty(c_index)
        r_kill = r_safe(c_index(1));
        c_kill = c_safe(c_index(1));
        x_kill = c_kill;
        y_kill = 4 - r_kill + 1;
        col_kill = 1;
        row_kill = 0;
    end
    if ~isempty(r_kill)
        if x_kill==state(1)&y_kill==state(2)
            final_dir = state(3);
        else
            [so,no] = CS4300_Wumpus_A_star(abs(board),...
                state,...
                [x_kill,y_kill,0],'CS4300_A_star_Man');
            plan = so(2:end,4);  % gets agent to right place
            final_dir = so(end,3);
        end
        if row_kill==1
            if cW>c_kill
                if final_dir==1
                    plan = [plan;2];
                elseif final_dir==2
                    plan = [plan;2;2];
                elseif final_dir==3
                    plan = [plan;3];
                end
            else
                if final_dir==0
                    plan = [plan;2;2];
                elseif final_dir==1
                    plan = [plan;3];
                elseif final_dir==3
                    plan = [plan;2];
                end
            end
        else
            if rW>r_kill
                if final_dir==0
                    plan = [plan;3];
                elseif final_dir==1
                    plan = [plan;2;2];
                elseif final_dir==2
                    plan = [plan;3];
                end
            else
                if final_dir==0
                    plan = [plan;3];
                elseif final_dir==2
                    plan = [plan;2];
                elseif final_dir==3
                    plan = [plan;2;2];
                end
            end
        end
        plan = [plan;5];
    end
    action = plan(1);
    plan = plan(2:end);
    % Update agent's idea of state
    state = CS4300_Wumpus_transition(state,action,safe);
    visited(4-state(2)+1,state(1)) = 1;
    board(4-state(2)+1,state(1)) = 0;;
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
        state = CS4300_Wumpus_transition(state,action,safe);
        visited(4-state(2)+1,state(1)) = 1;
        board(4-state(2)+1,state(1)) = 0;
        return
    end
end

% Take a risk
if isempty(plan)
    %%TODO%%
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
    state = CS4300_Wumpus_transition(state,action,safe);
    visited(4-state(2)+1,state(1)) = 1;
    board(4-state(2)+1,state(1)) = 0;
    return
end

end

