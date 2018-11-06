function KeyboardCallback(han,e)
global midcontour
if midcontour==1
    return;
end
h = guidata(han);
if (strcmp(e.Key,'uparrow'))
    h.slc=min(h.img.dim(h.direction),h.slc+1);
elseif (strcmp(e.Key,'downarrow'))
    h.slc=max(1,h.slc-1);
end
guidata(han,h);
DisplayVolume();
return;