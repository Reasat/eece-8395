function heap=HeapInit(initlen)
if nargin<1
    initlen=1000;
end
heap=struct;
heap.q=zeros(3,initlen);
% heap.q(2,:)=1000;
heap.len=sum(heap.q(1,:)>0);