function P=Grow()
global Parent Tree Active EdgeCaps Edges Edge_Lens r c PLengths
P=[];
while FIFOLen
    p=FIFOPeek;
    if Active(p)==1
        %      Active(p)=0;
        if p<=r*c
            neibs=[Edges(p,1:Edge_Lens(p)) r*c+1 r*c+2];
        else
            neibs=1:r*c;
        end
        for i = 1:length(neibs)
            q=neibs(i);
            cap=EdgeFunc(p,q);
            
            if cap>0
                % Add free nodes
                if Tree(q)==0
%                     disp(['adding free node to FIFO ' num2str(q)])
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