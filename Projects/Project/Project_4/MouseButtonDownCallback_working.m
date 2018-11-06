function MouseButtonDownCallback_working(h,e)
disp('im in button')
global c r Done midcontour donepath donepathcnt path pathcnt Pointer
a = get(h,'SelectionType');
if ~strcmp(a,'normal')
    return;
end
if midcontour==0
    a = get(gca,'CurrentPoint');
    x = round(a(1,1));
    y = round(a(1,2));
    if ((x>=1)&&(y>=1)&&(x<=r)&&(y<=c))
        Done(:)=0;
        Pointer(:) = 0;
        donepathcnt = 1;
        donepath(:,donepathcnt) = [x;y];
        GraphSearch(@EdgeFunc,@NodeMark,@IsNodeMarked,@SetPointer,@GetPointer,x+(y-1)*r,-1);
        midcontour=1;
    end
else
    donepath(:,donepathcnt+1:donepathcnt+pathcnt-1) = path(:,pathcnt-1:-1:1);
    donepathcnt = donepathcnt + pathcnt-1;
    x = round(donepath(1,donepathcnt));
    y = round(donepath(2,donepathcnt));
    Done(:)=0;
    Pointer(:) = 0;
    GraphSearch(@EdgeFunc,@NodeMark,@IsNodeMarked,@SetPointer,@GetPointer,(y-1)*r+x,-1);
end
return;