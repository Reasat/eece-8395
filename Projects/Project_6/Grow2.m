function P=Grow2()
global Parent Tree Active EdgeCaps Edges Edge_Lens r c Orphans Orphan_cnt PLengths
P=[];
while FIFOlen
    p = FIFOPop;
    if Active(p)==1
        Active(p)=0;
        neibs=[Edges(p,:) r*c+1 r*c+2];
        %  check if left, right, down, up exists (necessary?)
        for i = 1:length(neibs)
            q=neibs(i);
            if q
                np=min(p,q);
                nq=max(p,q);
                if EdgeCaps(np,neibs==nq)>0
                    if Tree(q)==0
                        Active(q)=1;
                        Tree(q)=Tree(p);
                        Parent(q)=p;
                        PLengths(q)=PLengths(q)+1;
                        FIFOInsert(q)
                    end    
                    if Tree(q)~=0 
                        if Tree(q)~=Tree(p) 
                            path1=p;
                            current_node=path1;
                            while current_node~= r*c+1 && current_node~= r*c+2
                                path1=[path1 Parent(current_node)];
                                current_node=Parent(current_node);
                            end
                            path2=q;
                            current_node=path2;
                            while current_node~= r*c+1 && current_node~= r*c+2
                                path2=[path2 Parent(current_node)];
                                current_node=Parent(current_node);
                            end
                            P=[path1(end:-1:1) path2];
                            if P(1)~=r*c+1
                                P=P(end:-1:1);
                            end
                            return
                        end
                    end
                end
            end
        end
    end
    
end