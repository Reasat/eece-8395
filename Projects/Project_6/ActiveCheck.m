function totcap = ActiveCheck
global EdgeCaps Edges Edge_Lens Tree Active r c
totcap=0;
for i=1:r*c
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
if sum(Tree(1:r*c)==0)>0
    if Active(r*c+1)==0
        totcap = totcap + sum(EdgeCaps(Tree(1:r*c)==0,end-1));
    end
    if Active(r*c+2)==0
        totcap = totcap + sum(EdgeCaps(Tree(1:r*c)==0,end));
    end
end