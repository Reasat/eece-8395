function cap_res=PushFlow(p,q,bot_cap)
% returns residual capacity between nodes after a max flow operation
global Edges EdgeCaps Edge_Lens

np=min(p,q);
nq=max(p,q);
if nq>length(Edge_Lens)
    if nq==length(Edge_Lens)+1
        EdgeCaps(np,end-1)=EdgeCaps(np,end-1)-bot_cap;
        cap_res=EdgeCaps(np,end-1);
    end
    if nq==length(Edge_Lens)+2
        EdgeCaps(np,end)=EdgeCaps(np,end)-bot_cap;
        cap_res=EdgeCaps(np,end);
    end
else
    EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq)=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq)-bot_cap;
    cap_res=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq);
end



