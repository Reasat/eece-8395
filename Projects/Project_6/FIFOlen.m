function len=FIFOlen
global fifo
if fifo.start > fifo.stop
    len=0;
else
    fifo.start;
    fifo.stop;
%     fifo.q
    len=length(fifo.q(fifo.start:fifo.stop));
end
