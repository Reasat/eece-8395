function [kappa,ngrad,grad]=Curvature(img,nb)
%% confused about the use of square roots in ngrad
global Edges
nodes=nb.q(1,1:nb.len);
kappa=[];
grad=[];
ngrad=[];
for i_nodes = 1: length(nodes)
    node=nodes(i_nodes);
    grad_node=Gradient(img,node);
    ngrad_node=sqrt(sum(grad_node.*grad_node));
    V_node=grad_node/ngrad_node;
    neibs=Edges(node,:);
    
    R=neibs(1);
    L=neibs(2);
    D=neibs(3);
    U=neibs(4);
    
    if L
        V_L=V_grad(img,L);
        V_L=V_L(1);
    else
        V_L=V_node(1);
    end
    if R
        V_R=V_grad(img,R);
        V_R=V_R(1);
    else
        V_R=V_node(1);      
    end
    if U
        V_U=V_grad(img,U);
        V_U=V_U(2);
    else
        V_U=V_node(2);
    end
    if D
        V_D=V_grad(img,D);
        V_D=V_D(2);
    else
        V_D=V_node(2);
    end
    kappa_node=-1/2*(V_R-V_L+V_D-V_U);
    
    kappa=[kappa kappa_node];
    grad=[grad grad_node];
    ngrad=[ngrad ngrad_node^2];
end
function V_node=V_grad(img,node)
grad_node=Gradient(img,node);
ngrad_node=sqrt(sum(grad_node.*grad_node));
V_node=grad_node/ngrad_node;
