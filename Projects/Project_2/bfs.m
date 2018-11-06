function path_traversed=bfs(M, Edges)
queue_vertice=1:length(M.vertices);
visited=zeros(length(M.vertices),1);
path_traversed={};
i=0;
i_queue_vertice=length(queue_vertice);
while i_queue_vertice
    start_vertice=queue_vertice(i_queue_vertice);
    i_queue_vertice=i_queue_vertice-1;    
    if visited(start_vertice)~=1
        i=i+1;
        path_traversed{i}=start_vertice;
        visited(start_vertice)=1;
        stack=zeros(1,10000);
        i_stack=0;
        for iter_edge=1:length(Edges{start_vertice})
            if visited(Edges{start_vertice}(iter_edge))==0  
                i_stack=i_stack+1;
                stack(i_stack)=Edges{start_vertice}(iter_edge);
            end
        end
        
        while i_stack
           current_vertice=stack(i_stack);
           i_stack=i_stack-1;
           if visited(current_vertice)~=1
               visited(current_vertice)=1;
               path_traversed{i}=[path_traversed{i}, current_vertice];        
%                stack=[stack, Edges{current_vertice}];
               for iter_edge=1:length(Edges{current_vertice})
                   if visited(Edges{current_vertice}(iter_edge))==0
                       i_stack=i_stack+1;
                       stack(i_stack)=Edges{current_vertice}(iter_edge);
                   end
               end
           end     
        end
    end
end
