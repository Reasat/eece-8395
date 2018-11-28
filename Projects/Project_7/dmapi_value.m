function dist=dmapi_value(node)
global dmapi
dist=[];
for i=1:length(node)
    [y,x]=ind2sub_custom(node(i));
    dist=[dist dmapi(x,y)];
end