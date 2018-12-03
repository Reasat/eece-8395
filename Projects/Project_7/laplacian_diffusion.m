function ngradspeed=laplacian_diffusion(gradspeed,q,dims)
r=dims(1);
c=dims(2);
[Y,X]  = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
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
ngradspeed = [x';y'];