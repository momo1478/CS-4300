function [removed,D_revised] = CS4300_REVISE(D, P, current_connection)
% CS4300_REVISE - Revise Domain
% On input:
% D (nxm array): m domain values for each of n nodes
% P (string): predicate function name; P(i,a,j,b) takes as
% arguments:
% i (int): start node index
% a (int): start node domain value
% j (int): end node index
% b (int): end node domain value
% current_connection (int, int): the connection (neighboors)
% On output:
% removed (boolean): says if we removed or not
% D_revised (nxm array): revised domain labels
% Call:
% [removed, D] = CS4300_REVISE(D, ’CS4300_P_no_attack’, current_connection)
% Author:
% Monish Gupta and Eric Waugh
% u1008121 and u0947296
% Fall 2017
M = size(D,2);
removed = 0;
for x = 1:M
   for y = 1:M
      constraint = 0;
      if D(current_connection(1),x) == 1 && D(current_connection(2),y) == 1 &&...
              feval(P,current_connection(1), x, current_connection(2), y)
          constraint = 1;
          break
      end
   end
   if constraint == 0 %found no y's that satisfied constraint 
      if D(current_connection(1),x) == 1
          removed = 1;
          D(current_connection(1),x) = 0;
      end
   end    
end
D_revised = D;

end

