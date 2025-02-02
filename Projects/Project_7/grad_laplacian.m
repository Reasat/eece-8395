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
% matrix we need to define at most r*c*5 terms. We�ll start with vectors that define that many
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
% Finally, bx and by will define the �b� vector in our equation A*z=b.
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
% Let�s compare our estimated gradient vector field with the original input.
ngradspeed = [x';y';zeros(1,length(x))];
figure(2); clf; colormap(gray(256));
image(speed*1000);
hold on;
title('speed');
hold on;
quiver(reshape(ngradspeed(2,:),[r,c]),reshape(ngradspeed(1,:),[r,c]))
hold on;
quiver(floor((q(1,:)-1)/r)+1,mod(q(1,:)-1,r)+1,(gradspeed(2,:)),(gradspeed(1,:)),'r')