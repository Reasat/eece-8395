function [numEdges,Edges]=VertexNeighbors(M)

Edges=cell(length(M.vertices),1);
for i=1:length(M.faces)
    Edges{M.faces(i,1)}=[Edges{M.faces(i,1)}, M.faces(i,2), M.faces(i,3)];
    Edges{M.faces(i,2)}=[Edges{M.faces(i,2)}, M.faces(i,1), M.faces(i,3)];
    Edges{M.faces(i,3)}=[Edges{M.faces(i,3)}, M.faces(i,1), M.faces(i,2)];
end
numEdges=zeros(length(Edges),1);
for i=1:length(Edges)
    Edges{i}=unique(Edges{i});
    numEdges(i)=length(Edges{i});
end
