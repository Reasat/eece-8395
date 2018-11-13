function cap=EdgeFunc3D(p,q)
% returns capacity between two nodes
global Edges EdgeCaps Edge_Lens r c d
np=min(p,q);
nq=max(p,q);
if nq>r*c*d
    if nq==r*c*d+1
        cap=EdgeCaps(np,end-1);
    end
    if nq==r*c*d+2
        cap=EdgeCaps(np,end);
    end
else
    cap=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq);
end