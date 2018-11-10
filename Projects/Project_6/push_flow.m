function cap_res=push_flow(p,q,bot_cap)
global r c Edges EdgeCaps Edge_Lens

np=min(p,q);
nq=max(p,q);
if nq>r*c
    if nq==r*c+1
        EdgeCaps(np,5)=EdgeCaps(np,5)-bot_cap;
        cap_res=EdgeCaps(np,5);
    end
    if nq==r*c+2
        EdgeCaps(np,6)=EdgeCaps(np,6)-bot_cap;
        cap_res=EdgeCaps(np,6);
    end
else
    EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq)=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq)-bot_cap;
    cap_res=EdgeCaps(np,Edges(np,1:Edge_Lens(np))==nq);
end



