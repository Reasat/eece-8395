global Done Pointer Edgs EdgCosts Edg_lens r c path_cost;
r=70;c=50;
testimg = zeros(r,c);
testimg(15:35,15:35) = 255;
figure(1); close(1); figure(1); colormap(gray(256));
image(testimg);
hold on;
Done = zeros(r*c,1);
Pointer = zeros(r*c,1);

Edgs = (repmat([1:r*c]',[1,8]) + repmat([r,-r,1,-1,1-r,r-1,-1-r,1+r],[r*c,1]));
[Y,X] = meshgrid(1:c,1:r);
Y = Y(:);
X = X(:);
Edgs = [Y<c,Y>1,X<r,X>1,X<r&Y>1,X>1&Y<c,X>1&Y>1,X<r&Y<c].*(repmat([1:r*c]',[1,8]) + repmat([r,-r,1,-1,1-r,r-1,-  1-r,1+r],[r*c,1]));
EdgCosts = repmat(1+testimg(1:r*c)',[1,8]);
EdgCosts(:,5:8) = EdgCosts(:,5:8)*sqrt(2); 

Edg_lens = sum(Edgs'~=0)';
for i=1:r*c
    msk = Edgs(i,:)>0;
    Edgs(i,1:Edg_lens(i)) = Edgs(i,msk);
    EdgCosts(i,1:Edg_lens(i)) = EdgCosts(i,msk);
end

seednode = (5-1)*r+10;
endnode =  (50-1)*r+45; 

path_cost=100000*ones(1,r*c);
global heap;
heap=HeapInit(1000);
[nodepath,cost] = GraphSearch2(@EdgeFunc,@NodeMark,@IsNodeMarked,@SetPointer,@GetPointer,seednode,endnode);
pnts = [mod(nodepath'-1,r)+1,floor((nodepath'-1)/r)+1];
plot(pnts(:,1),pnts(:,2),'m')