function cap=EdgeFunc(p,q)
% returns capacity between two nodes
global Edges EdgeCaps Edge_Lens r c
np=min(p,q);
nq=max(p,q);
if nq>r*c
    if nq==r*c+1
        cap=EdgeCaps(np,5);
    end
    if nq==r*c+2
        cap=EdgeCaps(np,6);
    end
else
    cap=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq);
end