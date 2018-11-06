function LiveWire3DKeyPressCallback(h,e)
disp('entering LiveWire3DKeyPressCallback')
global done3d
if (strcmp(e.Key,'escape'))
    disp('segmentation escaped')
    done3d=1;
elseif strcmp(e.Key,'l')
    disp('segmentation mode')
    inp = guidata(h);
    LiveWireSegment(inp.img,[],inp.direction,inp.slc);
end
return;