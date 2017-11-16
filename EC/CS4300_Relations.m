function R = CS4300_Relations(D, P)
% CS4300_REVISE - Revise Domain
% On input:
%   D (nxm array): m domain values for each of n nodes
%   P (string): predicate function name; P(i,a,j,b) takes as
%       arguments:
%           i (int): start node index
%           a (int): start node domain value
%           j (int): end node index
%           b (int): end node domain value
% On output:
%   R (TODO)
%   D_revised (nxm array): revised domain labels
% Call:
%   [removed, D] = CS4300_Relations(D, ’CS4300_P_no_attack’)
% Author:
%   Monish Gupta and Eric Waugh
%   u1008121 and u0947296
%   Fall 2017

N = size(D,1);
M = size(D,2);

for i = 1:N
   R(i,i).R = ones(M,M); 
end

for i = 1:N
   for j = 1:N
       if(i~=j)
           for a = 1:M
              for b = 1:M
                  R(i,j).R(a,b) = feval(P,i, a, j, b);
              end
           end
       end
   end
end

for i = 1:N
   for a = 1:M
      if(D(i,a) == 0)
         R(i,i).R(a,a) = 0; 
      end
   end
end

end

