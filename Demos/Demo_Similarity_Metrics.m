% First we load in our ground truth mandible and mandible segmentations from 3 raters
gt = ReadNrrd('..\Data\0522c0001\structures\mandible.nrrd');
t1 = ReadNrrd('..\Data\0522c0001\structures\target1.nrrd');
t2 = ReadNrrd('..\Data\0522c0001\structures\target2.nrrd');
t3 = ReadNrrd('..\Data\0522c0001\structures\target3.nrrd');
% Now we create a majority vote from the 3 raters
mv = t1;
mv.data = t1.data + t2.data + t3.data > 1.5;
% Now we create surfaces for all of the volumetric segmentations and display them
gts = isosurface(gt.data,0.5);
gts.vertices = gts.vertices.*repmat(gt.voxsz,[length(gts.vertices),1]);
t1s = isosurface(t1.data,0.5);
t1s.vertices = t1s.vertices.*repmat(t1.voxsz,[length(t1s.vertices),1]);
t2s = isosurface(t2.data,0.5);
t2s.vertices = t2s.vertices.*repmat(t2.voxsz,[length(t2s.vertices),1]);
t3s = isosurface(t3.data,0.5);
t3s.vertices = t3s.vertices.*repmat(t3.voxsz,[length(t3s.vertices),1]);
mvs = isosurface(mv.data,0.5);
mvs.vertices = mvs.vertices.*repmat(mv.voxsz,[length(mvs.vertices),1]);
% We can also display the results overlaid on the CT image.
img = ReadNrrd('0522c0001\img.nrrd');
norm_img = img;
norm_img.data = img.data/10+100;
norm_img.data(norm_img.data(:)>255)=255;
norm_img.data(norm_img.data(:)<0)=0;
comb1 = norm_img;
comb1.data(t1.data(:)>0) = norm_img.data(t1.data(:)>0)+256;
comb1.data = comb1.data/2;
figure(5); clf; colormap([gray(128);jet(128)]);
DisplayVolume(comb1,3,60);
figure(1); clf;
DisplayMesh(gts,[1,1,0],0.5)
DisplayMesh(t1s,[1,0,0],0.5)
figure(2); clf;
DisplayMesh(gts,[1,1,0],0.5)
DisplayMesh(t3s,[0,0,1],0.5)
figure(4); clf;
DisplayMesh(gts,[1,1,0],0.5)
DisplayMesh(mvs,[.5,.5,.5],0.5)
% If we want a more zoomed in view, we can crop the CT image before display.
comb1.data = comb1.data(175:325,125:300,:);
figure(5); clf; colormap([gray(128);jet(128)]);
DisplayVolume(comb1,3,60);
DisplayMesh(t2s,[0,1,0],0.5)
figure(3); clf;
DisplayMesh(gts,[1,1,0],0.5)
% Now let’s compute our similarity metrics on these datasets:
conf1 = ConfusionMatrix(t1,gt);
conf3 = ConfusionMatrix(t3,gt);