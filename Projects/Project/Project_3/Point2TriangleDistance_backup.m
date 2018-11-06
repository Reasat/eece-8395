function dist=Point2TriangleDistance_backup(vertices, face,p)
q1=vertices(face(1),:);
q2=vertices(face(2),:);
q3=vertices(face(3),:);
v1=q2-q1; v2=q3-q1;
V=[v1;v2];
coeff=V'\(p-q1)';

if coeff(1)>=0 && coeff(2)>=0 && coeff(1)+coeff(2)<=1
    dist_vect1=p-(q1+(V'*coeff)');
    dist=norm(dist_vect1);
else
    v3=q3-q2;
    d=v1*(p-q1)'/norm(v1)^2;
    e=v2*(p-q1)'/norm(v2)^2;
    f=v3*(p-q2)'/norm(v3)^2;
    d1=norm(p-(q1+v1*d));
    d2=norm(p-(q1+v2*e));
    d3=norm(p-(q2-v3*f));
    dist=min([d1,d2,d3]);
end

