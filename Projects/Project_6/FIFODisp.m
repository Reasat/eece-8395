function FIFODisp()
global fifo
if fifo.start > fifo.stop
    disp('Empty');
else
    disp(fifo.q(fifo.start:fifo.stop))
end