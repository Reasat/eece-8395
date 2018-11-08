function Augment(P)

global EdgeCaps Edges  r c
% find bottleneck capacity
bot_cap=1e6;
for i_node=2:length(P)
    p=P(i_node-1);
    q=P(i_node);
    % The edges are undirected according to class note.
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
        neibs=Edges(np,:);
        pos=find(neibs==nq,1); % dubious condition, stems from the fact that Edges have dubious duplicate neibs
        cap=EdgeCaps(np,pos);
    end
    if bot_cap>cap
        bot_cap=cap;
    end
end
%%    push flow
for i_node=2:length(P)
    p=P(i_node-1);
    q=P(i_node);
    % The edges are undirected according to class note.
    np=min(p,q);
    nq=max(p,q);
    max_flow(np,nq,bot_cap);
    
    %Adoption();
    
end