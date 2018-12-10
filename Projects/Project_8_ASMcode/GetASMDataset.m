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

