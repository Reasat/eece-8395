clear all
close all
clc
tic
global r c Edges
sigma = 1;
mu = .9;
maxiter = 30;
mindist=2.1;
gamma=0.1;
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

img = .5 - img;
g = fspecial('gaussian',[5,5],sigma);
imgblur = conv2(img,g,'same');

[Y,X]  = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
Edges =[Y<c,Y>1,X<r,X>1].*(repmat([1:r*c]',[1,4]) +repmat([r,-r,1,-1],[r*c,1]));

grad = Gradient(imgblur,1:r*c*d);
ngrad = reshape(sum(grad.*grad),[r,c]);
speed = exp(-ngrad/(.08));
figure(2); clf; colormap(gray(256));
image(speed*1000);
hold on;
title('speed');

% [dmap,nbin,nbout] = FastMarch(imgblur,1.1,1,[]);
% q = [nbin.q(1,nbin.q(2,1:nbin.len)<=1),nbout.q(1,nbout.q(2,1:nbout.len)<=1)];
% gradspeed = Gradient(speed,q);
% gradspeed=laplacian_diffusion(gradspeed,q,[r c]);

gradspeed = Gradient(speed,1:r*c);
quiver(reshape(gradspeed(1,:),[r,c]),reshape(gradspeed(2,:),[r,c]),'b')

gradspeed = GVF(gradspeed,mu,[r,c]);
hold on
quiver(reshape(gradspeed(1,:),[r,c]),reshape(gradspeed(2,:),[r,c]),'g')


dmap = ones(size(img));
% dmap(20:30,24:32)=-1;
% dmap(13:38,13:38)=-1;
% dmap(20:30,24:32)=-1;
dmap(25:45,5:45)=-1;


iter = 0;
nb = [];

while iter<maxiter
    iter = iter+1;
    
    figure(2);clf; colormap(gray(256))
    hold off
    image(speed*1000);
    hold on;
    contour(dmap,[0,0],'r');
    title('speed');
    drawnow;
    
    [dmap,nbin,nbout] = FastMarch(dmap,mindist,1,nb);
    
    figure(3);clf; colormap(gray(256))
    hold off;
    image(dmap*10+127);
    hold on;
    contour(dmap,[0,0],'r');
    title(['distance map iter=',num2str(iter)])
    drawnow;
    
    nb.q = [nbin.q(:,1:nbin.len),nbout.q(:,1:nbout.len)];
    nb.len = size(nb.q,2);
    [kappa,ngrad,grad] = Curvature2(dmap,nb);
    node = nb.q(1,1:nb.len); %+ (nbspeed.q(2,1:nbspeed.len)-1)*r ;
    speedc=-speed(node).*(max(ngrad,0.001)).*(kappa+gamma) + sum(grad.*gradspeed(:,node));
    dt = 0.5/max(abs(speedc(:)));
    dmap(node) = dmap(node) + dt*speedc;
    
    figure(4); clf; colormap(gray(256))
    curvature = zeros(size(dmap));
    curvature(node)=kappa;
    image(curvature*500+127);
    title('curvature');
    drawnow;   
end

[dmap,nbin,nbout] = FastMarch(dmap,mindist,1,nb);
figure(2);clf; colormap(gray(256))
hold off
image(speed*1000);
title('speed');
hold on;
contour(dmap,[0,0],'r');
toc