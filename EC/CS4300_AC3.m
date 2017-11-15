function D_revised = CS4300_AC3(G,D,P)
% CS4300_AC3 - AC3 function from Mackworth paper 1977
% On input:
% G (nxn array): neighborhood graph for n nodes
% D (nxm array): m domain values for each of n nodes
% P (string): predicate function name; P(i,a,j,b) takes as
% arguments:
% i (int): start node index
% a (int): start node domain value
% j (int): end node index
% b (int): end node domain value
% On output:
% D_revised (nxm array): revised domain labels
% Call:
% G = 1 - eye(3,3);
% D = [1,1,1;1,1,1;1,1,1];
% Dr = CS4300_AC3(G,D,’CS4300_P_no_attack’);
% Author:
% Monish Gupta and Eric Waugh
% u1008121 and u0947296
% Fall 2017

persistent queue

if isempty(queue)
    for i = 1:length(G) %i represents node we are looking at
        for j = 1:length(G) %j represents the neighboors
            if G(i,j) == 1
                queue = [[i,j]; queue;];
            end
        end
    end
end

current_run_queue = queue;
while ~isempty(current_run_queue)
    current_connection = current_run_queue(1,1:end);
    current_run_queue(1,:) = []; %deletes the first row
    
    %Add Neighbors if we removed labels.
    [removed, D] = CS4300_REVISE(D, P, current_connection);
    if removed == 1
        for j = 1:length(G) %j represents the neighboors of con graph(2)
            if G(current_connection(1),j) == 1
                current_run_queue = [[j,current_connection(1)];current_run_queue;];
            end
        end
    end
end
D_revised = D;

end


