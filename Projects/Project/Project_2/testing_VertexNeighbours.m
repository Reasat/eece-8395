clear all
close all
clc

% M.faces=[1,2,5;3,4,6;2,7,5];

img = ReadNrrd('..\..\Data\0522c0001\img.nrrd');
img.data = img.data/10+100;
isolevel = 700/10+100;
M = isosurface(img.data,isolevel);

%% adjacency matrix
% tic
% adj_mat=zeros(max(max(faces)));
% for i=1:length(faces)
%     adj_mat(faces(i,1),faces(i,2))=1;
%     adj_mat(faces(i,2),faces(i,3))=1;
%     adj_mat(faces(i,1),faces(i,3))=1;
%     adj_mat(faces(i,2),faces(i,1))=1;
%     adj_mat(faces(i,3),faces(i,2))=1;
%     adj_mat(faces(i,3),faces(i,1))=1;
%     
% end
% 
% vn={};
% for i=1:length(adj_mat)
%     find(adj_mat(i,:))
%     vn{i}=find(adj_mat(i,:));
% end
% toc

%% brute force
tic
% Edges=cell(max(max(M.faces)),1);
Edges=cell(length(M.vertices),1);
for i=1:length(M.faces)
    Edges{M.faces(i,1)}=[Edges{M.faces(i,1)}, M.faces(i,2), M.faces(i,3)];
    Edges{M.faces(i,2)}=[Edges{M.faces(i,2)}, M.faces(i,1), M.faces(i,3)];
    Edges{M.faces(i,3)}=[Edges{M.faces(i,3)}, M.faces(i,1), M.faces(i,2)];
end
numEdges=zeros(length(Edges),1);
for i=1:length(Edges)
    Edges{i}=unique(Edges{i});
    numEdges=length(Edges{i});
end
toc
    
    
    