function len=FIFOLen
global fifo
if fifo.start > fifo.stop
    len=0;
else
    len=length(fifo.q(fifo.start:fifo.stop));
end
