function ProcessNeighborsEikonal(node,dmapi,mode)
global Edges Active dmap
neibs=Edges(node,:);
neibs=neibs(neibs~=0); % take nonzero neighbors
if mode==1
    neibs=neibs(dmapi(neibs)<0); %foreground
end
if mode==-1
    neibs=neibs(dmapi(neibs)>0); %background
end
for i=1:length(neibs)
    if Active(neibs(i))
        dist=dist_calc(neibs(i));

        if dmap(neibs(i))>dist
            dmap(neibs(i))=dist;
            HeapInsert(neibs(i),dist) % check
        end
%         Active(neibs(i))=2;
    end
end

