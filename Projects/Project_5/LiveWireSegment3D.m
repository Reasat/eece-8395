function cntrs=LiveWireSegment3D()
global done3d
done3d=0;
hfig = gcf;
iptaddcallback(hfig,'KeyPressFcn',@LiveWire3DKeyPressCallback);
h = guidata(hfig);
h.lcntrs = zeros(1,h.img.dim(3));
h.cntrs = zeros(2,1000,h.img.dim(3));
guidata(hfig,h);
count=0;
while ~(done3d)
    count=count+1;
    disp([num2str(count) ' stuck in while loop livewiresegment3d'])
    pause(0.5);
end
h = guidata(hfig);
cntrs = h.cntrs;
disp('exiting LiveWireSegment3D')
return;