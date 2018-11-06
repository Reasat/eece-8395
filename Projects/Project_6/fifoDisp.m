function fifoDisp()
global fifo
if fifo.ind==0
    disp('Empty');
else
    disp(fifo.q(1:fifo.ind))
end