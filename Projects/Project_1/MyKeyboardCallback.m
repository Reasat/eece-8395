function MyKeyboardCallback(han,e)
inp = guidata(han);% get the data structure
if (strcmp(e.Key,'uparrow'))
 inp.slc=min(inp.img.dim(2),inp.slc+1);
elseif (strcmp(e.Key,'downarrow'))
 inp.slc=max(1,inp.slc-1);
end
axis([1, inp.img.dim(1),1, inp.img.dim(3)]);
hold on;
colormap(gray(256))
image((squeeze(inp.img.data(:,inp.slc,:))'));
daspect([1/inp.img.voxsz(1) 1/inp.img.voxsz(3) 1]) % corrects the aspect ratio
xlabel('x');
ylabel('z');
title(['Slice y = ',num2str(inp.slc)]);
drawnow;
guidata(han,inp); % attaches the new datastructure to the figure
return;