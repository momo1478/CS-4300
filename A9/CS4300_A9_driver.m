function CS4300_A9_driver
% CS4300_A9_driver - driver for A9 images
% Call:
%     CS4300_A9_driver
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

for i = 1:size
   im = G(i).im;
   im = imresize(im,[15,15]);
   im = im > 220;
   Xim(i,:) = im(:,8)';
   y(i) = 1;
end

for i = 1:size
   im = W(i).im;
   im = imresize(im,[15,15]);
   im = im > 220;
   Xim(i + 9,:) = im(:,8)';
   y(i + 9) = 2;
end

for i = 1:size
   im = P(i,1).im;
   im = imresize(im,[15,15]);
   im = im > 220;
   Xim(i + 18,:) = im(:,8)';
   y(i + 18) = 3;
end

[w,pc] = CS4300_perceptron_learning(Xim,y==1,0.1,1000,0);

end

