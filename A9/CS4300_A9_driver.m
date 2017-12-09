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

X = [];
y = [];

for i = 1:size
   im = G(i).im;
   im = imresize(im,[15,15]);
   im = im > 50;
   X(i,:) = im(:);
   y(i) = 1;
end

for i = 1:size
   im = W(i).im;
   im = imresize(im,[15,15]);
   im = im > 50;
   X(i + 9,:) = im(:);
   y(i + 9) = 1;
end

for i = 1:size
   im = P(i,1).im;
   im = imresize(im,[15,15]);
   im = im > 50;
   X(i + 18,:) = im(:);
   y(i + 18) = 1;
end

end

