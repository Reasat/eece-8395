function P=TracePath(p,q)
global Parent Edge_Lens
path1=p;
current_node=p;
while Parent(current_node)
    path1=[path1 Parent(current_node)];
    current_node=Parent(current_node);
end
path2=q;
current_node=q;
while Parent(current_node)
    path2=[path2 Parent(current_node)];
    current_node=Parent(current_node);
end
P=[path1(end:-1:1) path2];
if P(1)~=length(Edge_Lens)+1
    P=P(end:-1:1);
end