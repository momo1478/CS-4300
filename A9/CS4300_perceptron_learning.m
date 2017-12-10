function [w,per_cor] = ...
  CS4300_perceptron_learning(X,y,alpha,max_iter,rate)
% CS4300_perceptron_learning - find linear separating hyperplane
%  Eqn 18.7, p. 724 Russell and Norvig
% On input:
%     X (nxm array): n independent variable samples each of length m
%     y (nx1 vector): dependent variable samples
%     alpha (float): learning rate
%     max_iter (int): max number of iterations
%     rate (Boolean): if 1 then alpha = 1000/(1000+iter), else
%     constant
% On output:
%     w ((m+1)x1 vector): weights for linear function
%     per_cor (kx1 array): trace of percentage correct with weight
% Call:
%     [w,pc] = CS4300_perceptron_learning(X,y,0.1,10000,1);
% Author:
%     Eric Waugh and Monish Gupta
%     U0947296 and U1008121
%     Fall 2017

y = transpose(y);

n = size(X,1);
m = size(X,2);

X = [ones(n,1), X];
x = [];
iter = 0;
done = 0;
pcorrect = 0;
hw = [];
w = -0.1 + 0.2 * rand(1,m + 1);
per_cor = [];
while ~done
   if rate
       alpha = 1000/(1000+iter);
   end
   for j = 1 : n
        hw(j) = (dot(X(j,:),w) >= 0); 
   end
   
   pcorrect = sum( hw == y ) / size(y,1);
   per_cor = [per_cor,pcorrect];
   if (pcorrect == 1 || iter >= max_iter)
        done = 1;
        w = w';
        break;
   end
   
   randrow = ceil(rand * size(X,1));
   x = X(randrow,:);
   
   for i = 1 : length(w)
      w(i) = w(i) + alpha * (y(randrow) - hw(randrow)) * x(i); 
   end
   
   iter = iter + 1;
end
end