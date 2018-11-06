clear all
close all
clc

% M.faces=[1,2,5;3,4,6;2,7,5];
% M.faces=[1,2,3;3,4,2;3,5,6;7,8,9];
% M.faces=[1,2,3;3,4,2;3,5,6;7,8,9;1,3,5;3,4,6];
% M.vertices=randi(100,9,3);

[filepaths, ~]=glob('..\..\Data\*\img.nrrd');
disp(filepaths{2})
img = ReadNrrd(filepaths{2});
img.data = img.data/10+100;
isolevel = 700/10+100;
% isolevel = 300;
M = isosurface(img.data,isolevel);
for i=1:3
    M.vertices(:,i)=M.vertices(:,i)*img.voxsz(i);
end

[~,Edges]=VertexNeighbors(M);
tic
% for i=1:length(path_traversed)
%     disp(path_traversed{i})
% end
toc