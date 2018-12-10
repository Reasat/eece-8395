function res = LevelSetGVF(img,res, sigma, errthrsh, maxiter, mu, gamma)
global Edges
mindist=2.1;
[r,c]=size(img);
d=1;
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
figure(1); clf; colormap(gray(256));
image(speed*1000);
hold on;
title('speed');

gradspeed = Gradient(speed,1:r*c);
quiver(reshape(gradspeed(1,:),[r,c]),reshape(gradspeed(2,:),[r,c]),'b')

gradspeed = GVF(gradspeed,mu,[r,c]);
hold on
quiver(reshape(gradspeed(1,:),[r,c]),reshape(gradspeed(2,:),[r,c]),'g')

iter = 0;
nb = [];

while iter<maxiter
    iter = iter+1;
    figure(2);clf; colormap(gray(256))
    hold off
    image(speed*1000);
    hold on;
    contour(res,[0,0],'r');
    title('speed');
    drawnow;
    
    [res,nbin,nbout] = FastMarch(res,mindist,1,nb);
    
    if iter>1
        err = sum(abs(-res(nbinold.q(1,1:nbinold.len))-nbinold.q(2,1:nbinold.len)))+...
            sum(abs(res(nboutold.q(1,1:nboutold.len))-nboutold.q(2,1:nboutold.len)))
        if err<errthrsh
            break;
        end
    end
    nboutold = nbout;
    nbinold = nbin;

    
    figure(3);clf; colormap(gray(256))
    hold off;
    image(res*10+127);
    hold on;
    contour(res,[0,0],'r');
    title(['distance map iter=',num2str(iter)])
    drawnow;
    
    nb.q = [nbin.q(:,1:nbin.len),nbout.q(:,1:nbout.len)];
    nb.len = size(nb.q,2);
    
    nbspeed.q = nb.q(:,nb.q(2,1:nb.len)<=1);
    nbspeed.len = size(nbspeed.q,2);
    
    [kappa,ngrad,grad] = Curvature2(res,nbspeed);
    node = nbspeed.q(1,1:nbspeed.len); 
    speedc=-speed(node).*(max(ngrad,0.001)).*(kappa+gamma) + sum(grad.*gradspeed(:,node));
    dt = 0.5/max(abs(speedc(:)));
    res(node) = res(node) + dt*speedc;
    
    figure(4); clf; colormap(gray(256))
    curvature = zeros(size(res));
    curvature(node)=kappa;
    image(curvature*500+127);
    title('curvature');
    drawnow;   
end

[res,~,~] = FastMarch(res,mindist,1,nb);
% figure(2);clf; colormap(gray(256))
% hold off
% image(speed*1000);
% title('speed');
% hold on;
% contour(res,[0,0],'r');
