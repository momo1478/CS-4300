function [U] = CS4300_Policy_Evaluation(U,S,A,P,R,policy,k,gamma)
%CS4300_Policy_Evaluation - Takes in current U and updates it
% On input:
%     U (nx1 vector): current utilities found
%     S (vector): states (1 to n)
%     A (vector): actions (1 to k)
%     P (nxk array): transition model
%     R (vector): state rewards
%     policy (nx1 vector): policy for problem
%     k (int): number of iterations
%     gamma (float): discount factor
% On output:
%     U (nx1 vector): updated utilities found
% Call:
%     U = CS4300_Policy_Evaluation(U,S,A,P,R,policy,k,gamma);
% Author:
%     Eric Waugh and Monish Gupta
%     u0947296 and u1008121
%     Fall 2017
%

n = size(S,2);
b = reshape(-R,n,1);
Au = zeros(n,n);

for s = 1 : n
   Au(s,:) = P(s,policy(s)).probs;
end

Au = gamma * Au;
Au = Au - eye(n,n);
U = Au \ b;

end

