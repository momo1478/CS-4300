function [w,per_cor,class] = CS4300_A9_driver
% CS4300_A9_driver - driver for A9 images
% On output:
%     w ((m+1)x1 vector): weights for linear function
%     per_cor (kx1 array): trace of percentage correct with weight
%     class ((m+1)x1 vector): which images satisfy the searched conditions
% Call:
%     [w,per_cor,class] = CS4300_A9_driver;
% Author:
%     Eric Waugh and Monish Gupta
%     U0947296 and U1008121
%     Fall 2017
%

load('W.mat');
load('P.mat');
load('G.mat');

size = 9;

Xim = [];
y = [];
class = [];

% Gold
for i = 1:size
   im = G(i).im;
   im = imresize(im,[15,15]);
   im = im > 220;
   Xim(i,:) = im(:,8)';
   y(i) = 1;
end

% Wumpus
for i = 1:size
   im = W(i).im;
   im = imresize(im,[15,15]);
   im = im > 220;
   Xim(i + 9,:) = im(:,8)';
   y(i + 9) = 2;
end

% Pits
for i = 1:size
   im = P(i,1).im;
   im = imresize(im,[15,15]);
   im = im > 220;
   Xim(i + 18,:) = im(:,8)';
   y(i + 18) = 3;
end
y = transpose(y);

[w,per_cor] = CS4300_perceptron_learning(Xim,(y==1)',0.1,1000,0);

class = [ones(27,1),Xim] * w > 0;
end

