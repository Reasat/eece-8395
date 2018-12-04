function HeapInsert(node,dist)
global heap;
for i_node=1:length(node)
    heap.q(:,heap.len+1)=[node(i_node),dist(i_node)]';
    heap.len=heap.len+1;
    for i=heap.len:-1:2
        if heap.q(2,i)>heap.q(2,i-1)
            break
        else
            temp=heap.q(:,i-1);
            heap.q(:,i-1)=heap.q(:,i);
            heap.q(:,i)=temp;
        end
    end
end
