function MyKeyboardCallback3D(han,e)
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
colormap(gray(256))
hold on;
%axial
if inp.direction==1 %z
    axis([1, inp.img.dim(1),1, inp.img.dim(2)]);
    image((squeeze(inp.img.data(:,:,inp.slc))'));
    daspect([1/inp.img.voxsz(1) 1/inp.img.voxsz(2) 1]) % corrects the aspect ratio
    xlabel('x');
    ylabel('y');
    title(['Slice z = ',num2str(inp.slc)]);
end
%saggital
if inp.direction==2 %x
    axis([1, inp.img.dim(2),1, inp.img.dim(3)]);
    image((squeeze(inp.img.data(inp.slc,:,:))'));
    daspect([1/inp.img.voxsz(2) 1/inp.img.voxsz(3) 1]) % corrects the aspect ratio
    xlabel('y');
    ylabel('z');
    title(['Slice x = ',num2str(inp.slc)]);
end

if inp.direction==3 %y
    axis([1, inp.img.dim(1),1, inp.img.dim(3)]);
    image((squeeze(inp.img.data(:,inp.slc,:))'));
    daspect([1/inp.img.voxsz(1) 1/inp.img.voxsz(3) 1]) % corrects the aspect ratio
    xlabel('x');
    ylabel('z');
    title(['Slice y = ',num2str(inp.slc)]);
end
drawnow;
guidata(han,inp); % attaches the new datastructure to the figure
return;