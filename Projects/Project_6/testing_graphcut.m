% EECE 8395: Medical Image Segmentation
% Vanderbilt University
% Prof. Jack H. Noble
% Graph Cuts
clear all
close all
clc
% Initialize all of our helper Hash Tables:
global Parent Tree Active EdgeCaps Edges Edge_Lens r c Orphans Orphan_cnt PLengths
r=50;
c=50;

noise = 0.4;
img = zeros(r,c);
img(15:35,15:35) = 1;
rng('default');
img = img +noise*randn(r,c);
img(img(:)<0.01)=0.01;
img(img(:)>.99)=.99;
figure(1); close(1); figure(1); colormap(gray(256));
image(255*img);

% Parameters in our Graph Cut
sigma = 0.2;
lambda = 0.1;

Tree = zeros(r*c+2,1);
Tree(r*c+1)=1; % s
Tree(r*c+2)=2; % t
% The first r*c entries in Tree will contain our final segmentation – 1 for s and 2 for t
Parent = zeros(r*c+2,1);
Active = zeros(r*c+2,1);
nodes = (1:r*c)';
X = mod(nodes-1,r)+1;
Y = floor((nodes-1)/r)+1;
Edges = [X<r,X>1,Y<c,Y>1].*[nodes+1, nodes-1, nodes+r, nodes-r];
Edge_Lens = sum(Edges'>0)';
EdgeCaps = zeros(r*c,6);
EdgeCaps(:,5) = -lambda*log(1-img(:)');%s
EdgeCaps(:,6) = -lambda*log(img(:)');%t
EdgeCaps(:,1) = (1-lambda)*reshape([exp(-((img(1:end-1,:)-img(2:end,:)).^2)/(2*sigma*sigma));-ones(1,c)],[r*c,1]);%x+1
EdgeCaps(:,2) = (1-lambda)*reshape([-ones(1,c);exp(-((img(1:end-1,:)-img(2:end,:)).^2)/(2*sigma*sigma))],[r*c,1]);%x-1
EdgeCaps(:,3) = (1-lambda)*reshape([ exp(-((img(:,1:end-1)-img(:,2:end)).^2)/(2*sigma*sigma)),-ones(r,1)],[r*c,1]);%y+1
EdgeCaps(:,4) = (1-lambda)*reshape([-ones(r,1), exp(-((img(:,1:end-1)-img(:,2:end)).^2)/(2*sigma*sigma))],[r*c,1]);%y-1

for i=1:r*c
    EdgeCaps(i,1:Edge_Lens(i)) = EdgeCaps(i,Edges(i,1:4)>0);
    Edges(i,1:Edge_Lens(i)) = Edges(i,Edges(i,1:4)>0);
end
% PLengths will help us keep track of the length of the current path to each node – this will help us
% construct shorter paths in the adoption step:
PLengths = zeros(r*c+2,1);
% We also need Orphans to be a global so that they can be identified in the Augment step and
% addressed in the Adoption step:
Orphans = zeros(1,10000);
Orphan_cnt = 0;
% Finally, we can actually do the first grow step ourselves in a way that guarantees the initial tree
% assignments match our prior probability distribution function. This reduces a lot of orphan
% adoption operations that would occur if we instead connected all nodes to s initially:
msk = img(:)>0.5;
Active(1:r*c)=1;
Tree(msk)=1;
Tree(~msk)=2;
Parent(msk)=r*c+1;
Parent(~msk)=r*c+2;
% Finally add all the active nodes to the FIFO
FIFOInit(10*r*c);
for i=1:length(nodes)
    FIFOInsert(nodes(i));
end
% And perform the min-cut:
iter=0;
while (1)
    iter=iter+1;
    disp(['iteration ' num2str(iter)])
    P = Grow();
    disp('found path')
    disp(P)
    if ActiveCheck>0
        disp('non-active nodes adjacent to free nodes found')
    end
    if isempty(P)
        break;
    end
    
    Augment(P);
    
    Adoption()
    
end
totcap= CutCheck()
figure(2); close(2); figure(2); colormap(gray(256));
image(reshape(Tree(1:r*c)*255/2,[r,c]));