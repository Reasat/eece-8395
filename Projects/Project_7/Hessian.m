function hess=Hessian(img,node)
global Edges 
[r,c]=size(img);
neibs=Edges(node,:);
L=neibs(1);
R=neibs(2);
D=neibs(3);
U=neibs(4);
%% calculate dderiv_x,dderiv_y, dderiv_xy
if L&&R
    dderiv_x=img(R)-2*img(node)+img(L);
end
if L==0
    dderiv_x=img(R)-2*img(node)+img(node);
end

if R==0
    dderiv_x=img(node)-2*img(node)+img(L);
end

if D&&U
    dderiv_y=img(D)-2*img(node)+img(U);
end
if D==0
    dderiv_y=img(node)-2*img(node)+img(U);
end
if U==0
    dderiv_y=img(D)-2*img(node)+img(node);
end

%% erroneous boundary conditions
RU=max(1,R-1);
LU=max(1,L-1);
RD=min(R+1,r*c);
LD=min(L+1,r*c);

dderiv_xy=1/4*(RD-RU-LD+LU);

hess=[dderiv_x dderiv_xy;dderiv_xy dderiv_y];







