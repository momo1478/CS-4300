function [U,U_trace] = CS4300_MDP_value_iteration(S,A,P,R,gamma,...
eta,max_iter)
% CS4300_MDP_value_iteration - compute policy using value iteration
% On input:
%     S (vector): states (1 to n)
%     A (vector): actions (1 to k)
%     P (nxk struct array): transition model
%       (s,a).probs (a vector with n transition probabilities
%       (from s to s_prime, given action a)
%     R (vector): state rewards
%     gamma (float): discount factor
%     eta (float): termination threshold
%     max_iter (int): max number of iterations
% On output:
%     U (vector): state utilities
%     U_trace (iterxn): trace of utility values during iteration
% Call:
%     [U,Ut] = CS4300_MDP_value_iteration(S,A,P,R,0.999999,0.1,100);
%
%     Set up a driver function, CS_4300_run_value_iteration (see
%     below), which sets up the Markov Decision Problem and calls this
%     function.
%
%     Chapter 17 Russell and Norvig (Table p. 651)
%     [S,A,R,P,U,Ut] = CS4300_run_value_iteration(0.999999,1000)
%
%     U’ = 0.7053 0.6553 0.6114 0.3879 0.7616 0 0.6600 -1.0000
%       0.8116 0.8678 0.9178 1.0000
%
%     Layout:                1
%                            ˆ
%       9 10 11 12           |
%       5  6  7  8       2 <- -> 4
%       1  2  3  4           |
%                            V
%                            3
% Author:
%    Eric Waugh and Monish Gupta
%    u0947296 and u1008121
%    Fall 2017

count = 0;
first_iter = 1;
max_utility_change = 0;

U = zeros(1,16);
newU = zeros(1,16);

U_trace = [];

n = size(S,1);
k = size(A,1);

while ~first_iter && max_utility_change < eta*((1 - gamma)/gamma) && ...
        count < max_iter
max_utility_change = 0;

U_trace = [U_trace;newU];
U = newU;

%for each state s in S do
for s = 1 : n
    max_utility_for_state = 0;
    
    tempNewUs = zeroes(1,n);
    tempNewUs(1:n) = newU(s);
    
    bestUtil = -10000;
    for a = 1 : k
      bestUtil = max(bestUtil , max( times(P(s,a).probs ,tempNewUs) ) );
    end
    newU(s) = R(s) + gamma * bestUtil;
    
    max_utility_change = max( max_utility_change, abs( newU(s) - U(s) ) );     
end
    
first_iter = 0;
count++;
end

end
    





