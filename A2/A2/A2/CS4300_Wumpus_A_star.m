function [solution,nodes] = CS4300_Wumpus_A_star(board,initial_state,goal_state,h_name)
% CS4300_Wumpus_A_star - A
% *
% algorithm for Wumpus world
% On input:
%     board (4x4 int array): Wumpus board layout
%       0: means empty cell
%       1: means a pit in cell
%       2: means gold (only) in cell
%       3: means Wumpus (only) in cell
%       4: means gold and Wumpus in cell
%     initial_state (1x3 vector): x,y,dir state
%     goal_state (1x3 vector): x,y,dir state
%     h_name (string): name of heuristic function
% On output:
%     solution (nx4 array): solution sequence of state and the action
%     nodes (search tree data structure): search tree
%       (i).parent (int): index of node’s parent
%       (i).level (int): level of node in search tree
%       (i).state (1x3 vector): [x,y,dir] state represented by node
%       (i).action (int): action along edge from parent to node
%       (i).g (int): path length from root to node
%       (i).h (float): heuristic value (estimate from node to goal)
%       (i).cost (float): g + h   (called f value in text)
%       (i).children (1xk vector): list of node’s children
% Call:
%[so,no] = CS4300_Wumpus_A_star([0,1,0,0; 1,0,0,0; 0,2,1,1; 0,0,0,0],...
%          [1,1,0],[2,2,1],’CS4300_A_star_Man’)
% 
% so = this is not a wumpus board
%     1     1     0     0
%     2     1     0     1
%     2     1     1     3
%     2     2     1     1
%
% no = 1x9 struct array with fields:
%    parent
%    level
%    state
%    action
%    cost
%    g
%    h
%    children
% Author:
%     Monish Gupta Eric Waugh
%     u1008121 u0947296
%     Fall 2017

nodes = [];
solution = [];

open_list = [];
closed_list = [];

nodes(1).parent = [];
nodes(1).level = 0;
nodes(1).state = initial_state; %Gold spot for CS4300_agent_Astar
nodes(1).action = 0;
nodes(1).g = 0;
nodes(1).h = feval(h_name, initial_state, goal_state);
nodes(1).cost = nodes(1).g + nodes(1).h;
nodes(1).children = [];

num_nodes = 1;

open_list = [open_list,1];

while ~isempty(open_list)
    node = open_list(1);
    for i = 1:size(open_list,2)
        if nodes(open_list(i)).cost <= nodes(node).cost
            node = i;
        end
    end
    
    popped_index = open_list(node);
    current_state = nodes(popped_index).state;
    
    closed_list = [closed_list, open_list(node)];
    open_list(node) = [];
    
    for action = 1:3
        next_state = CS4300_Wumpus_transition(current_state,action,board);
        if next_state(1)>0
            % if next_state is NOT in the closed list. Process it.
           if CS4300_Wumpus_new_state(next_state, [], closed_list,nodes) == 1
               num_nodes = num_nodes + 1;
               nodes(num_nodes).parent = popped_index;
               nodes(num_nodes).level = nodes(popped_index).level + 1;
               nodes(num_nodes).state = next_state;
               nodes(num_nodes).action = action;
               nodes(num_nodes).g = nodes(popped_index).g + 1; %node == parent
               nodes(num_nodes).h = feval(h_name, next_state, goal_state);
               nodes(num_nodes).cost = nodes(num_nodes).g + nodes(num_nodes).h;
               nodes(num_nodes).children = [];
               nodes(popped_index).children = [nodes(popped_index).children,num_nodes];
               
               if CS4300_Wumpus_solution(board,next_state,goal_state)
                    solution = CS4300_traceback(nodes,num_nodes);
                    return
               end
               
               if CS4300_Wumpus_new_state(next_state, open_list, [],nodes) == 1
                   open_list = [open_list, num_nodes];
               else
                   new_node = nodes(num_nodes);
                   for i = 1:size(open_list,2)
                        n = nodes(open_list(i));
                        if n.state(1) == new_node.state(1) & n.state(2)...
                                == new_node.state(2) & n.state(3) == new_node.state(3)
                            if new_node.cost < n.cost
                                open_list(i) = num_nodes;
                            end
                        end
                   end
               end   
           end
       end
    end
end

end
