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
top_R=max(1,R-1);
top_L=max(1,L-1);
bottom_R=min(R+1,r*c);
bottom_L=min(L+1,r*c);

%% not sure about the spatial interpretation of U_xy 
dderiv_xy=1/4*(bottom_R-top_R-bottom_L+top_L);

hess=[dderiv_x dderiv_xy;dderiv_xy dderiv_y];







