function D_revised = CS4300_PC(G,D,P)
% CS4300_PC - a PC function from Mackworth paper 1977
% On input:
%   G (nxn array): neighborhood graph for n nodes
%   D (nxm array): m domain values for each of n nodes
%   P (string): predicate function name; P(i,a,j,b) takes as
% arguments:
%   i (int): start node index
%   a (int): start node domain value
%   j (int): end node index
%   b (int): end node domain value
% On output:
%   D_revised (nxm array): revised domain labels
% Call:
%   G = 1 - eye(4,4);
%   D = [1,1,1,1;1,1,1,1;1,1,1,1;1,1,1,1];
%   Dr = CS4300_PC(G,D,’CS4300_P_no_attack’);
% Author:
%     Monish Gupta Eric Waugh
%     u1008121 u0947296
%     Fall 2017

N = size(D,1);
M = size(D,2);
R = CS4300_Relations(D, P);
for i = 1:N+1
    Y(i).R = R;
end

Y(1).R(1,1).R = 1 - Y(1).R(1,1).R;
while ~isequal(Y(N + 1), Y(1))
    for k = 2:N
        for i = 1:N
           for j = 1:N
               Yik = Y(k-1).R(i,k - 1).R;
               Ykk = Y(k-1).R(k,k).R;
               Ykj = Y(k-1).R(k,j).R;
               val1 = mtimes(Yik, Ykk);
               val2 = mtimes(val1, Ykj);
               for x = 1:M
                  for y = 1:M
                      if val2(x,y) > 0
                          val2(x,y) = 1;
                      end
                  end
               end
               Yij = Y(k-1).R(i,j);
           end
        end
    end
    
end



end

