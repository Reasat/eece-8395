function dist=dist_calc(node,mode)
global dmap  Edgs

neibs=Edgs(node,:);
if mode==1
    neibs(dmap(neibs~=0)>0)=0;
end

if mode==-1
    neibs(dmap(neibs~=0)<0)=0;
end

if sum(neibs)==0
    dist=[];
    return
end


if neibs(1)==0 && neibs(2)
    U_ud=dmap(neibs(2));
end
if neibs(2)==0 && neibs(1)
    U_ud=dmap(neibs(1));
end

if neibs(1) && neibs(2)
    U_d=dmap(neibs(1));
    U_u=dmap(neibs(2));
    U_ud=min(U_d,U_u);
end

if neibs(1)==0 && neibs(2)==0
    U_ud=[];
end

if neibs(3)==0 && neibs(4)
    U_lr=dmap(neibs(4));
end
if neibs(4)==0 && neibs(3)
    U_lr=dmap(neibs(3));
end

if neibs(3) && neibs(4)
    U_r=dmap(neibs(3));
    U_l=dmap(neibs(4));
    U_lr=min(U_r,U_l);
end

if neibs(3)==0 && neibs(4)==0
    U_lr=[];
end

Us=[U_ud,U_lr];
if size(Us)==1
    dist=Us+1;
    dmap(node)=dist;
    return
end
Us=sort(Us);
dist=Us(1)+1;
if dist <= Us(2)
    dmap(node)=dist;
else
    dist = Us(1) + Us(2) + sqrt(2-(Us(1)-Us(2))^2); % check equation
    % check if its minimum
    dmap(node)=dist;
end
% if dist <= Us(3)




