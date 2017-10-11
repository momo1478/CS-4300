function action = CS4300_agent_Astar_PC(percept)
% CS4300_agent_Astar_PC - A* search agent with PC
% Uses A* to find best path back to start and PC to avoid trouble
% On input:
%   percept (1x5 Boolean vector): percept values
%   (1): Stench
%   (2): Breeze
%   (3): Glitters
%   (4): Bumped
%   (5): Screamed
% On output:
%   action (int): action selected by agent
%   FORWARD = 1;
%   ROTATE_RIGHT = 2;
%   ROTATE_LEFT = 3;
%   GRAB = 4;
%   SHOOT = 5;
%   CLIMB = 6;
% Call:
%   a = CS4300_agent_Astar_PC([0,0,0,0,0]);
% Author:
%     Monish Gupta Eric Waugh
%     u1008121 u0947296
%     Fall 2017
persistent phase;
persistent state;
persistent pboard;
persistent solution;

persistent visited;
persistent unvisited;
persistent current_node;
persistent to_visit;
persistent conGraph;
persistent domains;
persistent gold_found;

if isempty(state)
    state = [1,1,0];
end
if isempty(gold_found)
    gold_found = 0;
end
if isempty(phase)
    phase = 1;
end
if isempty(pboard)
    pboard = -ones(4, 4);
end

if isempty(visited)
    visited = [1];
end
if isempty(unvisited)
   unvisited = [];
end
if isempty(current_node)
   current_node = 1;
end
if isempty(to_visit)
   to_visit = 1;
end
if isempty(conGraph)
    conGraph = zeros(16,16);
    for i = 1:16
       if rem(i,4) ~= 1 %left
          conGraph(i, i - 1) = 1; 
       end
       if rem(i,4) ~= 0 %right
           conGraph(i, i + 1) = 1;
       end
       if i < 13 %up
           conGraph(i, i + 4) = 1;
       end
       if i > 4 %down
           conGraph(i, i - 4) = 1;
       end
    end
end

if isempty(domains)
   domains = ones(16,3); 
end

if percept(3) == 1
    phase = 2;
    if gold_found == 0
        solution = [];
        gold_found = 1;
    end
end

if phase == 1
    if to_visit == current_node
        if current_node == 5
            
        end
        y = rem(current_node,4);
        if y == 0
            y = 4;
        end
        pboard(5 - floor(((current_node - 1)/4) + 1), y) = 0;
        if percept(2) == 0
            domains(current_node,1:3) = [1,0,0]; %clear
        else
            domains(current_node,1:3) = [1,0,1]; %safe but has a breeze
        end
        domains = CS4300_AC3(conGraph, domains, 'CS4300_Wumpus_Predicate');
        for i = 1:length(domains) %update pboard
            if domains(i,2) == 0
                if ~ismember(visited, i)
                    y = rem(i,4);
                    if y == 0
                        y = 4;
                    end
                    pboard(5 - floor(((i - 1)/4) + 1), y) = 0;
                    if isempty(unvisited)
                        unvisited = [i, unvisited];
                    elseif ~ismember(unvisited, i)
                        unvisited = [i, unvisited];
                    end
                end
            end
        end
    end
    
    if ~isempty(solution)
        action = solution(1);
        solution = solution(2:end);
        if isempty(solution)
           visited = [visited, to_visit];
           current_node = to_visit;
        end
        state = CS4300_Wumpus_transition(state, action, zeros(4,4));
        return
    elseif isempty(unvisited)
        action = randi([1,3], 1, 1);
    else
        to_visit = unvisited(1);
        if to_visit == 3
            
        end
        unvisited(1) = [];
        y = rem(to_visit,4);
        if y == 0
            y = 4;
        end
        goal_state = [y, floor(((to_visit - 1)/4) + 1), 0];           
        [so,no] = CS4300_Wumpus_A_star(abs(pboard),state,goal_state,'CS4300_A_star_Man');

        for j = 2:size(so,1) %Start @ 2 to Skip '0' action in solution.
            solution = [solution,so(j,4)];
        end
        action = solution(1); %%%INDEX EXCEEDS MATRIX DIMENSIONS
        solution = solution(2:end);
        state = CS4300_Wumpus_transition(state, action, zeros(4,4));
        return
    end
    state = CS4300_Wumpus_transition(state, action, zeros(4,4));
    pboard(4 - state(2) + 1, state(1)) = 0;
    current_node = ((state(2) - 1) * 4) + state(1); 
    to_visit = current_node;
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

end