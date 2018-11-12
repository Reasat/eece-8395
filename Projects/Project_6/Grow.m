
function P=Grow()
global Parent Tree Active EdgeCaps Edges Edge_Lens r c PLengths
P=[];
while FIFOLen
    p=FIFOPeek;
    if Active(p)==1
        %      Active(p)=0;
        neibs=[r*c+1 r*c+2 Edges(p,1:Edge_Lens(p))];
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
                    %                     PLengths(q)=PLengths(q)+1;
                    FIFOInsert(q)
                end
                % Return path
                if Tree(q)~=0
                    if Tree(q)~=Tree(p)
                        path1=p;
                        current_node=p;
                        while Parent(current_node)
                            path1=[path1 Parent(current_node)];
                            current_node=Parent(current_node);
                        end
                        path2=q;
                        current_node=q;
                        while Parent(current_node)
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
    FIFOPop;
    Active(p)=0;
end