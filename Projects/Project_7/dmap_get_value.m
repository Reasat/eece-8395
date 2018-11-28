function dist=dmap_get_value(node)
global dmap
dist=[];
for i=1:length(node)
    [y,x]=ind2sub_custom(node(i));
    dist=[dist dmap(x,y)];
end
