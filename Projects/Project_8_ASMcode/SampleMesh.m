function msk = SampleMesh(M,rate)

% graph traversal
notvisited = 2;
foreground = 1;
background = 0;

[numEdges,Edges] = VertexNeighbors(M);

% Traverse graph
% Iteratively mark a node as foreground then all of its 'rate'-connected
% neighbors as background.

%initialzing data structures
msk = zeros(length(M.Vertices),1);
msk(:) = notvisited;
localmsk = zeros(length(M.Vertices),1);
list1 = zeros(length(M.Vertices),1);
list2 = zeros(length(M.Vertices),1);

% for loop is only necessary for graphs with disconnected components as the
% following while loop will fully traverse a connected graph using a
% breadth-first traversal
for i=1:length(M.Vertices)
    if msk(i)==notvisited
        curnode = i;
        msk(curnode) = foreground;

        % perform breadth-first traversal
        while (curnode>0)
            % marking all neighbors within 'rate' jumps of
            % list1(lenlist1) as background
            % localmsk keeps track of which local neighbors have already
            % been traversed
            localmsk(:)=0;
            localmsk(curnode)=1;
            lenlist1=1;            
            list1(1)=curnode;
            lenlist2=0;
            for j=1:rate-1      
                %pushing all neighbors of all nodes in list1 into list2
                %and marking them as background
                while (lenlist1>0)                    
                    for k=1:numEdges(list1(lenlist1))
                        if localmsk(Edges(list1(lenlist1),k))==0
                            msk(Edges(list1(lenlist1),k)) = background;
                            localmsk(Edges(list1(lenlist1),k))=1;
                            lenlist2 = lenlist2+1;
                            list2(lenlist2) = Edges(list1(lenlist1),k);
                        end
                    end
                    lenlist1 = lenlist1-1;
                end
                list1 = list2;
                lenlist1 = lenlist2;
                lenlist2=0;
            end
            %finding one next level 'notvisited' neighbor to mark as
            %foreground and then break the while loop
            curnode=0;
            while lenlist1>0
                for k=1:numEdges(list1(lenlist1))
                    if msk(Edges(list1(lenlist1),k))==notvisited
                        curnode = Edges(list1(lenlist1),k);
                        msk(curnode) = foreground;
                        break;
                    end
                end
                if curnode>0
                    break;
                end
                lenlist1 = lenlist1-1;
            end
        end
    end
end
msk = logical(msk);
                
return;