function FIFODisp()
global fifo
if fifo.start > fifo.stop
    disp('Empty');
else
    fifo.start;
    fifo.stop;
%     fifo.q
    disp(fifo.q(fifo.start:fifo.stop))
end