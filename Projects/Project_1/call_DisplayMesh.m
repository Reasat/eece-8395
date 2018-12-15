% clear all
% close all
% clc
dir_data='C:\Users\greas\Box\Vanderbilt_Vivobook_Windows\EECE_8395\EECE_395';
load([dir_data '\0522c0001\structures\BrainStem.mat'])
DisplayMesh(M,[0,0,1],0.2)