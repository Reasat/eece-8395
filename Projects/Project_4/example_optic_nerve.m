clear all
close all
clc

global Done Pointer Edgs EdgCosts Edg_lens r c;
global midcontour path pathcnt donepathcnt donepath
midcontour = 0;
global done
done=0;

% img=ReadNrrd('D:\Data\EECE_8395\0522c0001\img.nrrd');
img = ReadNrrd('C:\Users\greas\Box\Vanderbilt_Vivobook_Windows\EECE_8395\EECE_395\0522c0001\img.nrrd');

slcim = img;
fp = [260,150,70];
sp = [320,220,107];
slcim.data = img.data(fp(1):sp(1),fp(2):sp(2),fp(3):sp(3))/2+100;
slcim.dim = size(slcim.data);

slc = slcim.data(:,:,19);
[r,c] = size(slc);
Done = zeros(r*c,1);
Pointer = zeros(r*c,1);
% clear edgecost;
g = fspecial('gaussian',[5,5],1);
im2 = conv2(slc,g,'same');
edgecost(:,:,1) = (abs(conv2(im2,[-1 0 1;-1 0 1;-1 0 1],'same')));
edgecost(:,:,2) = edgecost(:,:,1);
edgecost(:,:,3) = (abs(conv2(im2,[-1 0 1;-1 0 1;-1 0 1]','same')));
edgecost(:,:,4) = edgecost(:,:,3);
edgecost(:,:,5) = (abs(conv2(im2,sqrt(2)/2*[-2 -1 0;-1 0 1;0 1 2],'same')));
edgecost(:,:,6) = edgecost(:,:,5);
edgecost(:,:,7) = (abs(conv2(im2,sqrt(2)/2*[0 1 2;-1 0 1;-2 -1 0],'same')));
edgecost(:,:,8) = edgecost(:,:,7);
BW = edge(slc,'canny',.1);
v = max(edgecost(:));
for i=1:8
    edgecost(:,:,i) = edgecost(:,:,i) + v*BW;
end
edgecost = max(edgecost(:)) - edgecost;
edgecost(:,:,5:8) = edgecost(:,:,5:8)*sqrt(2);
[Y,X] = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
Edgs = [Y<c,Y>1,X<r,X>1,X<r&Y>1,X>1&Y<c,X>1&Y>1,X<r&Y<c].*(repmat([1:r*c]',[1,8]) + repmat([r,-r,1,-1,1-r,r-1,-1-r,1+r],[r*c,1]));
EdgCosts = reshape(edgecost,[r*c,8]);
EdgCosts(:,5:8) = EdgCosts(:,5:8)*sqrt(2);
Edg_lens = sum(Edgs'~=0)';
for i=1:r*c
    msk = Edgs(i,:)>0;
    Edgs(i,1:Edg_lens(i)) = Edgs(i,msk);
    EdgCosts(i,1:Edg_lens(i)) = EdgCosts(i,msk);
end
figure(1); close(1); hfig = figure(1); colormap(gray(256));
DisplayVolume(slcim,3,19);
iptaddcallback(hfig,'WindowButtonDownFcn',@MouseButtonDownCallback);
iptaddcallback(hfig,'WindowButtonMotionFcn',@MouseMoveCallback);

while ~(done)
pause(.5);
end
contour = donepath(:,1:donepathcnt);
