function ProcessNeighborsEikonal(node,dmapi,mode)
global Edgs Active dmap
neibs=Edgs(node,:);
neibs=neibs(neibs~=0); % take nonzero neighbors
if mode==1
    neibs=neibs(dmapi(neibs)<0); %foreground
end
if mode==-1
    neibs=neibs(dmapi(neibs)>0); %background
end
% check for Active 0
% Active 2??
for i=1:length(neibs)
    if Active(neibs(i))==2
        Active(neibs(i))=1;
    end
    dist=dist_calc(neibs(i),mode);
%     if ~isempty(dist)
%         dmap(neibs(i))=dist;
%     end
    HeapInsert(neibs(i),dist) % check
end

