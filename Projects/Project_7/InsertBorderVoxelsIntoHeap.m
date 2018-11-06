function InsertBorderVoxelsIntoHeap(dmapi,mode)
global dmap Active
if mode==1
nodes =find(dmapi(:)<0); %foreground pixels
end
if mode==-1
    nodes = find(dmapi(:)>0); %background pixels
end
for i=1:length(nodes)
%     dist=dist_calc(nodes(i));
    dist=0; %incorrect distance
    dmap(nodes(i))=dist;
    HeapInsert(nodes(i),dist);
    Active(nodes(i))=2;
end
