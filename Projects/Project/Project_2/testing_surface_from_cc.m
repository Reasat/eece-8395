clear all
close all
clc

% M.faces=[1,2,5;3,4,6;2,7,5];
% M.faces=[1,2,3;
%         3,4,2;
%         3,5,6;
%         7,8,9];
% M.faces=[1,2,3;3,4,2;3,5,6;7,8,9;1,3,5;3,6,4];
% M.vertices=randi(10,9,3);
% M.vertices=[5     5     6;
%      6     6     3;
%      3     1     5;
%      7     3    10;
%      8     9     6;
%      3     1     6;
%      2    10     3;
%      3     8     5;
%      4     5     7];

img = ReadNrrd('..\..\Data\0522c0001\img.nrrd');
img.data = img.data/10+100;
% isolevel = 700/10+100;
isolevel = 300;
M = isosurface(img.data,isolevel);
for i=1:3
    M.vertices(:,i)=M.vertices(:,i)*img.voxsz(i);
end
[numEdges,Edges]=VertexNeighbors(M);
O=struct;
tic
path_traversed=ConnectedComponent_v1(M,Edges);
toc
faces=cell(length(path_traversed),1);
tic
for i=1:length(path_traversed)
    key=zeros(1,length(M.vertices));
    key(path_traversed{i})=1:length(path_traversed{i});
    [mask,~]=ismember(M.faces, path_traversed{i});
    surface_arrays=M.faces(sum(mask,2)==3,:);
    nt=key(M.faces);
    
    O(i).faces=nt(nt(:,1)~=0,:);
    O(i).vertices=M.vertices(path_traversed{i},:);
end
toc

figure(1); clf;
cols = jet(64);
for i=1:length(O)
    DisplayMesh(O(i),cols(1+round(rand(1,1)*63),:));
end
