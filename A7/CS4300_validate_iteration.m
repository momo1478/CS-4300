function [S,A,R,P,U,Ut] = CS4300_run_value_iteration(gamma,max_iter)
%CS4300_run_value_iteration - runs the value iterator
% On input:
%     gamma (float): discount factor
%     max_iter (int): max number of iterations
% On output:
%     S (vector): states (1 to n)
%     A (vector): actions (1 to k)
%     R (vector): state rewards
%     P (nxk struct array): transition model
%       (s,a).probs (a vector with n transition probabilities
%       (from s to s_prime, given action a)
%     U (vector): state utilities
%     Ut (iterxn): trace of utility values during iteration
% Call:
%     [S,A,R,P,U,Ut] = CS4300_run_value_iteration(.99999, 1000);
% Author:
%    Eric Waugh and Monish Gupta
%    u0947296 and u1008121
%    Fall 2017
%

n = 12;
k = 4;
S = 1:n;
A = 1:k;

U = zeros(1,n);
Ut = zeros(1,n);

R = [-0.04,-0.04,-0.04,-0.04, -0.04, 0,-0.04,-1, -0.04,-0.04,-0.04,1];

for i = 1:n
   if i ~= 6
       for j = 1:k
          P(i,j).probs = zeros(1,n);
          if j == 1 %going up
             %checks bounds for going up
             if i <= 8 && i ~= 2
                 P(i,j).probs(i + 4) = P(i,j).probs(i + 4) + .8;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .8;
             end

             %checks bounds for going left
             if rem(i,4) ~= 1 && i ~= 7
                 P(i,j).probs(i - 1) = P(i,j).probs(i - 1) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

             %checks bounds for going right
             if rem(i,4) ~= 0 && i ~= 5
                 P(i,j).probs(i + 1) = P(i,j).probs(i + 1) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

          elseif j == 2 %going left
             %checks bounds for going left
             if rem(i,4) ~= 1 && i ~= 7
                 P(i,j).probs(i - 1) = P(i,j).probs(i - 1) + .8;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .8;
             end

             %checks bounds for going down
             if i >= 5 && i ~= 10
                 P(i,j).probs(i - 4) = P(i,j).probs(i - 4) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

             %checks bounds for going up
             if i <= 8 && i ~= 2
                 P(i,j).probs(i + 4) = P(i,j).probs(i + 4) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

          elseif j == 3 %going down
             %checks bounds for going down
             if i >= 5 && i ~= 10
                 P(i,j).probs(i - 4) = P(i,j).probs(i - 4) + .8;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .8;
             end

             %checks bounds for going left
             if rem(i,4) ~= 1 && i ~= 7
                 P(i,j).probs(i - 1) = P(i,j).probs(i - 1) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

             %checks bounds for going right
             if rem(i,4) ~= 0 && i ~= 5
                 P(i,j).probs(i + 1) = P(i,j).probs(i + 1) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

          elseif j == 4 %going right
             %checks bounds for going right
             if j == 4 && i == 5
                x = 5; 
             end
             if rem(i,4) ~= 0 && i ~= 5
                 P(i,j).probs(i + 1) = P(i,j).probs(i + 1) + .8;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .8;
             end

             %checks bounds for going up
             if i <= 8 && i ~= 2
                 P(i,j).probs(i + 4) = P(i,j).probs(i + 4) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end

             %checks bounds for going down
             if i >= 5 && i ~= 10
                 P(i,j).probs(i - 4) = P(i,j).probs(i - 4) + .1;
             else
                 P(i,j).probs(i) = P(i,j).probs(i) + .1;
             end
          end
       end  
   end
end

[U,Ut] = CS4300_MDP_value_iteration(S, A, P, R, gamma, .1, max_iter);

end

