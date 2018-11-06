function DisplayImage(inp)
colormap(gray(256))
%axial
if inp.direction==3 %z
    image((inp.img.data(:,:,inp.slc)'));
    daspect([1/inp.img.voxsz(1) 1/inp.img.voxsz(2) 1]) % corrects the aspect ratio
    xlabel('x');
    ylabel('y');
    title(['Slice z = ',num2str(inp.slc)]);
end
%saggital
if inp.direction==1 %x
    axis([1, inp.img.dim(2),1, inp.img.dim(3)]);
    hold on
    image((squeeze(inp.img.data(inp.slc,:,:))'));
    daspect([1/inp.img.voxsz(2) 1/inp.img.voxsz(3) 1]) % corrects the aspect ratio
    xlabel('y');
    ylabel('z');
    title(['Slice x = ',num2str(inp.slc)]);
end

if inp.direction==2 %y
    axis([1, inp.img.dim(1),1, inp.img.dim(3)]);
    hold on
    image((squeeze(inp.img.data(:,inp.slc,:))'));
    daspect([1/inp.img.voxsz(1) 1/inp.img.voxsz(3) 1]) % corrects the aspect ratio
    xlabel('x');
    ylabel('z');
    title(['Slice y = ',num2str(inp.slc)]);
end
drawnow;
end

