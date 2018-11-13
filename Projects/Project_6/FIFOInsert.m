function FIFOInsert(node)
global fifo
for i=1:length(node)
    fifo.stop=fifo.stop+1;
    fifo.q(fifo.stop)=node(i);
end