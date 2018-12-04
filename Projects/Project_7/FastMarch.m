function [dmapout,nbin,nbout]=FastMarch(img,maxdist,getnb,nbi)

global r c dmap Active dmapi heap
[r,c]=size(img);
d=1;
heap = HeapInit(10000);
dmapi=img;
dmap = 3e8*ones(r,c,d);
dmap(dmapi(:)==0)=0;
Active = ones(r,c);
if nargin<4 || isempty(nbi)
    nbi.q = [1:r*c; dmap(:)'];
    nbi.len = length(nbi.q);
end
InsertBorderVoxelsIntoHeap(dmapi,1,nbi)
if getnb
    nb.q = zeros(2,r*c*d);
    nb.len=0;
end
[node,dist]=HeapPop;
while ~isempty(node) && dist<maxdist
    if getnb
        nb.len = nb.len+1;
        nb.q(:,nb.len) = [node;dist];
    end
    Active(node)=0;
    ProcessNeighborsEikonal(node,dmapi,1)
    [node,dist] = HeapPop();
    while (~isempty(node))&&Active(node)==0
        [node,dist] = HeapPop();
    end
end

% That gives us our foreground distance map. Now we do it again for background.
dmapin = dmap;
dmap = 3e8*ones(r,c,d);
dmap(dmapi(:)==0)=0;
Active = ones(r,c,d);

% background
InsertBorderVoxelsIntoHeap(dmapi,-1,nbi);
if getnb
    nbin = nb;
    nb.len=0;
end
[node,dist] = HeapPop();

while ~isempty(node) && dist<maxdist
    if getnb
        nb.len = nb.len+1;
        nb.q(:,nb.len) = [node;dist];
    end
    Active(node)=0;
    ProcessNeighborsEikonal(node,dmapi,-1);
    
    [node,dist] = HeapPop();
    while (~isempty(node))&&Active(node)==0
        [node,dist] = HeapPop();
    end
end
%Then we combine the two results into our output distance map:
dmapout = dmap;
dmapout(dmapi(:)<0) = -dmapin(dmapi(:)<0);
if getnb
    nbout = nb;
end
% mean(abs(dmapout(:)-img(:)));
% max(abs(dmapout(:)-img(:)));