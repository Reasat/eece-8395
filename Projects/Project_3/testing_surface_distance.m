clear all
close all
clc
%
% % FV.faces = [5 3 1; 3 2 1; 3 4 2; 4 6 2];
% % FV.vertices = [2.5 8.0 1; 6.5 8.0 2; 2.5 5.0 1; 6.5 5.0 0; 1.0 6.5 1; 8.0 6.5 1.5];
% % points = [2 4 2; 4 6 2; 5 6 2];
%
% % [distances,surface_points] = point2trimesh(FV, 'QueryPoints', points);
% % distances
% % dist_mine=zeros(1,length(points));
% % for i=1:length(points)
% %   dist_mine(i)=Point2TriangleDistance(FV.vertices, FV.faces,points(i,:));
% % end
% % dist_mine
%
%% 1a) First we load in our ground truth mandible and mandible segmentations from 3 raters
gt = ReadNrrd('..\..\Data\0522c0001\structures\mandible.nrrd');
t1 = ReadNrrd('..\..\Data\0522c0001\structures\target1.nrrd');

%% 1b) Now we create surfaces for all of the volumetric segmentations.
gts = isosurface(gt.data,0.5);
gts.vertices = gts.vertices.*repmat(gt.voxsz,[length(gts.vertices),1]);
t1s = isosurface(t1.data,0.5);
t1s.vertices = t1s.vertices.*repmat(t1.voxsz,[length(t1s.vertices),1]);

% dist=1000*ones(1,length(t1s.vertices));
%
% % q1=vertices(face(1),:);
% % q2=vertices(face(2),:);
% % q3=vertices(face(3),:);
% % v1=q2-q1; v2=q3-q1;
% % V=[v1;v2];
% % coeff=V'\(p-q1)';
% % if coeff(1)>=0 && coeff(2)>=0 && coeff(1)+coeff(1)<=1
% %     dist=norm(p-(q1+V'*coeff));
% % else
% %     v3=q3-q2;
% %     d=v1*(p-q1)'/norm(v1)^2;
% %     e=v2*(p-q1)'/norm(v2)^2;
% %     f=v3*(p-q2)'/norm(v3)^2;
% %     d1=norm(p-(q1+v1*d));
% %     d2=norm(p-(q1+v2*e));
% %     d3=norm(p-(q2-v3*f));
% %     dist=min([d1,d2,d3]);
% % end
% n_sample=10;
% face=gts.faces(1,:);
% vertices=gts.vertices;
% points=t1s.vertices(1:n_sample,:);
%
% dist1=[];
% for i=1:length(points)
%     dist=Point2TriangleDistance(vertices, face,points(i,:));
%     dist1=[dist1,dist];
% end
%
% q1=vertices(face(1),:);
% q2=vertices(face(2),:);
% q3=vertices(face(3),:);
% v1=q2-q1; v2=q3-q1;
% V=[v1;v2];
% coeff=V'\(points'-q1');
% dist_vect2=points'-(q1'+V'*coeff);
% dist2=vecnorm(dist_vect2);
% ind_rem=setdiff(1:n_sample,find(coeff(1,:)>=0 & coeff(2,:)>=0 & sum(coeff)<1));
% points_rem=points(ind_rem,:);
% v3=q3-q2;
% d=v1*(points_rem'-q1')/vecnorm(v1)^2;
% e=v2*(points_rem'-q1')/vecnorm(v2)^2;
% f=v3*(points_rem'-q2')/vecnorm(v3)^2;
% d1=vecnorm(points_rem'-(q1'+v1'*d));
% d2=vecnorm(points_rem'-(q1'+v2'*e));
% d3=vecnorm(points_rem'-(q2'-v3'*f));
% d_vect=[d1;d2;d3];
% dist2(ind_rem)=min(d_vect);
% [dist1;dist2]'
%
% % if coeff(1)>=0 && coeff(2)>=0 && coeff(1)+coeff(1)<=1
% %     dist=norm(points-(q1+V'*coeff));
% % end
[mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t1s);
meandist1=mean([mn1,mn2]);
hausdorff1=max([mx1,mx2]);
