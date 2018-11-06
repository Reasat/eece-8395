function P=Grow()
global Parent Tree Active EdgeCaps Edges Edge_Lens r c Orphans Orphan_cnt PLengths
P=[];
p = FIFOPop;
if Active(p)==1
    neibs=[Edges(p) r*c+1 r*c+2];
    %         check if left, right, down, up exists (necessary?)
    for i = 1:length(neibs)
        if neibs(i) && Tree(neibs(i))==0
            if EdgeCaps(p,i)>0
                FIFOInsert(neibs(i))
                Active(neibs(i))=1;
                Tree(neibs(i))=Tree(p);
                Parent(neibs(i))=p;
            end
        end
        if neibs(i) && Tree(neibs(i)) && Tree(neibs(i))~=Tree(p)
            path1=p;
            current_node=path1;
            while current_node~= r*c+1 && current_node~= r*c+2
                path1=[path1 Parent(current_node)];
                current_node=Parent(current_node);
            end
            path2=neibs(i);
            current_node=path2;
            while current_node~= r*c+1 && current_node~= r*c+2
                path2=[path2 Parent(current_node)];
                current_node=Parent(current_node);
            end
            if path1(end)==r*c+1 % path to source
                P=[path1(end:-1:1) path2];
            else
                P=[path2(end:-1:1) path1];
            end
            
        end
    end
end