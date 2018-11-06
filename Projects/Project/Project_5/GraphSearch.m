function [path,cost] =GraphSearch(EdgeFunc,NodeMark,IsNodeMarked,SetPointer,GetPointer,seednode,endnode)
global heap r c
path_cost=100000*ones(r*c,1);
path_cost(seednode)=0;
heap=HeapInit(1000);
HeapInsert(seednode,0,0);
while ~isempty(heap.q(:,1:heap.len))
%     HeapDisp
    [node_current,cost_current,node_prev]=HeapPop;
    if node_current==endnode
        break
    end
    if ~IsNodeMarked(node_current)
        [Edges,EdgeCost] = EdgeFunc(node_current);
        for i_neighb=1:length(Edges)
            node_neighb=Edges(i_neighb);
            if node_neighb
                cost_neighb=cost_current+EdgeCost(i_neighb);
                if cost_neighb<path_cost(node_neighb)
                    path_cost(node_neighb)=cost_neighb;
                    HeapInsert(node_neighb,cost_neighb,node_current);
                    SetPointer(node_neighb,node_current);
                end
            end
        end
        NodeMark(node_current)
    end
    %     HeapDisp
end
if endnode>0
    node=endnode;
    path=node;
    while node~=seednode
        node=GetPointer(node);
        path=[path node];
    end
    path=[path seednode];
    path=path(end:-1:1);
    cost=path_cost(endnode);
else
    path=-1;
    cost=-1;
end