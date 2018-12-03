function [kappa,ngrad,grad]=Curvature2(img,nb)
nodes=nb.q(1,1:nb.len);
kappa=[];
grad=[];
ngrad=[];
for i_nodes = 1: length(nodes)
    node=nodes(i_nodes);
    grad_node=0.5*Gradient(img,node);
    ngrad_node=sqrt(sum(grad_node.*grad_node));
    hess=Hessian(img,node);
    kappa_node=(grad_node' * hess * grad_node - ngrad_node^2 * trace(hess))/(2*ngrad_node^3);
    kappa=[kappa kappa_node];
    grad=[grad grad_node];
    ngrad=[ngrad ngrad_node^2];
end

