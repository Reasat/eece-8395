function fifo=fifoInit(initlen)
if nargin<1
    initlen=1000;
end
fifo={};
fifo.q=zeros(1,initlen);
fifo.ind=0;
