img = ReadNrrd('..\..\Data\0522c0001\img.nrrd');
img.data = img.data/10+100;

isolevel = 700/10+100;
M = isosurface(img.data,isolevel);

for i=1:3
    M.vertices(:,i) = M.vertices(:,i)*img.voxsz(i);
end
