function hess=Hessian(img,node)
global Edges 
[r,c]=size(img);
neibs=Edges(node,:);
L=neibs(1);
R=neibs(2);
D=neibs(3);
U=neibs(4);
grad_node=Gradient(img,node);
%% calculate dderiv_x,dderiv_y, dderiv_xy
if L&&R
    grad=Gradient(img,L);
    grad_L=grad(1);
    grad=Gradient(img,R);
    grad_R=grad(1);
    dderiv_x=grad_R-2*grad_node(1)+grad_L;
end
if L==0
    grad=Gradient(img,R);
    grad_R=grad(1);
    dderiv_x=grad_R-2*grad_node(1);
end

if R==0
    grad=Gradient(img,L);
    grad_L=grad(1);
    dderiv_x=-2*grad_node(1)+grad_L;
end

if D&&U
    grad=Gradient(img,D);
    grad_D=grad(2);
    grad=Gradient(img,U);
    grad_U=grad(2);
    dderiv_y=grad_D-2*grad_node(1)+grad_U;
end
if D==0
    grad=Gradient(img,U);
    grad_U=grad(2);
    dderiv_y=-2*grad_node(1)+grad_U;
end
if U==0
    grad=Gradient(img,D);
    grad_D=grad(2);
    dderiv_y=grad_D-2*grad_node(1);
end

%% erroneous boundary conditions
top_R=max(1,R-1);
top_L=max(1,L-1);
bottom_R=min(R+1,r*c);
bottom_L=min(L+1,r*c);

%% not sure about the spatial interpretation of U_xy 
grad=Gradient(img,top_R);
grad_top_R=grad(1); 

grad=Gradient(img,top_L);
grad_top_L=grad(1);

grad=Gradient(img,bottom_R);
grad_bottom_R=grad(2);

grad=Gradient(img,bottom_L);
grad_bottom_L=grad(2);

dderiv_xy=1/4*(grad_bottom_R-grad_top_R-grad_bottom_L+grad_top_L);

hess=[dderiv_x dderiv_xy;dderiv_xy dderiv_y];







