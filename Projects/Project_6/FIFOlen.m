function len=FIFOlen
global fifo
len=fifo.stop-fifo.start;
if len<0
    len=0;
end
return

