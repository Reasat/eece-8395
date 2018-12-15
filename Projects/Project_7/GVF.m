function ngradspeed = GVF(gradspeed, mu,dims)

r=dims(1);
c=dims(2);
slc = r*c;
[Y,X]  = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
gs_mag_squared=sum(gradspeed.*gradspeed);
node = [1:slc]';
rws = [reshape(repmat(node',[5,1]),[5*slc,1])];
cols = rws + [repmat([0;-1;1;-r;r],[slc,1])];
% rws defines the row indices, cols defines the column indices.
s = repmat([0;-.25*mu;-.25*mu;-.25*mu;-.25*mu],[slc,1]);
first_col= upsample(mu+(1-mu)*gs_mag_squared,5)';
s=s+first_col;
I = zeros(slc*5,1);
N = find(X(:)==1);
I((N-1)*5+2)=1;
I((N-1)*5+4)=1;
I((N-1)*5+5)=1;

N = find(X(:)==r);
I((N-1)*5+3)=1;
I((N-1)*5+4)=1;
I((N-1)*5+5)=1;

N = find(Y(:)==1);
I((N-1)*5+2)=1;
I((N-1)*5+3)=1;
I((N-1)*5+4)=1;

N = find(Y(:)==c);
I((N-1)*5+2)=1;
I((N-1)*5+3)=1;
I((N-1)*5+5)=1;

rws = rws(~I(:));
cols = cols(~I(:));
s = s(~I(:));

% Now we construct sparse matrix A and solve A*x=bx and A*y=by
A = sparse(rws,cols,s,slc,slc);
x = A\bx;
y = A\by;
ngradspeed=[x y]';