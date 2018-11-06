clear all
close all
clc
global r c dmap heap Active Edgs
r = 25;
c = 25;
d=1;
img=zeros(r,c,d);
rad = 4;
for i=1:r
    for j=1:c
        for k=1:d
            img(i,j,k) = sqrt((i-r/2)*(i-r/2) +(j-c/2)*(j-c/2) +(k-d/2)*(k-d/2))- rad;
        end
    end
end
% 1--> Compute Eikonal 
% 0--> All done
% 2--> Far away
figure(1);clf; colormap(gray(256));
image(20*(img(:,:,ceil(d/2))+rad));
hold on;
contour(img(:,:,ceil(d/2)),[0,0],'r');
heap = HeapInit(10000);
[Y,X] = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
% Edgs =[Y<c,Y>1,X<r,X>1].*(repmat([1:r*c]',[1,4]) +repmat([r,-r,1,-1],[r*c,1]));
Edgs =[X<r,X>1,Y<c,Y>1].*(repmat([1:r*c]',[1,4]) +repmat([1,-1,r,-r],[r*c,1]));
dmapi=img;
dmap = 3e8*ones(r,c,d);
dmap(dmapi(:)==0)=0;
Active = ones(r,c,d);
% InsertBorderVoxelsIntoHeap
InsertBorderVoxelsIntoHeap(dmapi,1)

figure(2); clf; colormap(gray(256));
image(dmap(:,:,ceil(d/2))*255)
hold on;
cntr = contour(dmapi(:,:,ceil(d/2)),[0,0],'r');

[node,dist]=HeapPop;
while ~isempty(node)
    figure(2);
    hold off
    image(dmap(:,:,ceil(d/2))*75)
    hold on;
    plot([cntr(1,2:end),cntr(1,2)],[cntr(2,2:end),cntr(2,2)],'r');
    drawnow;
    Active(node)=0;
    % ProcessNeighborsEikonel
    ProcessNeighborsEikonal(node,dmapi,1)
    [node,dist] = HeapPop();
    while (~isempty(node))&&Active(node)==0
        [node,dist] = HeapPop();
    end
    HeapDisp
    
end

% That gives us our foreground distance map. Now we do it again for background.
dmapin = dmap;
dmap = 3e8*ones(r,c,d);
dmap(dmapi(:)==0)=0;
Active = ones(r,c,d);

% background
InsertBorderVoxelsIntoHeap(dmapi,-1);
figure(2); clf; colormap(gray(256));
image(dmap(:,:,ceil(d/2))*255)
hold on;
cntr = contour(dmapi(:,:,ceil(d/2)),[0,0],'r');
[node,dist] = HeapPop();
while ~isempty(node)
    figure(2);
    hold off
    image(dmap(:,:,ceil(d/2))*25)
    hold on;
    plot([cntr(1,2:end),cntr(1,2)],[cntr(2,2:end),cntr(2,2)],'r');
    drawnow;
    
    Active(node)=0;
    ProcessNeighborsEikonal(node,dmapi,-1);
    
    [node,dist] = HeapPop();
    while (~isempty(node))&&Active(node)==0
        [node,dist] = HeapPop();
    end
    
end
%Then we combine the two results into our output distance map:
dmapout = dmap;
dmapout(dmapi(:)<0) = -dmapin(dmapi(:)<0);

figure(3); clf;
colormap(gray(256));
image((dmapout(:,:,ceil(d/2))+rad)*20)
hold on;
contour(dmapout(:,:,ceil(d/2)),[0,0],'r');