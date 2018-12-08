function [node, cost, prev]=HeapPop
global heap
[~,ind]=min(heap.q(2,1:heap.len));
node=heap.q(1,ind);
cost=heap.q(2,ind); 
prev=heap.q(3,ind);
heap.q(:,ind)=[];
heap.len=heap.len-1;
