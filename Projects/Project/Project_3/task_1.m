clear all
close all
clc
%% 1a) First we load in our ground truth mandible and mandible segmentations from 3 raters
gt = ReadNrrd('..\..\Data\0522c0001\structures\mandible.nrrd');
t1 = ReadNrrd('..\..\Data\0522c0001\structures\target1.nrrd');
t2 = ReadNrrd('..\..\Data\0522c0001\structures\target2.nrrd');
t3 = ReadNrrd('..\..\Data\0522c0001\structures\target3.nrrd');

%% 1b) Now we create surfaces for all of the volumetric segmentations.
gts = isosurface(gt.data,0.5);
gts.vertices = gts.vertices.*repmat(gt.voxsz,[length(gts.vertices),1]);
t1s = isosurface(t1.data,0.5);
t1s.vertices = t1s.vertices.*repmat(t1.voxsz,[length(t1s.vertices),1]);
t2s = isosurface(t2.data,0.5);
t2s.vertices = t2s.vertices.*repmat(t2.voxsz,[length(t2s.vertices),1]);
t3s = isosurface(t3.data,0.5);
t3s.vertices = t3s.vertices.*repmat(t3.voxsz,[length(t3s.vertices),1]);

%% 1c) Display the surfaces in one figure
figure(1);clf
DisplayMesh(gts,[1,0,0],0.5);DisplayMesh(t1s,[0,1,0],0.5);DisplayMesh(t2s,[0,0,1],0.5);DisplayMesh(t3s,[0.5,0,0.5],0.5)
legend('Ground Truth', 'Mask1','Mask2','Mask3')

%% 1d) Calculate volume
volume_gts=VolumeofMesh(gts);
volume_t1s=VolumeofMesh(t1s);
volume_t2s=VolumeofMesh(t2s);
volume_t3s=VolumeofMesh(t3s);

%% 1e) Measure Dice similarity, mean symmetric absolute surface, Hausdorff 
% distance between the ground truth and each of the three raters

%% Dice
dice_t1=dice(t1.data,gt.data);
dice_t2=dice(t2.data,gt.data);
dice_t3=dice(t3.data,gt.data);
%% mean symmetric absolute surface, and Hausdorff distance
[mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t1s);
meandist1=mean([mn1,mn2]);
hausdorff1=max([mx1,mx2]);

[mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t2s);
meandist2=mean([mn1,mn2]);
hausdorff2=max([mx1,mx2]);

[mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t3s);
meandist3=mean([mn1,mn2]);
hausdorff3=max([mx1,mx2]);

%% 1g) Create a majority vote segmentation from the three rater segmentations, 
% measure its volume, and measure Dice similarity, Mean surface, and
% Hausdorff distances to the ground truth

mv = t1;
mv.data = t1.data + t2.data + t3.data > 1.5;
mvs = isosurface(mv.data,0.5);
mvs.vertices = mvs.vertices.*repmat(mv.voxsz,[length(mvs.vertices),1]);
[mn1,mn2,mx1,mx2]=SurfaceDistance(gts,mvs);
meandistmv=mean([mn1,mn2]);
hausdorffmv=max([mx1,mx2]);

