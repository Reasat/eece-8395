clear all
close all
clc

img=ReadNrrd('..\..\Data\0522c0001\img.nrrd');
img.data = img.data/10+100;% CT image intensities range from ~-1000 to ~3000
slc=256;
inp.img = img;
inp.slc = slc;

hfig = figure(1); clf; % clears current figure
guidata(hfig,inp);
hfig = gcf;
set(hfig,'KeyPressFcn','');

iptaddcallback(hfig,'KeyPressFcn',@MyKeyboardCallback);