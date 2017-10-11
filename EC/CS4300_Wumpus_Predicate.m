function is_consistent = CS4300_AC3_constraints(i, a, j, b)
% CS4300_AC3_constraints predicate function
% On input:
% i (int): start node index
% a (int): start node domain value
% j (int): end node index
% b (int): end node domain value
% On output:
% is_consistent: boolean to show if pit domains are consistant
% Call:
% cons = CS4300_AC3_constraints(1, 0, 2, 1);
% Author:
% Monish Gupta and Eric Waugh
% u1008121 and u0947296
% Fall 2017

is_consistent = 1; % initially true

%if a == 1 meaning its clear then b should not be 2 saying there is a pit
if a == 1 && b == 2
    is_consistent = 0;
end

%if a == 2 meaning there is a pit then b should be 3 saying there is a
%breeze
if a == 2 && b ~= 3
    is_consistent = 0; 
end




