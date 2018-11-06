function dist=Points2TriangleDistance(vertices, face,points)

q1=vertices(face(1),:)';
q2=vertices(face(2),:)';
q3=vertices(face(3),:)';
v1=q2-q1; v2=q3-q1;
V=[v1 v2];
coeff=V\(points'-q1);
dist_vect=points'-(q1+V*coeff);
dist=vecnorm(dist_vect);

[m,~]=size(points);
ind_rem=setdiff(1:m,find(coeff(1,:)>=0 & coeff(2,:)>=0 & sum(coeff)<=1));
points_rem=points(ind_rem,:);
v3=q3-q2;
d=v1'*(points_rem'-q1)/vecnorm(v1)^2;
d(d>1)=1; d(d<0)=0;
e=v2'*(points_rem'-q1)/vecnorm(v2)^2;
e(e>1)=1; e(e<0)=0;
f=v3'*(points_rem'-q2)/vecnorm(v3)^2;
f(f>1)=1; f(f<0)=0;

d1=vecnorm(points_rem'-(q1+v1*d));
d2=vecnorm(points_rem'-(q1+v2*e));
d3=vecnorm(points_rem'-(q2+v3*f));
d_vect=[d1;d2;d3];
dist(ind_rem)=min(d_vect);
