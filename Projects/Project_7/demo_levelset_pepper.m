clear all
close all
clc
global r c Edges
tic
sigma = 2;
mu = .9;
maxiter = 30;
mindist=2.1;
gamma=0;
noise = 0;
draw_states=0;

C = imread('peppers.png');
C=imresize(C,[300,300]);
figure(6);
image(C)

HSV = rgb2hsv(C);
H = HSV(:,:,1);
figure(7);colormap(gray(256))
image(H*255)

% purpl = mean(mean(HSV(30:60,60:90,1)));
purpl = mean(mean(HSV(1:20,1:20,1)));
H = H + (1-purpl)/2;
H(H(:)>1) = H(H(:)>1)-1;
image(H*255)

dmap = 0.5-(H<.5);

r=size(H,1); c=size(H,2); d=1;
slc = r*c;

[Y,X]  = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
Edges =[Y<c,Y>1,X<r,X>1].*(repmat([1:r*c]',[1,4]) +repmat([r,-r,1,-1],[r*c,1]));

grad = Gradient(H,1:r*c*d);
ngrad = reshape(sum(grad.*grad),[r,c]);
speed = exp(-ngrad/(.08));
figure(2); clf; colormap(gray(256));
image(speed*1000);
hold on;
title('speed');
% quiver(reshape(grad(1,:),[r,c]),reshape(grad(2,:),[r,c]),'g')
gradspeed = Gradient(speed,1:r*c*d);
gradspeed = GVF(gradspeed,mu,[r,c]);

iter = 0;
nb = [];
while iter<maxiter
    iter = iter+1
    if draw_states
        figure(2);clf; colormap(gray(256))
        hold off
        image(speed*1000);
        hold on;
        contour(dmap,[0,0],'r');
        title('speed');
        drawnow;
    end
    [dmap,nbin,nbout] = FastMarch(dmap,mindist,1,nb);
    if draw_states
        figure(3);clf; colormap(gray(256))
        hold off;
        image(dmap*10+127);
        hold on;
        contour(dmap,[0,0],'r');
        title(['distance map iter=',num2str(iter)])
        drawnow;
    end
    nb.q = [nbin.q(:,1:nbin.len),nbout.q(:,1:nbout.len)];
    nb.len = size(nb.q,2);
    [kappa,ngrad,grad] = Curvature2(dmap,nb);
    node = nb.q(1,1:nb.len); %+ (nbspeed.q(2,1:nbspeed.len)-1)*r ;
    speedc=-speed(node).*(max(ngrad,0.001)).*(kappa+gamma) + sum(grad.*gradspeed(:,node));
    dt = 0.5/max(abs(speedc(:)));
    dmap(node) = dmap(node) + dt*speedc;
    
    if draw_states
        figure(4); clf; colormap(gray(256))
        curvature = zeros(size(dmap));
        curvature(node)=kappa;
        image(curvature*500+127);
        title('curvature');
        drawnow;
    end
end

[dmap,nbin,nbout] = FastMarch(dmap,mindist,1,nb);
figure(2);clf; colormap(gray(256))
hold off
image(speed*1000);
title('speed');
hold on;
contour(dmap,[0,0],'r');
figure(1);clf; 
image(C)
hold on;
contour(dmap,[0,0],'r');
title('distance map');
toc