function heap=HeapInit2(initlen)
if nargin<1
    initlen=1000;
end
heap=struct;
heap.q=[-1*ones(1,initlen); 3e8*ones(1,initlen)];
heap.len=0;