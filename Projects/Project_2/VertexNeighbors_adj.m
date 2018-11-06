function [numEdges,Edges]=VertexNeighbors_adj(faces)
%create adjacency matrix
adj_mat=zeros(max(max(faces)));
for i=1:length(faces)
    adj_mat(faces(i,1),faces(i,2))=1;
    adj_mat(faces(i,2),faces(i,3))=1;
    adj_mat(faces(i,1),faces(i,3))=1;
    adj_mat(faces(i,2),faces(i,1))=1;
    adj_mat(faces(i,3),faces(i,2))=1;
    adj_mat(faces(i,3),faces(i,1))=1;
    
end
numEdges=zeros(length(adj_mat),1);
for i=1:length(adj_mat)
    Edges{i}=find(adj_mat(i,:));
    numEdges(i,1)=length(Edges{i});
end