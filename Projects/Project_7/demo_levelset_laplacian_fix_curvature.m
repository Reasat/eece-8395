clear all
close all
clc
global r c Edges

sigma = 1;
maxiter = 200;
mindist=2.1;
gamma=0.85;
errthrsh=0.01;
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
quiver(reshape(grad(1,:),[r,c]),reshape(grad(2,:),[r,c]),'g')

gradspeed = Gradient(speed,1:r*c*d);
quiver(reshape(gradspeed(1,:),[r,c]),reshape(gradspeed(2,:),[r,c]),'r')

gamma=0;
[dmap,nbin,nbout] = FastMarch(imgblur,1.1,1,[]);
q = [nbin.q(1,nbin.q(2,1:nbin.len)<=1),nbout.q(1,nbout.q(2,1:nbout.len)<=1)];
gradspeed = Gradient(speed,q);
% Now we will diffuse those gradients over the image domain by solving the Laplacian equation in
% Matlab. This is done by defining a matrix A such that the solution z [r*c,1] of A*z=bx are
% gradients in the x direction and the solution z of A*z=by are the gradients in the y direction.
% Because the matrix A is so large [r*c,r*c], we need to use the sparse matrix representation in
% Matlab:
% help sparse
% So every row will correspond to the equation for each pixel, and the equation is defined across
% multiple columns. To create the sparse matrix we need vectors that contain each non-zero entry
% in the matrix. We have 3 types of equations: (a) Border pixels where we know the gradient.
% These have an equation in the matrix with one term (1) on the diagonal. (b) Then we have
% interior pixels that have 1+numneighbors = 5 terms for 2D images with 4-connected
% neighborhoods. (c) Finally we have border pixels that are treated as ghost nodes and use
% Neumman boundary conditions which will have 2 terms in the matrix. Thus, to define our sparse
% matrix we need to define at most r*c*5 terms. We’ll start with vectors that define that many
% entries then pare them down for type (a) and type (c) pixels.
slc = r*c;
node = [1:slc]';
rws = [reshape(repmat(node',[5,1]),[5*slc,1])];
cols = rws + [repmat([0;-1;1;-r;r],[slc,1])];
% rws defines the row indices, cols defines the column indices.
s = repmat([1;-.25;-.25;-.25;-.25],[slc,1]);
% s defines the value of each nonzero entry in the matrix. We initialize the off diagonal elements as
% the values for type (b) voxels but we need to change these for types (a) and (c).
I = zeros(slc*5,1);
% We will use I to mark which rows we want to remove for type (a) and (c) pixels.
bx = zeros(slc,1);
by = zeros(slc,1);
% Finally, bx and by will define the ‘b’ vector in our equation A*z=b.
dnode = q;
% These are the node indices for our type (a) pixels.
bx(dnode) = gradspeed(1,:);
by(dnode) = gradspeed(2,:);
% We want to mark for removal the off diagonal elements for these nodes since we have their exact
% value.
I(reshape(repmat(5*(dnode'-1)+1,[1,4])+repmat([1:4],[length(dnode),1]),[4*length(dnode),1]))=1;
% Now we handle the boundary conditions.
N = find(X(:)==1 & sum(reshape(I,[5,slc]))'==0);
I((N-1)*5+2)=1;
I((N-1)*5+4)=1;
I((N-1)*5+5)=1;
s((N-1)*5+3)=-1;
N = find(X(:)==r & sum(reshape(I,[5,slc]))'==0);
I((N-1)*5+3)=1;
I((N-1)*5+4)=1;
I((N-1)*5+5)=1;
s((N-1)*5+2)=-1;
N = find(Y(:)==1 & sum(reshape(I,[5,slc]))'==0);
I((N-1)*5+2)=1;
I((N-1)*5+3)=1;
I((N-1)*5+4)=1;
s((N-1)*5+5)=-1;
N = find(Y(:)==c & sum(reshape(I,[5,slc]))'==0);
I((N-1)*5+2)=1;
I((N-1)*5+3)=1;
I((N-1)*5+5)=1;
s((N-1)*5+4)=-1;
rws = rws(~I(:));
cols = cols(~I(:));
s = s(~I(:));
% Now we construct sparse matrix A and solve A*x=bx and A*y=by
A = sparse(rws,cols,s,slc,slc);
x = A\bx;
y = A\by;
% Let’s compare our estimated gradient vector field with the original input.
ngradspeed = [x';y';zeros(1,length(x))];
figure(2); clf; colormap(gray(256));
image(speed*1000);
hold on;
title('speed');
hold on;
quiver(reshape(ngradspeed(1,:),[r,c]),reshape(ngradspeed(2,:),[r,c]))
hold on;
quiver(floor((q(1,:)-1)/r)+1,mod(q(1,:)-1,r)+1,(gradspeed(1,:)),(gradspeed(2,:)),'r')
dmap = ones(size(img));
% dmap(20:30,24:32)=-1;
% dmap(13:38,13:38)=-1;
% dmap(20:30,24:32)=-1;
dmap(25:45,5:45)=-1;

gradspeed = ngradspeed(1:2,:);
gamma=.3;

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
    if iter>1
        err = sum(abs(-dmap(nbinold.q(1,1:nbinold.len))-nbinold.q(2,1:nbinold.len)))+...
            sum(abs(dmap(nboutold.q(1,1:nboutold.len))-nboutold.q(2,1:nboutold.len)))
        if err<errthrsh
            break;
        end
    end
    nboutold = nbout;
    nbinold = nbin;
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
figure(1);clf; colormap(gray(256))
hold on;
contour(dmap,[0,0],'r');
title('distance map');
