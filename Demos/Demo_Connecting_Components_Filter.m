img = ReadNrrd('..\Data\0522c0001\img.nrrd');
figure(1); clf;
img.data = img.data/10+100;
colormap(gray(256))
DisplayVolume(img,3,79);

isolevel = 700/10+100;
M = isosurface(img.data,isolevel);
% M = isosurface(img.data,200);
for i=1:3
 M.vertices(:,i) = M.vertices(:,i)*img.voxsz(i);
end
figure(2); clf;
DisplayMesh(M);