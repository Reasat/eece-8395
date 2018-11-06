function HeapInsert(node,cost,prev)
global heap;
heap.q(:,heap.len+1)=[node,cost,prev]';
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
