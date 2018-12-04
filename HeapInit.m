function heap=HeapInit(initlen)
if nargin<1
    initlen=1000;
end
heap=struct;
heap.q=zeros(2,initlen);
heap.len=sum(heap.q(1,:)>0);