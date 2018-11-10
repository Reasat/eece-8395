function totcap=CutCheck
global EdgeCaps Edges Edge_Lens Tree
totcap=0;
for i=1:length(Edge_Lens)
    for j=1:Edge_Lens(i)
        if Tree(Edges(i,j))~=Tree(i)
            p = min([i,Edges(i,j)]);
            q = max([i,Edges(i,j)]);
            for k=1:Edge_Lens(p)
                if Edges(p,k)==q
                    totcap = totcap + EdgeCaps(p,k);
                    break;
                end
            end
        end
    end
    if Tree(i)~=1
        totcap = totcap + EdgeCaps(i,end-1);
    end
    if Tree(i)~=2
        totcap = totcap + EdgeCaps(i,end);
    end
end