function grad=Gradient(img, nodes)
global Edges

grad=[];
for i_nodes=1:length(nodes)
    node=nodes(i_nodes);
    neibs=Edges(node,:);
    %% calculate gradient in x direction
    if neibs(1)&& neibs(2)
        grad_x=img(neibs(1))-img(neibs(2));
    end
    if neibs(1)==0
        grad_x=img(node)-img(neibs(2));
    end
    if neibs(2)==0
        grad_x=img(neibs(1))-img(node);
    end
    %% calculate gradient in y direction
    if neibs(3)&& neibs(4)
        grad_y=img(neibs(3))-img(neibs(4));
    end
    if neibs(3)==0
        grad_y=img(node)-img(neibs(4));
    end
    if neibs(4)==0
        grad_y=img(neibs(3))-img(node);
    end
    
    grad=[grad [grad_x grad_y]'];
end
    