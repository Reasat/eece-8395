

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
