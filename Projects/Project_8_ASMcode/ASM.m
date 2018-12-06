function ASM
global dir_data
dir_data='C:\Users\greas\Box\Vanderbilt_Vivobook_Windows\EECE_8395\EECE_395';
% load the dataset -- you will have to change hardcoded directory links in
% this function. This loads all the surfaces and finds corresponding points
% across the dataset.
[d,msh,w] = GetASMDataset();
d = registerdataset(d,w);

%Function for you to write. It outputs a struct pca with members:
%   'e' [9x1]: the non-zero eigenvalues
%   'U' [9x3N]: the corresponding eigenvectors 
%   'phi' [9x3N]: the weighted-least-squares adapted eigenvectors
%   'mn' [3Nx1]: the mean shape concatenated into a long vector, ordered by
%       x1,y1,z1,x2,y2,z2,...,xN,yN,zN
%   'w' [Nx1]: the set of importance weights for each of the N points in
%   the model
pca = createshapemodel(d,w);

% %visualize the percent variance captured by the model
% figure(1); clf;
% plot(cumsum(pca.e)/sum(pca.e))
% %  % Uncomment the lines below to visualize the resulting eigenmodes
% figure(2); clf;
% m = msh(1).m;
% for i=-3:.1:3
%     m.vertices = reshape(pca.mn + i*sqrt(pca.e(1))*pca.U(1,:)',[3,length(pca.mn)/3])';
%     clf;
%     DisplayMesh(m);
%     campos([-203.4072 -119.3906  779.8221])
%     camtarget([208.3237  292.3403  197.5467])
%     camup([ 0.5000    0.5000    0.7071])
%     camva(10)
%     drawnow;
% end
% for i=-3:.1:3
%     m.vertices = reshape(pca.mn + i*sqrt(pca.e(2))*pca.U(2,:)',[3,length(pca.mn)/3])';
%     clf;
%     DisplayMesh(m);
%     campos([-203.4072 -119.3906  779.8221])
%     camtarget([208.3237  292.3403  197.5467])
%     camup([ 0.5000    0.5000    0.7071])
%     camva(10)
%     drawnow;
% end
% for i=-3:.1:3
%     m.vertices = reshape(pca.mn + i*sqrt(pca.e(3))*pca.U(3,:)',[3,length(pca.mn)/3])';
%     clf;
%     DisplayMesh(m);
%     campos([-203.4072 -119.3906  779.8221])
%     camtarget([208.3237  292.3403  197.5467])
%     camup([ 0.5000    0.5000    0.7071])
%     camva(10)
%     drawnow;
% end
% 
% 
% % our errors when fitting the model to the training data should be 0
% for i=1:10
%     x = fit(pca,d(:,i));
%     max(abs(x-d(:,i)))
% end
% 
%loading in a new target image to segment
im = ReadNrrd([dir_data '\0522c0147\img.nrrd']);
msk = ReadNrrd([dir_data '\0522c0147\structures\mandible.nrrd']);
gt = isosurface(msk.data,0);
gt.vertices = gt.vertices.*repmat(msk.voxsz,[length(gt.vertices),1]);
msk = ReadNrrd([dir_data '\0522c0147\structures\submandibular_L.nrrd']);
sm = isosurface(msk.data,0);
sm.vertices = sm.vertices.*repmat(msk.voxsz,[length(sm.vertices),1]);
gt.faces = [gt.faces;sm.faces+length(gt.vertices)];
gt.vertices = [gt.vertices;sm.vertices];

%Initializing model position with a translation of the mean shape and
%displaying it
figure(2); clf; colormap(gray(256));
f = msh(1).m.faces;
DisplayVolume(im,3,130) %Display volume is modified to cut contours in meshes
inp = guidata(gcf);
shp = reshape(pca.mn,[3,length(pca.mn)/3])+repmat([-75;-80;-20],[1,length(pca.mn)/3]);
inp.msh(1).vertices = gt.vertices;
inp.msh(1).faces = gt.faces;
inp.msh(1).color = [0,1,0];
inp.msh(2).vertices = shp';
inp.msh(2).faces = f;
inp.msh(2).color = [1,0,0];
guidata(gcf,inp);

%search the image to fit the model. gt is not used in the process, only for
%display
shp = Search(shp,msh,pca,im,gt);

%display the final result
figure(2);
DisplayVolume();
inp = guidata(gcf);
inp.msh(2).vertices = shp;
guidata(gcf,inp);

return;

%perform the asm search
function shp = Search(shp,msh,pca,im,gt)
[trilist,trilistcnt] = VertexTriangleNeighbors(msh(1).m);

maxiter=50;
shp = shp';

alpha = 0.5;
maxtol = .01;
P = 12;
w = pca.w;
indx=find(w>0);
f = msh(1).m.faces;

for i=1:maxiter    
    vnorms = findnorms(shp,f,indx, trilist, trilistcnt);

    %this vectorizes the image interpolation of all the intensity profiles
    %along all the normals
    ints = reshape(interp3(im.data,(repmat(shp(indx,1),[2*P+3,1]) + ...        
        repmat(vnorms(indx,1)*alpha,[2*P+3,1]).*reshape(repmat([-P-1:P+1],[length(indx),1]),[(2*P+3)*length(indx),1]))/im.voxsz(1),...
        (repmat(shp(indx,2),[2*P+3,1]) + ...
        repmat(vnorms(indx,2)*alpha,[2*P+3,1]).*reshape(repmat([-P-1:P+1],[length(indx),1]),[(2*P+3)*length(indx),1]))/im.voxsz(2),...
        (repmat(shp(indx,3),[2*P+3,1]) + ...
        repmat(vnorms(indx,3)*alpha,[2*P+3,1]).*reshape(repmat([-P-1:P+1],[length(indx),1]),[(2*P+3)*length(indx),1]))/im.voxsz(3)),...
        [length(indx),2*P+3]);
    %gradient of intensity profiles
    grd = ints(:,3:end)-ints(:,1:end-2);
    % world's simplest search function: we want the most negative gradient
    % possible as the normals cross from bright bone to dark soft tissue at
    % the edge of the mandible
    [~,maxk] = min(grd');
    
    figure(3); clf;
    m.faces = f;
    m.vertices = shp;
    DisplayMesh(m);
    campos([-203.4072 -119.3906  779.8221])
    camtarget([208.3237  292.3403  97.5467])
    camup([ 0.5000    0.5000    0.7071])
    camva(10)
    hold on;
    %displays the normals we have found
    DisplayMesh(gt,[0,1,0],.5);
    for k=1:length(indx)
        plot3([shp(indx(k),1);shp(indx(k),1)+vnorms(indx(k),1)],[shp(indx(k),2);shp(indx(k),2)+vnorms(indx(k),2)],[shp(indx(k),3);shp(indx(k),3)+vnorms(indx(k),3)],'k')
    end
    drawnow
    cand=shp;
    %candidates are the points that result from the line searches
    cand(indx,:) = shp(indx,:) + vnorms(indx,:).*alpha.*repmat(maxk'-P-1,[1,3]);
    % here we fit the weighted ASM model to the candidates
    nshp = reshape(fit(pca,reshape(cand',[3*length(shp),1])),[3,length(shp)])';  
    
    %convergence criteria
    tol = mean(abs(nshp(:)-shp(:)))
    shp = nshp;
    if tol < maxtol
        break;
    end
    
end
        
            
    
return;


% find vertex triangle neighbor lists
function [trilist,trilistcnt] = VertexTriangleNeighbors(msh)
shp = msh.vertices;
f = msh.faces;
trilistcnt = zeros(length(shp),1);
trilist = zeros(length(shp),10);
for i=1:length(f)
    for j=1:3
        trilistcnt(f(i,j)) = trilistcnt(f(i,j))+1;
        trilist(f(i,j),trilistcnt(f(i,j))) = i;
    end
end
return;

% finds the surface normals at vertices 'shp' connected with faces 'f' for
% vertex indices in 'indx' using the vertex triangle neighbors 'trilist'
function vnorms = findnorms(shp,f,indx, trilist, trilistcnt)

v1 = shp(f(:,2),:)-shp(f(:,1),:);
v2 = shp(f(:,3),:)-shp(f(:,1),:);
tnorms = cross(v2,v1);
tnorms = tnorms./repmat(sqrt(sum(tnorms'.*tnorms'))',[1,3]);
vnorms = zeros(length(shp),3);
for j=1:length(indx)
    for k=1:trilistcnt(indx(j))
        vnorms(indx(j),:) = vnorms(indx(j),:) + tnorms((trilist(indx(j),k)),:);
    end
    vnorms(indx(j),:) = vnorms(indx(j),:)/norm(vnorms(indx(j),:));
end

% fits our asm to a shape vector
function x = fit(asm,d)

[r,c] = size(d);
nv = r/3;
[x2tox1,Ro,to] = registerpoints(reshape(asm.mn,[3,nv]),reshape(d,[3,nv]),asm.w');


b = asm.phi*[x2tox1(:)-asm.mn];
MD = sqrt(sum(b.*b./asm.e));
if (MD > 3)
    b = b*3/MD;
end

po = asm.mn + (b'*asm.U)';
Ii = inv([Ro,to;0 0 0 1]);
R = Ii(1:3,1:3);
t = Ii(1:3,4);
x = reshape(R*reshape(po,[3,nv]) + repmat(t,[1,nv]),[r,1]);
return;



% finds R and t to minimize |R*x2+t-x1|^2
function [x2tox1,R,t] = registerpoints(x1,x2,w)
    if nargin<3
        w = ones(1,length(x1));
    end
    
    w = w/sum(w);
    
    x1m = x1*w';
    x2m = x2*w';

    C = (repmat(w,[3,1]).*[x1-repmat(x1m,[1,length(x1)])])*[x2-repmat(x2m,[1,length(x2)])]';
    [U,S,V] = svd(C);
    R = U*V';       
    t = x1m - R*x2m;
    x2tox1 = R*x2 + repmat(t,[1,length(x1)]);


return;

% registers a set of shape vectors to each other
function d = registerdataset(din,w)
[r,n] = size(din);
mno = zeros([3,r/3]);
if nargin<2
    w = ones(r/3,1);
end
errtol = 0.01;
d = reshape(din,[3,r/3,n]);
for k=1:1000
    if k==1
        for l=2:n
            d(:,:,l) = registerpoints(d(:,:,1),d(:,:,l),w');
        end
    else
        for l=1:n
            d(:,:,l) = registerpoints(mn,d(:,:,l),w');
        end
    end
    mn = mean(d,3);
    tol = sum(sum(abs(mn-mno)));
    if (tol<errtol)
        break;
    end
    mno=mn;
end
k
tol

d = reshape(d,[r,n]);

return;
    



function [d,msh,w] = GetASMDataset
global dir_data
% To rebuild the dataset after the first time this function runs 
% instead of loading it from the file you can comment out the if-statement

fid = fopen('d.mat','rb')
if fid>0
    fclose(fid);
    load 'd.mat'
    return;
end

%loading training datasets
nms(1,:) = [dir_data '\0522c0001'];
nms(2,:) = [dir_data '\0522c0002'];
nms(3,:) = [dir_data '\0522c0003'];
nms(4,:) = [dir_data '\0522c0009'];
nms(5,:) = [dir_data '\0522c0013'];
nms(6,:) = [dir_data '\0522c0014'];
nms(7,:) = [dir_data '\0522c0017'];
nms(8,:) = [dir_data '\0522c0057'];
nms(9,:) = [dir_data '\0522c0070'];
nms(10,:)= [dir_data '\0522c0077'];

for i=1:10
    im = ReadNrrd([nms(i,:),'\structures\mandible.nrrd']);
    msh(i).m = isosurface(im.data,0.5);
    msh(i).m.vertices = msh(i).m.vertices.*repmat(im.voxsz,[length(msh(i).m.vertices),1]);
end

%obtaining one-to-one correspondence to the first exemplar
M.Vertices = msh(1).m.vertices;
M.Faces = msh(1).m.faces;
figure(1); clf;
DisplayMesh(M);
% Sampling the mesh with a graph traversal depth of 4
msk = SampleMesh(M,4);
w=msk;
X = M.Vertices(msk,:);
hold on;
plot3(X(:,1),X(:,2),X(:,3),'o')
opt.method='nonrigid';
opt.viz=1;
opt.beta=2;

%initializing our corresponding shape vectors
d = zeros(3*length(M.Vertices),length(msh));
d(:,1) = reshape(M.Vertices',[3*length(M.Vertices),1]);
figure(2); clf;
%registering meshes 2:N to mesh 1 using CPD and TPS
for i=2:length(msh)
    N.Vertices = msh(i).m.vertices;
    N.Faces = msh(i).m.faces;
    % Sampling the mesh with a graph traversal depth of 4
    msk = SampleMesh(N,4);
    Y = N.Vertices(msk,:);
    % computes CPD registration on downsampled point set
    [Transform, C]=cpd_register(Y,X, opt);
    Z = Transform.Y;
    % uses TPS to map full surface through CPD registration
    ref2targ = TPS(Z,X,M.Vertices);
    d(:,i) = reshape(ref2targ',[3*length(ref2targ),1]);
    figure(2); clf;
    M.vertices = reshape(d(:,i),[3,length(d)/3])';
    DisplayMesh(M);
    camorbit(-45,-45);
end

dout = d;
mshout = msh;


% repeat for submandibular gland
for i=1:10
im = ReadNrrd([nms(i,:),'\structures\Submandibular_L.nrrd']);
msh(i).m = isosurface(im.data,0.5);
msh(i).m.vertices = msh(i).m.vertices.*repmat(im.voxsz,[length(msh(i).m.vertices),1]);
end
%obtaining one-to-one correspondence to the first exemplar
M.Vertices = msh(1).m.vertices;
M.Faces = msh(1).m.faces;
figure(1); clf;
DisplayMesh(M);
msk1 = SampleMesh(M,4);
X = M.Vertices(msk1,:);
opt.method='nonrigid';
opt.viz=1;
opt.beta=2;
d = zeros(3*length(M.Vertices),length(msh));
d(:,1) = reshape(M.Vertices',[3*length(M.Vertices),1]);
figure(2); clf;
% register all other point sets to point set 1.
for i=2:length(msh)
    N.Vertices = msh(i).m.vertices;
    N.Faces = msh(i).m.faces;
    % samples mesh with search depth of 4
    msk = SampleMesh(N,4);
    Y = N.Vertices(msk,:);
    % computes CPD registration on downsampled point set
    [Transform, C]=cpd_register(Y,X, opt);
    Z = Transform.Y;
    % uses TPS to map full surface through CPD registration
    ref2targ = TPS(Z,X,M.Vertices);
    d(:,i) = reshape(ref2targ',[3*length(ref2targ),1]);
    figure(2); clf;
    M.vertices = reshape(d(:,i),[3,length(d)/3])';
    DisplayMesh(M);
      
end

%building composite shape vectors with both mandible and sub-mandibular
%gland

% set fitting importance weights of mandible to 1 and submandibular gland to 0
w = [w;zeros(length(d)/3,1)];
d = [dout;d];
for i=1:length(mshout)
    msh(i).m.faces = [mshout(i).m.faces;msh(i).m.faces+length(mshout(i).m.vertices)];
    msh(i).m.vertices = [mshout(i).m.vertices;msh(i).m.vertices];
end



save 'd.mat' d msh w

return;


%projects points in pntsin from the source point space to the target point
%space using thin plate splines.
function pntsout = TPS(target,source,pntsin)

numlandmarks = size(target,1);
meshx = repmat(source(:,1)',[numlandmarks,1]);
meshy = repmat(source(:,2)',[numlandmarks,1]);
meshz = repmat(source(:,3)',[numlandmarks,1]);
K = (abs(meshx-meshx')).^2+(abs(meshy-meshy')).^2+(abs(meshz-meshz')).^2;


T = zeros(numlandmarks+4,numlandmarks+4);
T(1:numlandmarks,1) = 1;
T(1:numlandmarks,2:4)= source;
T(1:numlandmarks,5:numlandmarks+4) = sqrt(K);
T(numlandmarks+1,5:numlandmarks+4) = 1;
T(numlandmarks+2:numlandmarks+4,5:numlandmarks+4) = source';



a = T\[target(:,1);0;0;0;0];
b = T\[target(:,2);0;0;0;0];
c = T\[target(:,3);0;0;0;0];
numpnts = length(pntsin);
P = (repmat(pntsin(:,1),[1,numlandmarks]) - repmat(source(:,1)',[numpnts,1])).^2 + ...
    (repmat(pntsin(:,2),[1,numlandmarks]) - repmat(source(:,2)',[numpnts,1])).^2 + ...
    (repmat(pntsin(:,3),[1,numlandmarks]) - repmat(source(:,3)',[numpnts,1])).^2;
pmat = ones(numpnts,4+numlandmarks);
pmat(:,2:4+numlandmarks) = [pntsin,sqrt(P)];
Xo = pmat*a;
Yo = pmat*b;
Zo = pmat*c;
pntsout = [Xo,Yo,Zo];

return;

