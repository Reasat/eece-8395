function HeapInsert(node,cost,prev)
global heap;
% if the tree root is at index 1,
% with valid indices 1 through n,
% then each element a at index i has
% children at indices 2i and 2i +1
% its parent at index floor(i ? 2).
for i_node=1:length(node)
    heap.len=heap.len+1;
    heap.q(:,heap.len)=[node(i_node),cost(i_node), prev(i_node)]';
    curr_ind=heap.len;
    parent_ind=floor(heap.len/2);
    while parent_ind>0
        if heap.q(2,parent_ind)< heap.q(2,curr_ind)
            break
        else
            temp=heap.q(:,parent_ind);
            heap.q(:,parent_ind)=heap.q(:,curr_ind);
            heap.q(:,curr_ind)=temp;
            curr_ind=parent_ind;
            parent_ind=floor(curr_ind/2);    
        end       
    end
end
