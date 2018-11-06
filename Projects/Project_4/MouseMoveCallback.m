function MouseMoveCallback(h,e)
disp('im in move')
global r c midcontour path pathcnt donepath donepathcnt;
if ~midcontour
    disp('not midcontour, getting out of move')
    return;
end
a = get(gca,'CurrentPoint');
x = round(a(1,1));
y = round(a(1,2));
node = round([x;y]);
if ~((node(1)>=1)&&(node(2)>=1)&&(node(1)<=r)&&(node(2)<=c))
    disp('out of bound, getting out of move')
    return;
end
path(:,1) = node;
pathcnt = 1;
prev=GetPointer((node(2)-1)*r+node(1));
while prev~=0
    pathcnt = pathcnt+1;
    path(:,pathcnt) = [mod((prev-1),r), floor((prev-1)/r)]+1;
    prev=GetPointer(prev);
end
hold off
DisplayVolume();
title('LiveWire active');
hold on;
plot(path(1,1:pathcnt),path(2,1:pathcnt),'g');
plot(donepath(1,1:donepathcnt),donepath(2,1:donepathcnt),'r');
drawnow;
disp('getting out of move')
return;