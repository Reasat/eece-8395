function node=FIFOPeek()
global fifo
if fifo.start > fifo.stop
    node=[];
else
    node=fifo.q(fifo.start);
end
