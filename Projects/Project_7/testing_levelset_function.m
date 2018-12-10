clear all
close all
clc
tic
global r c Edges
sigma = 1;
mu = .9;
maxiter = 300;
mindist=2.1;
gamma=0.1;
errthrsh = 0.01;
noise = 0;

r=50; c=50; d=1;
slc = r*c;
img = zeros(r,c,d);
img(15:35,15:35) = 1;
img(21:25,10:20) = 0;
img(10:14,25:27) = 1;
rng('default');
img = img + noise*randn(size(img));
figure(1); clf; colormap(gray(256));
image(255*img);
title('ground truth');

dmap = ones(size(img));
% dmap(20:30,24:32)=-1;
% dmap(13:38,13:38)=-1;
% dmap(20:30,24:32)=-1;
dmap(25:45,5:45)=-1;

res = LevelSetGVF(img,dmap, sigma, errthrsh, maxiter, mu, gamma);

figure(2);clf; colormap(gray(256))
hold off
image(img*255);
title('speed');
hold on;
contour(res,[0,0],'r');