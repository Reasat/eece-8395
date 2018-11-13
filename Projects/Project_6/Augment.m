function Augment(P)
global EdgeCaps Edges Edge_Lens r c  Parent Orphans Orphan_cnt Tree PLengths
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
        %         disp(['zero capacity edge found: ' num2str(p) ' ' num2str(q)])
        if Tree(p)==1 && Tree(q)==1
            if q<=r*c % update only if the child node is not s or t (necessary?)
                Parent(q)=0;
                PLengths(q)=0;
                Orphan_cnt=Orphan_cnt+1;
                Orphans(Orphan_cnt)=q;
%                 disp(['orphan ' num2str(q)])
            end
        end
        if Tree(p)==2 && Tree(q)==2
            if p<=r*c
                Parent(p)=0;
                PLengths(p)=0;
                Orphan_cnt=Orphan_cnt+1;
                Orphans(Orphan_cnt)=p;
%                 disp(['orphan ' num2str(p)])
            end
        end
    end
end