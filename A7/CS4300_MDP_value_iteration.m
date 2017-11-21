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
max_utility_change = -1;

U = zeros(1,16);
newU = R;

U_trace = [];

n = size(S,2);
k = size(A,2);

while count < max_iter
    
    max_utility_change = 0;
    newU(3) = -1000;
    newU(6) = -1000;
    newU(9) = -1000;
    newU(16) = 1000;
    U = newU;

    %for each state s in S do
    for s = 1:n
        bestUtil = -Inf;
        
        for a = 1:k
          currentUtil = 0;
          possible_values = find(P(s,a).probs);
          for i = 1:size(possible_values,2)
            currentUtil = currentUtil...,
              + (P(s,a).probs(possible_values(i)) * U(possible_values(i)));
          end
          bestUtil = max(bestUtil, currentUtil);
        end
        
        newU(s) = R(s) + (gamma * bestUtil);

        max_utility_change = max(max_utility_change, abs(newU(s) - U(s)));     
    end
    
    U_trace = [U_trace;U];
    count = count + 1;
    
    if max_utility_change < eta * ((1 - gamma)/gamma)
        break;
    end
end

end
    





