function pca=createshapemodel(d,w)

mn=mean(d,2);
V=d-mn;
T=V'*V/size(V,2);
[eig_vec,eig_val] = eig(T);
eig_val=sum(eig_val);
[~,ind] = sort(eig_val,'descend');

e=eig_val(ind(1:end-1));
eig_vec=eig_vec(:,ind(1:end-1));

U=[];
for i=1:size(eig_vec,2)
    U(:,i)=V*eig_vec(:,i);
    U(:,i)=U(:,i)/norm(U(:,i));
end
% wtw=(w'*w);

phi=(U'*(w'*w)*U)\(U'*(w'*w));
pca=struct;
pca.e=e;
pca.U=U';
pca.mn=mn;
pca.w=w;
pca.phi=phi;