function cap_res=push_flow3D(p,q,bot_cap)
% returns residual capacity between nodes after a max flow operation
global r c d Edges EdgeCaps Edge_Lens

np=min(p,q);
nq=max(p,q);
if nq>r*c*d
    if nq==r*c*d+1
        EdgeCaps(np,end-1)=EdgeCaps(np,end-1)-bot_cap;
        cap_res=EdgeCaps(np,end-1);
    end
    if nq==r*c*d+2
        EdgeCaps(np,end)=EdgeCaps(np,end)-bot_cap;
        cap_res=EdgeCaps(np,end);
    end
else
    EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq)=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq)-bot_cap;
    cap_res=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq);
end



