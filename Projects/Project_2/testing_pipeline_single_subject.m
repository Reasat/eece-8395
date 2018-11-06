clear all
close all
clc

% isolevel = 700/10+100;
isolevel = 300;

[filepaths, ~]=glob('..\..\Data\*\img.nrrd');
disp(filepaths{2})
img = ReadNrrd(filepaths{1});
img.data = img.data/10+100;
M = isosurface(img.data,isolevel);
for i=1:3
    M.vertices(:,i)=M.vertices(:,i)*img.voxsz(i);
end
tic
[numEdges,Edges]=VertexNeighbors(M);
toc
tic
O=ConnectedComponent(M,Edges);
toc
%% display connected components
figure(1); clf;
cols = jet(64);
for i=1:length(O)
    DisplayMesh(O(i),cols(1+round(rand(1,1)*63),:));
end
%% display max volume
V=zeros(1,length(O));
for i_cc=1:length(O)
    V(i_cc)=VolumeofMesh(O(i_cc));
end
[V_max,ind_max]=max(V);
figure(2);clf;
DisplayMesh(O(ind_max));
