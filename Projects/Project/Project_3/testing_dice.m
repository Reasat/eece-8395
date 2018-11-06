clear all
close all
clc
% First we load in our ground truth mandible and mandible segmentations from 3 raters
gt = ReadNrrd('..\..\Data\0522c0001\structures\mandible.nrrd');
t1 = ReadNrrd('..\..\Data\0522c0001\structures\target1.nrrd');
t2 = ReadNrrd('..\..\Data\0522c0001\structures\target2.nrrd');
t3 = ReadNrrd('..\..\Data\0522c0001\structures\target3.nrrd');

% Now we create surfaces for all of the volumetric segmentations and display them
gts = isosurface(gt.data,0.5);
gts.vertices = gts.vertices.*repmat(gt.voxsz,[length(gts.vertices),1]);
t1s = isosurface(t1.data,0.5);
t1s.vertices = t1s.vertices.*repmat(t1.voxsz,[length(t1s.vertices),1]);
t2s = isosurface(t2.data,0.5);
t2s.vertices = t2s.vertices.*repmat(t2.voxsz,[length(t2s.vertices),1]);
t3s = isosurface(t3.data,0.5);
t3s.vertices = t3s.vertices.*repmat(t3.voxsz,[length(t3s.vertices),1]);
%% confmat
fp=sum(sum(sum(t1.data&~gt.data)));
tp=sum(sum(sum(t1.data&gt.data)));
tn=sum(sum(sum(~t1.data&~gt.data)));
fn=sum(sum(sum(~t1.data&gt.data)));

%% dice
dice1=2*tp/(2*tp+fp+fn);
