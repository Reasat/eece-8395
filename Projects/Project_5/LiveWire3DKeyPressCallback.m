function LiveWire3DKeyPressCallback(h,e)
disp('entering LiveWire3DKeyPressCallback')
global done3d
if (strcmp(e.Key,'escape'))
    disp('segmentation escaped')
    done3d=1;
elseif strcmp(e.Key,'l')
    disp('entered segmentation mode')
    inp = guidata(h);
    costim = 50+repmat(min(abs(inp.img.data(:,:,inp.slc)-105),abs(inp.img.data(:,:,inp.slc)-193)),[1,1,8]);
    costim(:,:,5:8) = costim(:,:,5:8)*sqrt(2);
    LiveWireSegment(inp.img,costim,inp.direction,inp.slc);
end
return;