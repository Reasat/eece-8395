function [root_node, root_value]=HeapPop2()
global heap

if heap.len==0
    root_node=[];
    root_value=[];
    return
end
root_node=heap.q(1,1);
root_value=heap.q(2,1);
last_element=heap.q(:,heap.len);
heap.len=heap.len-1;
if heap.len==0
    return
end

heap.q(:,1)=last_element;
curr_ind=1;
while 2*curr_ind<=heap.len
    if 2*curr_ind+1<=heap.len % element has two childs
        if heap.q(2,curr_ind)< heap.q(2,2*curr_ind) && heap.q(2,curr_ind)< heap.q(2,2*curr_ind+1)
            break
        else
            % get the minimum of childs
            ind_childs=[2*curr_ind,2*curr_ind+1];
            [~,ind_min]=min(heap.q(2,ind_childs));
            temp=heap.q(:,ind_childs(ind_min));
            heap.q(:,ind_childs(ind_min))=heap.q(:,curr_ind);
            heap.q(:,curr_ind)=temp;
            curr_ind=ind_childs(ind_min);
        end
    else
        if heap.q(2,curr_ind)< heap.q(2,2*curr_ind+1)
            break
        else
            temp=heap.q(:,2*curr_ind+1);
            heap.q(:,2*curr_ind+1)=heap.q(:,curr_ind);
            heap.q(:,curr_ind)=temp;
            curr_ind=2*curr_ind+1;
            
        end
    end
end
