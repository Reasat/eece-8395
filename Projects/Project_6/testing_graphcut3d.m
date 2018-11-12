clear all 
close all
clc
% This demo is an example of a 3D graph cut segmentation with user input.
img = ReadNrrd('img.nrrd');
crp = img;
crp.data = (img.data(200:320,140:225,52:80))/10+100;
crp.dim = size(crp.data);
% img.data = img.data/10+100;
figure(1); close(1); figure(1); colormap(gray(256));
DisplayVolume(crp);
crp.data = round((crp.data-100)*10);
% User collected seeds from the GetSeeds function: fore; back;
% We use the user seeds to build our probability distribution functions:
mn = min(crp.data(:));
mx = max(crp.data(:));
numbins=64;
binsize = (mx-mn+0.001)/numbins;
bins = [mn:binsize:mx];
hist_fore = zeros(1,numbins);
for i=1:size(fore,1)
    for j=max([1,floor(fore(i,1)-fore(i,4))]):min([crp.dim(1),ceil(fore(i,1)+fore(i,4))])
        for k=max([1,floor(fore(i,2)-fore(i,4))]):min([crp.dim(2),ceil(fore(i,2)+fore(i,4))])
            if (j-fore(i,1))*(j-fore(i,1))+(k-fore(i,2))*(kfore(i,2))<fore(i,4)*fore(i,4)
                hist_fore(floor((crp.data(j,k,fore(i,3))-mn)/binsize+1)) =...
                hist_fore(floor((crp.data(j,k,fore(i,3))-mn)/binsize+1))+1;
            end
        end
    end
end
hist_fore = hist_fore/sum(hist_fore);
hist_back = zeros(1,numbins);
for i=1:size(back,1)
    for j=max([1,floor(back(i,1)-back(i,4))]):min([crp.dim(1),ceil(back(i,1)+back(i,4))])
        for k=max([1,floor(back(i,2)-back(i,4))]):min([crp.dim(2),ceil(back(i,2)+back(i,4))])
            if (j-back(i,1))*(j-back(i,1))+(k-back(i,2))*(kback(i,2))<back(i,4)*back(i,4)
                hist_back(floor((crp.data(j,k,back(i,3))-mn)/binsize+1)) =...
                    hist_back(floor((crp.data(j,k,back(i,3))-mn)/binsize+1))+1;
            end
        end
    end
end
hist_back = hist_back/sum(hist_back);
So that we don’t have a zero probability, we add a small number to our pdfs:
hist_fore = hist_fore + 0.001;
hist_back = hist_back + 0.001;