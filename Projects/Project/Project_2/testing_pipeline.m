clear all
close all
clc

isolevel = 700/10+100;
% isolevel = 300;
[filepaths, ~]=glob('..\..\Data\*\img.nrrd');
V_max=zeros(1,length(filepaths));
for i_fl=1:length(filepaths)
    disp(i_fl)
    tic
    img = ReadNrrd(filepaths{i_fl});
    img.data = img.data/10+100;
    M = isosurface(img.data,isolevel);
    for i=1:3
        M.vertices(:,i)=M.vertices(:,i)*img.voxsz(i);
    end

    [numEdges,Edges]=VertexNeighbors(M);

    O=ConnectedComponent(M,Edges);
    
    for i_cc=1:length(O)
        V=VolumeofMesh(O(i_cc));
        if V>V_max(i_fl)
            V_max(i_fl)=V;
        end
    end
    toc
end
save('Data_Project_2')