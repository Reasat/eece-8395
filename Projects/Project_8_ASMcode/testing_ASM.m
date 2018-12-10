% clear
% close all
% clc
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
% our errors when fitting the model to the training data should be 0
for i=1:10
    x = fit(pca,d(:,i));
    max(abs(x-d(:,i)))
end
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

