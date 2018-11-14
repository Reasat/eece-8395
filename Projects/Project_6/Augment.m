function Augment(P)
global Parent Orphans Orphan_cnt Tree PLengths
% find bottleneck capacity
bot_cap=1e6;

for i_node=2:length(P)
    p=P(i_node-1);
    q=P(i_node);
    
    cap=EdgeFunc(p,q);
    
    if bot_cap>cap
        bot_cap=cap;
    end
end
%%    push flow
for i_node=2:length(P)
    p=P(i_node-1);
    q=P(i_node);
    
    cap_res=PushFlow(p,q,bot_cap);
    
    if cap_res==0
        if Tree(p)==1 && Tree(q)==1
            Parent(q)=0;
            PLengths(q)=0;
            Orphan_cnt=Orphan_cnt+1;
            Orphans(Orphan_cnt)=q;
        end
        if Tree(p)==2 && Tree(q)==2
            Parent(p)=0;
            PLengths(p)=0;
            Orphan_cnt=Orphan_cnt+1;
            Orphans(Orphan_cnt)=p;
        end
    end
end