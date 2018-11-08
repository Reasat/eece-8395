function max_flow(np,nq,bot_cap)
global r c Edges EdgeCaps Parent Orphans Orphan_cnt Tree
if nq>r*c
    if nq==r*c+1
        EdgeCaps(np,5)=EdgeCaps(np,5)-bot_cap;
        capacity=EdgeCaps(np,5);
    end
    if nq==r*c+2
        EdgeCaps(np,6)=EdgeCaps(np,6)-bot_cap;
        capacity=EdgeCaps(np,6);
    end
else
    neibs=Edges(np,:);
    pos=find(neibs==nq,1); % Edges have dubious duplicate neibs, fix it
    EdgeCaps(np,pos)=EdgeCaps(np,pos)-bot_cap;
    capacity=EdgeCaps(np,pos);
end

if capacity==0
    if Tree(np)==1 && Tree(nq)==1
        if Parent(nq) % update only if the node is not s or t (necessary?)
            Parent(nq)=-1;
            Orphan_cnt=Orphan_cnt+1;
            Orphans(Orphan_cnt)=nq;
            disp(['orphan ' num2str(nq)])
        end
    end
    if Tree(np)==2 && Tree(nq)==2
        if Parent(np)
            Parent(np)=-1;
            Orphan_cnt=Orphan_cnt+1;
            Orphans(Orphan_cnt)=np;
            disp(['orphan ' num2str(np)])
        end
    end
%     if Tree(np)~=Tree(nq)
%         if Parent(np)
%             Parent(np)=-1;
%             Orphan_cnt=Orphan_cnt+1;
%             Orphans(Orphan_cnt)=np;
%         end
%     end
end

