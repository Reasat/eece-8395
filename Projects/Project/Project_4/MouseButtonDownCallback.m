function MouseButtonDownCallback(h,e)
disp('im in button')
global c r Done midcontour donepath donepathcnt path pathcnt Pointer done
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
    if norm(donepath(:,donepathcnt)-donepath(:,1))>2
        x = round(donepath(1,donepathcnt));
        y = round(donepath(2,donepathcnt));
        Done(:)=0;
        Pointer(:) = 0;
        GraphSearch(@EdgeFunc,@NodeMark,@IsNodeMarked,@SetPointer,@GetPointer,(y-1)*r+x,-1);
    else
        hold off;
        DisplayVolume();
        hold on;
        plot(donepath(1,1:donepathcnt),donepath(2,1:donepathcnt),'r');
        plot([donepath(1,donepathcnt),donepath(1,1)],[donepath(2,donepathcnt),donepath(2,1)],'r');
        drawnow;
        set(gcf,'WindowButtonMotionFcn','');
        set(gcf,'WindowButtonDownFcn','');
        midcontour=0;
        done=1;
    end
end
disp('getting out of button')
return;