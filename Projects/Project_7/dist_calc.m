function dist=dist_calc(node)
global dmap Edges

neibs=Edges(node,:);
 
if neibs(3)==0 
    U_ud=dmap(neibs(4));
end
if neibs(4)==0 
    U_ud=dmap(neibs(3));
end

if neibs(3) && neibs(4)
    U_ud=min(dmap(neibs(3)),dmap(neibs(4)));
end

if neibs(1)==0 
    U_lr=dmap(neibs(2));
end
if neibs(2)==0 
    U_lr=dmap(neibs(1));
end
if neibs(1) && neibs(2)
    U_lr=min(dmap(neibs(1)),dmap(neibs(2)));
end

Us=[U_ud,U_lr];
Us=sort(Us);
dist=Us(1)+1;
if dist > Us(2)
    dist = (Us(1) + Us(2) + sqrt(2-(Us(1)-Us(2))^2))/2; % check equation
end
% if dist <= Us(3)




