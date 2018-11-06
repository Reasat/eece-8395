% clear all
% close all
% clc

% M.faces=[1,2,5;3,4,6;2,7,5];
% M.faces=[1,2,3;3,4,2;3,5,6;7,8,9];
M.faces=[1,2,3;3,4,2;3,5,6;7,8,9;1,3,5;3,4,6];
M.vertices=[1,2,3,4,5,6,7,8,9];

% img = ReadNrrd('..\..\Data\0522c0001\img.nrrd');
% img.data = img.data/10+100;
% isolevel = 700/10+100;
% % isolevel = 250;
% M = isosurface(img.data,isolevel);

% tic
[numEdges,Edges]=VertexNeighbors(M);
% toc

%% graph traversal
queue_vertice=1:length(M.vertices);
visited=zeros(length(M.vertices),1);

path_traversed={};
i=0;
tic
while ~isempty(queue_vertice)
    start_vertice=queue_vertice(end);
    queue_vertice(end)=[];
    if visited(start_vertice)~=1
        visited(start_vertice)=1;
        i=i+1;
        path_traversed{i}=start_vertice;
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
toc
