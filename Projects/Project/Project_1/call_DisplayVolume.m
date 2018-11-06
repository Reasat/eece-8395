clear all
close all
clc
img=ReadNrrd('..\..\Data\0522c0001\img.nrrd');
img.data=img.data/10+100;
% 1-> saggital
% 2-> coronal
% 3-> axial
% DisplayVolume(img,1,56)
DisplayVolume(img,3,70)
% DisplayVolume(img,3,256)