function cap=EdgeFunc(p,q)
% returns capacity between two nodes
global Edges EdgeCaps Edge_Lens 
np=min(p,q);
nq=max(p,q);
if nq>length(Edge_Lens)
    if nq==length(Edge_Lens)+1
        cap=EdgeCaps(np,end-1);
    end
    if nq==length(Edge_Lens)+2
        cap=EdgeCaps(np,end);
    end
else
    cap=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq);
end