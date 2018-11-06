function FIFOInit(initlen)
global fifo
if nargin<1
    initlen=1000;
end
fifo=struct;
fifo.start=1;
fifo.stop=0;
fifo.q=zeros(1,initlen);

