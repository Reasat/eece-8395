clear all
close all
clc

load ..\Data\0522c0001\structures\BrainStem.mat
figure(1); clf; 

p = patch(M);
color = [1,0,0];% rgb code for ‘red’
opacity = 0.5;% make the surface ‘see-through’
set(p, 'FaceColor', color, 'EdgeColor', 'none','FaceAlpha',opacity);
axis vis3d; % overrides ‘stretch-to-fill’
daspect([1,1,1]);% isotropic aspect ratio
if isempty(findobj(gcf,'Type','Light')) % put in a light if there is not one already
    camlight headlight;
end