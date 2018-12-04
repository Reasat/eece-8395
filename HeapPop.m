function [node, dist]=HeapPop
global heap
if heap.len<1
    node=[];
    dist=[];
else
    node=heap.q(1,1);
    dist=heap.q(2,1);
    heap.q(:,1)=[];
    heap.len=heap.len-1;
end
