function node=FIFOPop()
global fifo
if fifo.start > fifo.stop
    node=[];
else
    node=fifo.q(fifo.start);
    fifo.start=fifo.start+1;
end