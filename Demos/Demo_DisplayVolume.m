clear all
close all
clc

img=ReadNrrd('..\Data\0522c0001\img.nrrd');
slc=80;
hfig = figure; clf; % clears current figure
colormap(gray(256)); % sets the colormap to grayscale
image(img.data(:,:,slc)'); % displays the image
% does a transpose so x is x and y is y
daspect([1/img.voxsz(1) 1/img.voxsz(2) 1]) % corrects the aspect ratio
xlabel('x');
ylabel('y');
title(['Slice z = ',num2str(slc)]);

img.data = img.data/10+100;% CT image intensities range from ~-1000 to ~3000
figure
colormap(gray(256)); % sets the colormap to grayscale
image(img.data(:,:,slc)');
daspect([1/img.voxsz(1) 1/img.voxsz(2) 1]) % corrects the aspect ratio
xlabel('x');
ylabel('y');
title(['Slice z = ',num2str(slc)]);

% saggital
slc=256;
figure
colormap(gray(256)); % sets the colormap to grayscale
image((squeeze(img.data(slc,:,:))'));
daspect([1/img.voxsz(2) 1/img.voxsz(3) 1]) % corrects the aspect ratio
xlabel('y');
ylabel('z');
title(['Slice x = ',num2str(slc)]);

figure
colormap(gray(256)); % sets the colormap to grayscale
axis([1,img.dim(2),1,img.dim(3)]);
hold on;
image((squeeze(img.data(slc,:,:))'));
daspect([1/img.voxsz(2) 1/img.voxsz(3) 1]) % corrects the aspect ratio
xlabel('y');
ylabel('z');
title(['Slice x = ',num2str(slc)]);
