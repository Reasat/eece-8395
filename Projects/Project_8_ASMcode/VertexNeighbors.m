function [numEdges,Edges_list]=VertexNeighbors(M)

Edges=cell(length(M.Vertices),1);
for i=1:length(M.Faces)
    Edges{M.Faces(i,1)}=[Edges{M.Faces(i,1)}, M.Faces(i,2), M.Faces(i,3)];
    Edges{M.Faces(i,2)}=[Edges{M.Faces(i,2)}, M.Faces(i,1), M.Faces(i,3)];
    Edges{M.Faces(i,3)}=[Edges{M.Faces(i,3)}, M.Faces(i,1), M.Faces(i,2)];
end
numEdges=zeros(length(Edges),1);
for i=1:length(Edges)
    Edges{i}=unique(Edges{i});
    numEdges(i)=length(Edges{i});   
end
Edges_list=zeros(length(M.Vertices),15);
for i=1:length(M.Vertices)
    Edges_list(i,1:numEdges(i))=Edges{i};
end
