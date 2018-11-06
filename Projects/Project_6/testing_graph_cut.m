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
img = zeros(r,c);
img(15:35,15:35) = 1;
% Since we will use to define probability of belonging to S, we don’t want fully hard constraints
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
nodes = [1:r*c]';
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
FIFOInsert(nodes);
% And perform the min-cut:
while (1)
    P = Grow();
    if isempty(P)
        break;
    end
    Augment(P);
    Adoption();
end
figure(2); close(2); figure(2); colormap(gray(256));
image(reshape(Tree(1:r*c)*255/2,[r,c]));
% OK but that was easy, what if we have some noise?
noise = 0.4;
img = zeros(r,c);
img(15:35,15:35) = 1;
rng('default');
img = img +noise*randn(r,c);
img(img(:)<0.01)=0.01;
img(img(:)>.99)=.99;

% The noisy result is not so perfect. Let’s wrap all this in a function so we can look at sigma,
% lambda, and noise
function testGraphCut(sigma,lambda,noise)
figure(1);
image(255*img);
drawnow;
figure(2);
image(reshape(Tree(1:r*c)*255/2,[r,c]));
drawnow;
for sigma = 0.05:.1:2
    testGraphCut(sigma,.1,.4);
    
    title(['sigma=',num2str(sigma)])
end
for lambda = 0:5
    testGraphCut(.8,.5^lambda,.4);
    title(['lambda=',num2str(.5^lambda)])
end
for noise = 0.25:0.025:1
    testGraphCut(.8,.125,noise);
end
% % Let’s look at performance with graph size:
% function testGraphCut(sigma,lambda,noise,rin,cin)
% % We’ll quadruple the size of the graph by doubling r & c:
% s=50;
% for i=1:4
%  tic
%  testGraphCut(.8,0.125,.4,s,s);
%  tms(i) = toc;
%  s = 2*s;
% end
% tms
% tms(2:4)./tms(1:3)
%
% % 0.6928 2.3374 8.9446 35.6555
% % 3.3739 3.8267 3.9862
% % Computation time grows almost linearly with the size of the graph.
% % We can also try another kind of n-link cost not based on image gradients. What if we just want to
% % limit the total number of edges in the cut?
% for lambda = 0:5
%  testGraphCut(inf,.5^lambda,.4,50,50);
% title(['lambda=',num2str(.5^lambda)])
% end
% % We can see that at .5^5, the segmentation is total background, no foreground because the cost of
% % the n-links has gotten too large relative to the t-links.