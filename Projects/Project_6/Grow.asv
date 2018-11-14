function P=Grow()
global Parent Tree Active EdgeCaps Edges Edge_Lens PLengths
P=[];
while FIFOLen
    p=FIFOPeek;
    if Active(p)==1
        if p<=length(Edge_Lens)
            neibs=[Edges(p,1:Edge_Lens(p)) length(Edge_Lens)+1 length(Edge_Lens)+2];
        else
            nodes=1:length(Edge_Lens);
            if p==length(Edge_Lens)+1
                neibs=nodes(EdgeCaps(1:length(Edge_Lens),end-1)>0);
            end
            if p==length(Edge_Lens)+2
                neibs=nodes(EdgeCaps(1:length(Edge_Lens),end)>0);
            end
        end
        for i = 1:length(neibs)
            q=neibs(i);
            cap=EdgeFunc(p,q);
            
            if cap>0
                % Add free nodes
                if Tree(q)==0 
                    Active(q)=1;
                    Tree(q)=Tree(p);
                    Parent(q)=p;
                    PLengths(q)=PLengths(q)+1;
                    FIFOInsert(q)
                end
                % Return path
                if Tree(q)~=0
                    if Tree(q)~=Tree(p)
                        P=TracePath(p,q);
                        return
                    end
                end
            end
            
        end
    end
    FIFOPop;
    Active(p)=0;
end