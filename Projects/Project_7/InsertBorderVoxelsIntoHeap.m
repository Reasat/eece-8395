function InsertBorderVoxelsIntoHeap(dmapi,mode,nbi)
global dmap Active Edges
if nargin<3 || isempty(nbi)
    nbi=[];
end
if mode==1
    nodes =find(dmapi(:)<0); %foreground pixels
end
if mode==-1
    nodes = find(dmapi(:)>0); %background pixels
end
if ~isempty(nbi)
    nodes=intersect(nodes,nbi.q(1,1:nbi.len));
end
for i_nodes=1:length(nodes)
    node=nodes(i_nodes);
    node_dist=dmapi(node);
    neibs=Edges(node,:);
    for i_neibs=1:length(neibs)
        if neibs(i_neibs)
            neib_dist=dmapi(neibs(i_neibs));
            if neib_dist*node_dist<0
                node_dist_abs=abs(node_dist);
                %% get valid neighbours of the opposite class
                if neibs(1) && sign(dmapi(neibs(1)))==mode
                    R=neibs(1);
                else
                    R=0;
                end
                if neibs(2) && sign(dmapi(neibs(2)))==mode
                    L=neibs(2);
                else
                    L=0;
                end
                if neibs(3) && sign(dmapi(neibs(3)))==mode
                    D=neibs(3);
                else
                    D=0;
                end
                if  neibs(4) && sign(dmapi(neibs(4)))==mode
                    U=neibs(4);
                else
                    U=0;
                end
                %% calculate distance form neighbours
                %% LR
                if L==0 && R
                    x=abs(node_dist)/(abs(dmapi(R))+abs(node_dist));
                end
                if R==0 && L
                    x=abs(node_dist)/(abs(dmapi(L))+abs(node_dist));
                end
                if R==0 && L==0
                    x=Inf;
                end
                
                if L&&R
                    x=min([abs(node_dist)/(abs(dmapi(L))+abs(node_dist)) ...
                        abs(node_dist)/(abs(dmapi(R))+abs(node_dist))]);
                end
                %% DU
                if D&&U
                    y=min([abs(node_dist)/(abs(dmapi(D))+abs(node_dist))...
                        abs(node_dist)/(abs(dmapi(U))+abs(node_dist))]);
                end
                if D==0 && U
                    y=abs(node_dist)/(abs(dmapi(U))+abs(node_dist));
                end
                if U==0 && D
                    y=abs(node_dist)/(abs(dmapi(D))+abs(node_dist));
                end
                if D==0 && U==0
                    y=Inf;
                end
                
                dist=sqrt((1/x^2+1/y^2)^-1);
                dmap(node)=dist;
                HeapInsert(node,dist);
                Active(node)=2;                
            end
        end
    end
end
