function node=fifoPop()
global fifo
if fifo.ind==0
    node=[];
else
    node=fifo.q(fifo.ind);
    fifo.ind=fifo.ind-1;
end