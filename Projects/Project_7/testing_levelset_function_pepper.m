clear all
close all
clc
tic

sigma = 2;
mu = .9;
maxiter = 30;
mindist=2.1;
gamma=0;
errthrsh=0.01;
noise = 0;
draw_states=1;

C = imread('peppers.png');
% C=imresize(C,[100,100]);
figure(6);
image(C)

HSV = rgb2hsv(C);
H = HSV(:,:,1);
figure(7);colormap(gray(256))
image(H*255)

purpl = mean(mean(HSV(30:60,60:90,1)));
% purpl = mean(mean(HSV(1:20,1:20,1)));
H = H + (1-purpl)/2;
H(H(:)>1) = H(H(:)>1)-1;
image(H*255)

dmap = 0.5-(H<.5);

res = LevelSetGVF(H,dmap, sigma, errthrsh, maxiter, mu, gamma);

figure(2);clf; colormap(gray(256))
hold off
image(C);
hold on;
contour(res,[0,0],'r');