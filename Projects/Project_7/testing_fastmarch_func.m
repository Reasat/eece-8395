clear all
close all
clc
global Edges
r=25;
c=25;
d=1;
[Y,X]  = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
Edges =[Y<c,Y>1,X<r,X>1].*(repmat([1:r*c]',[1,4]) +repmat([r,-r,1,-1],[r*c,1]));

img = zeros(r,c,d);
rad = 4;
for i=1:r
    for j=1:c
        for k=1:d
            img(i,j,k) = sqrt((i-r/2)*(i-r/2) +(j-c/2)*(j-c/2) +(k-d/2)*(k-d/2))- rad;
        end
    end
end
figure(1);clf; colormap(gray(256));
image(20*(img(:,:,ceil(d/2))+rad));
hold on;
contour(img(:,:,ceil(d/2)),[0,0],'r'); 
tic
[dmap,nbin,nbout]=FastMarch(img,2.1,1,[]);
toc
% mean(abs(dmap(:)-img(:)))
% max(abs(dmap(:)-img(:)))
nbn = nbin;
nbn.q(:,nbn.len+1:nbout.len+nbn.len) = nbout.q(:,1:nbout.len);
nbn.len = nbn.len+nbout.len;
tic
[dmap,nbin,nbout]=FastMarch(img,2.1,1,nbn);
toc
% figure(3); clf;
% colormap(gray(256));
% image((dmap(:,:,ceil(d/2))+rad)*20)
% hold on;
% contour(dmap(:,:,ceil(d/2)),[0,0],'r');

% figure(4); clf;
% colormap(gray(256));
% image(abs(dmap-img)*500)
