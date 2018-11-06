clear all
close all
clc
nodes=[1,2,3,4,5,6,7,8,9];
edgecost={
     [8 5];
     [1 4 8];
     [10 1];
     [5 1 8] ;
     [4 3 7 1];
     [10 7 3];
     [8 1];
     [7 10 1];
     [7 10];
    };
Edges={
    [2,4];
    [1,3,5];
    [2,6];
    [1,5,7];
    [2,6,8,4];
    [3,5,9];
    [4,8];
    [7,5,9];
    [8,6];
    };

min_cost=1000*ones(1,length(nodes));
prev_node=-1*ones(1,length(nodes));
cost_prev=[min_cost;prev_node];
visited=zeros(1,length(nodes));
global heap;
heap=HeapInit(1000);

for i=1:length(nodes(1:end))
    HeapInsert(nodes(i),min_cost(nodes(i)),prev_node(nodes(i)));
end
node_start=1;
node_end=9;
HeapInsert(node_start,0,-1);

while ~isempty(heap.q(:,1:heap.len))
    [node_current,cost_current,~]=HeapPop;
    if node_current==node_end
        break
    end
    if ~visited(node_current)
    for i_neighb=1: length(Edges{node_current})
        node_neighb=Edges{node_current}(i_neighb);
        cost_neighb=cost_current+edgecost{node_current}(i_neighb);
        if cost_neighb<cost_prev(1,node_neighb)
            HeapInsert(node_neighb,cost_neighb,node_current);
            cost_prev(1,node_neighb)=cost_neighb;
            cost_prev(2,node_neighb)=node_current;
        end
    end
    visited(node_current)=1;
    end
%     HeapDisp
end
path=[];
node=node_end;
while node~=node_start
    path=[path node];
    node=cost_prev(2,node);
end
path=[path node_start];
path=path(end:-1:1);
GraphSearch(nodes,edgecost,Edges,1,8)
    