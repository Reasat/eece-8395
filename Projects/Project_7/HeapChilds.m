function HeapChilds(ind)
global heap
ind_left_child=2*ind;
ind_right_child=2*ind+1;
if ind_left_child<=heap.len
    display(heap.q(:,ind_left_child));
end
if ind_right_child<=heap.len
    display(heap.q(:,ind_right_child));
end
