function O=ConnectedComponent(M,Edges)
path_traversed=bfs(M,Edges);
O=struct;
for i=1:length(path_traversed)
    key=zeros(1,length(M.vertices));
    key(path_traversed{i})=1:length(path_traversed{i});
    [mask,~]=ismember(M.faces, path_traversed{i});
    surface_arrays=M.faces(sum(mask,2)==3,:);
    nt=key(M.faces);
    
    O(i).faces=nt(nt(:,1)~=0,:);
    O(i).vertices=M.vertices(path_traversed{i},:);
end

