clear all
close all
clc
%% HeapInit
% initlen=1000;
% heap=struct;
% heap.q=zeros(3,initlen);
% heap.len=sum(heap.q(1,:)>0);
global heap;
heap=HeapInit(10);

%% HeapInsert(node,cost,previous)
% node=2;cost=10;prev=1;
% heap.q(:,heap.len+1)=[node,cost,prev]';
% heap.len=heap.len+1;
% heap.q(:,1:heap.len)
% for i=heap.len:-1:2
%     if heap.q(2,i)>heap.q(2,i-1)
%         break
%     else
%        temp=heap.q(:,i-1);
%        heap.q(:,i-1)=heap.q(:,i);
%        heap.q(:,i)=temp;
%     end
% end
% heap.q(:,1:heap.len)
% 
% node=2;cost=5;prev=1;
% heap.q(:,heap.len+1)=[node,cost,prev]';
% heap.len=heap.len+1;
% heap.q(:,1:heap.len)
% for i=heap.len:-1:2
%     if heap.q(2,i)>heap.q(2,i-1)
%         break
%     else
%        temp=heap.q(:,i-1);
%        heap.q(:,i-1)=heap.q(:,i);
%        heap.q(:,i)=temp;
%     end
% end
% heap.q(:,1:heap.len)
% 
% node=3;cost=2;prev=2;
% heap.q(:,heap.len+1)=[node,cost,prev]';
% heap.len=heap.len+1;
% heap.q(:,1:heap.len)
% for i=heap.len:-1:2
%     if heap.q(2,i)>heap.q(2,i-1)
%         break
%     else
%        temp=heap.q(:,i-1);
%        heap.q(:,i-1)=heap.q(:,i);
%        heap.q(:,i)=temp;
%     end
% end
% heap.q(:,1:heap.len)

HeapInsert(2,10,1)
heap.q(:,1:heap.len)
HeapInsert(3,20,1)
heap.q(:,1:heap.len)
HeapInsert(3,2,1)
heap.q(:,1:heap.len)
return
%% HeapPop
% [~,ind]=min(heap.q(2,1:heap.len));
% heap.q(:,ind)=[];
% heap.len=heap.len-1;
HeapPop
heap.q(:,1:heap.len)