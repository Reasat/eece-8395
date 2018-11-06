function FIFOInsert(node)
global fifo
fifo.stop=fifo.stop+1;
fifo.q(fifo.stop)=node;