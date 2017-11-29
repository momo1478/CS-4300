function policy = CS4300_MDP_policy(S,A,P,U)
% CS4300_MDP_policy - generate a policy from utilities
% See p. 648 Russell & Norvig
% On input:
%     S (vector): states (1 to n)
%     A (vector): actions (1 to k)
%     P (nxk struct array): transition model
%       (s,a).probs (a vector with n transition probabilities
%       from s to s_prime, given action a)
%     U (vector): state utilities
% On output:
%     policy (vector): actions per state
% Call:
%     [S,A,R,P,U,Ut] = CS4300_run_value_iteration(.99999, 1000);
%     p = CS4300_MDP_policy(S,A,P,U);
% Author:
%    Eric Waugh and Monish Gupta
%    u0947296 and u1008121
%    Fall 2017

policy = zeros(1,length(S));

for s = 1 : length(S)
    bestAction = 1;
    bestSum = -Inf;
    for a = 1:length(A)
        findI = find(P(s,a).probs);
        add = 0;
        
        for i = 1:length(findI)
            add = add + (P(s,a).probs(findI(i)) * U(findI(i)));
        end
        
        if add > bestSum
            bestAction = a;
            bestSum = add;
        end
    end
    policy(s) = bestAction;
end

