img = ReadNrrd('D:\Data\EECE_8395\0522c0001\img.nrrd');
slcim = img;
fp = [260,150,70];
sp = [320,220,107];
slcim.data = img.data(fp(1):sp(1),fp(2):sp(2),fp(3):sp(3))/2+100;
slcim.dim = size(slcim.data);
figure(1); close(1); hfig = figure(1); colormap(gray(256));
DisplayVolume(slcim,3,19);
LiveWireSegment3D();