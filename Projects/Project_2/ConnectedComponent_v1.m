function path_traversed=ConnectedComponent_v1(M,Edges)
queue_vertice=1:length(M.vertices);
visited=zeros(length(M.vertices),1);

path_traversed={};
i=0;

while ~isempty(queue_vertice)
    start_vertice=queue_vertice(end);
    queue_vertice(end)=[];
    if visited(start_vertice)~=1
        i=i+1;
        path_traversed{i}=start_vertice;
        visited(start_vertice)=1;
        stack=Edges{start_vertice};
        while ~isempty(stack)
           current_vertice=stack(end) ;
           stack(end)=[] ;
           if visited(current_vertice)~=1
               visited(current_vertice)=1;
               path_traversed{i}=[path_traversed{i}, current_vertice];        
%                stack=[stack, Edges{current_vertice}];
               for iter_edge=1:length(Edges{current_vertice})
                   if visited(Edges{current_vertice}(iter_edge))==0
                       stack=[stack, Edges{current_vertice}(iter_edge)];
                   end
               end
           end     
        end
    end
end

