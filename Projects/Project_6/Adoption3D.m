function Adoption3D
global Parent Tree Active EdgeCaps Edges Edge_Lens r c d Orphans Orphan_cnt PLengths
while Orphan_cnt
    p=Orphans(Orphan_cnt);
    Orphan_cnt=Orphan_cnt-1;
    neibs=[Edges(p,1:Edge_Lens(p)) r*c*d+1 r*c*d+2];
    for i=1:length(neibs)
        % modify Plengths
        q=neibs(i);
        
        % check if path to tree exists
        current_node=q;
        while Parent(current_node)~=0
            current_node=Parent(current_node);
        end
        if current_node>r*c*d
            path2tree=1;
        else
            path2tree=0;
        end
        % get capacity

        cap=EdgeFunc3D(p,q);
        
        if Tree(p)==Tree(q) && cap>0 && path2tree
            Parent(p)=q;
            break
            % Active() state of p remains unchanged
        end
        
    end
    if Parent(p)==0 % no valid neighbours
        neibs=[Edges(p,1:Edge_Lens(p)) r*c*d+1 r*c*d+2];
        for i=1:length(neibs)
            q=neibs(i);
%             if Tree(p)==Tree(q)
                if Parent(q)==p 
                    Orphan_cnt=Orphan_cnt+1;
                    Orphans(Orphan_cnt)=q;
                    Parent(q)=0;
                end
                
                if EdgeFunc3D(p,q)>0  && Tree(q)~=0 && ~Active(q) %%check capacity so they are active in grow
                    FIFOInsert(q)
                    Active(q)=1;
                end
%             end
            
        end
        Tree(p)=0;
        Active(p)=0;
        Parent(p)=0;
    end
end
