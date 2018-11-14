function totcap = ActiveCheck
global EdgeCaps Edges Edge_Lens Tree Active 
totcap=0;
for i=1:length(Edge_Lens)
    if Tree(i)~=0 && Active(i)==0
        for j=1:Edge_Lens(i)
            if Tree(Edges(i,j))==0
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
    end
end
if sum(Tree(1:length(Edge_Lens))==0)>0
    if Active(length(Edge_Lens)+1)==0
        totcap = totcap + sum(EdgeCaps(Tree(1:length(Edge_Lens))==0,end-1));
    end
    if Active(length(Edge_Lens)+2)==0
        totcap = totcap + sum(EdgeCaps(Tree(1:length(Edge_Lens))==0,end));
    end
end