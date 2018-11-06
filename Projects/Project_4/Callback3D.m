function Callback3D(han,e)
inp = guidata(han);% get the data structure
if (strcmp(e.Key,'uparrow'))
    if inp.direction==3
        inp.slc=min(inp.img.dim(3),inp.slc+1);
    end
    if inp.direction==1
        inp.slc=min(inp.img.dim(1),inp.slc+1);
    end
    if inp.direction==2
        inp.slc=min(inp.img.dim(2),inp.slc+1);
    end
elseif (strcmp(e.Key,'downarrow'))
    inp.slc=max(1,inp.slc-1);
end
DisplayImage(inp);
guidata(han,inp); % attaches the new datastructure to the figure
return;