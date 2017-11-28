function [U] = CS4300_Policy_Evaluation(policy,U,S,A,P,R)
%CS4300_Policy_Evaluation - Takes in current U and updates it
% On input:
%     policy (nx1 vector): policy for problem
%     U (nx1 vector): current utilities found
%     S (vector): states (1 to n)
%     A (vector): actions (1 to k)
%     P (nxk array): transition model
%     R (vector): state rewards
% On output:
%     U (nx1 vector): updated utilities found
% Call:
%     U = CS4300_Policy_Evaluation(policy, U, S, A, P, R);
% Author:
%     Eric Waugh and Monish Gupta
%     u0947296 and u1008121
%     Fall 2017
%

b = transpose(R);

n = size(S,2);
Au = zeros(n,n);

bad_spot = min(b);
good_spot = max(b);

for i = 1:n
   for j = 1:n
       if b(i) == bad_spot || b(i) == good_spot
           Au(i,i) = 1;
           break;
       elseif ~isempty(P(i,policy(i)).probs)
           if P(i,policy(i)).probs(j) ~= 0
               if i == j
                   Au(i,j) = (U(j) * P(i,policy(i)).probs(j)) - 1;
               else
                   Au(i,j) = U(j) * P(i,policy(i)).probs(j);
               end
           end
       else
           Au(i,i) = 1;
       end
   end
end

U = Au \ b;

end

