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