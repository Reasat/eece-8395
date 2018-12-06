function DisplayVolume(img,direction,slc)
if nargin<2
    direction=3;
end
if nargin<3 && nargin>0
    slc = floor(img.dim(direction)/2);
end
hfig = gcf;
if nargin>0
    clf;
    set(hfig,'KeyPressFcn','');
    

    inp.img = img;
    inp.slc = slc;
    inp.direction = direction;
    guidata(hfig,inp);
    iptaddcallback(hfig,'KeyPressFcn',@KeyboardCallback);
else
    inp = guidata(hfig);
    if ~isfield(inp,'img')
        return;
    end
end

if inp.direction==3
    image(inp.img.data(:,:,inp.slc)');
    daspect([inp.img.voxsz(2) inp.img.voxsz(1) 1]);
    xlabel('x');
    ylabel('y');
    z = 'z';
elseif inp.direction==2
    axis([1,inp.img.dim(1),1,inp.img.dim(3)]);
    hold on;
    image((squeeze(inp.img.data(:,inp.slc,:))'));
    daspect([inp.img.voxsz(3) inp.img.voxsz(1) 1]);
    xlabel('x');
    ylabel('z');
    z = 'y';
else
    axis([1,inp.img.dim(2),1,inp.img.dim(3)]);
    hold on;
    image((squeeze(inp.img.data(inp.slc,:,:))'));
    daspect([inp.img.voxsz(3) inp.img.voxsz(2) 1]);
    xlabel('y');
    ylabel('z');
    z = 'x';
end
title(['Slice ',z,' = ',num2str(inp.slc)]);

if isfield(inp,'cntrs')
    hold on
    j=1;
    c = inp.cntrs(:,:,inp.slc);
    while j<length(c) && c(2,j)>0
        len = c(2,j);            
        plot(c(1,j+1:j+len),c(2,j+1:j+len),'r');
        j = j+len+1;
    end        
end

if isfield(inp,'msh')
    hold on;
    for i=1:length(inp.msh)
        Tris = [inp.msh(i).vertices(inp.msh(i).faces(:,1),:), inp.msh(i).vertices(inp.msh(i).faces(:,2),:), inp.msh(i).vertices(inp.msh(i).faces(:,3),:)]./repmat(inp.img.voxsz,[length(inp.msh(i).faces),3]);
        C = [Tris(:,3)>inp.slc,Tris(:,6)>inp.slc,Tris(:,9)>inp.slc];
        s = sum(C');
        msk = s>0 & s<3;
        C = C(msk,:);
        Tris = Tris(msk,:);
        T1 = C(:,1)==C(:,2);
        T2 = C(:,1)==C(:,3);
        T3 = C(:,2)==C(:,3);
        cntr1x = T1.*(Tris(:,1).*abs(inp.slc-Tris(:,9)) + Tris(:,7).*abs(inp.slc-Tris(:,3)))./(1-T1+abs(Tris(:,9)-Tris(:,3))) + ...
                 T2.*(Tris(:,1).*abs(inp.slc-Tris(:,6)) + Tris(:,4).*abs(inp.slc-Tris(:,3)))./(1-T2+abs(Tris(:,6)-Tris(:,3))) + ...
                 T3.*(Tris(:,1).*abs(inp.slc-Tris(:,6)) + Tris(:,4).*abs(inp.slc-Tris(:,3)))./(1-T3+abs(Tris(:,6)-Tris(:,3)));
        cntr1y = T1.*(Tris(:,2).*abs(inp.slc-Tris(:,9)) + Tris(:,8).*abs(inp.slc-Tris(:,3)))./(1-T1+abs(Tris(:,9)-Tris(:,3))) + ...
                 T2.*(Tris(:,2).*abs(inp.slc-Tris(:,6)) + Tris(:,5).*abs(inp.slc-Tris(:,3)))./(1-T2+abs(Tris(:,6)-Tris(:,3))) + ...
                 T3.*(Tris(:,2).*abs(inp.slc-Tris(:,6)) + Tris(:,5).*abs(inp.slc-Tris(:,3)))./(1-T3+abs(Tris(:,6)-Tris(:,3)));
        cntr2x = T1.*(Tris(:,4).*abs(inp.slc-Tris(:,9)) + Tris(:,7).*abs(inp.slc-Tris(:,6)))./(1-T1+abs(Tris(:,6)-Tris(:,9))) + ...
                 T2.*(Tris(:,7).*abs(inp.slc-Tris(:,6)) + Tris(:,4).*abs(inp.slc-Tris(:,9)))./(1-T2+abs(Tris(:,6)-Tris(:,9))) + ...
                 T3.*(Tris(:,7).*abs(inp.slc-Tris(:,3)) + Tris(:,1).*abs(inp.slc-Tris(:,9)))./(1-T3+abs(Tris(:,3)-Tris(:,9)));
        cntr2y = T1.*(Tris(:,5).*abs(inp.slc-Tris(:,9)) + Tris(:,8).*abs(inp.slc-Tris(:,6)))./(1-T1+abs(Tris(:,6)-Tris(:,9))) + ...
                 T2.*(Tris(:,8).*abs(inp.slc-Tris(:,6)) + Tris(:,5).*abs(inp.slc-Tris(:,9)))./(1-T2+abs(Tris(:,6)-Tris(:,9))) + ...
                 T3.*(Tris(:,8).*abs(inp.slc-Tris(:,3)) + Tris(:,2).*abs(inp.slc-Tris(:,9)))./(1-T3+abs(Tris(:,3)-Tris(:,9)));

        for j=1:length(cntr1x)
            plot([cntr1y(j);cntr2y(j)],[cntr1x(j);cntr2x(j)],'Color',inp.msh(i).color)
        end
    end
end
        
    

if nargin>0
drawnow;
end
return;





function KeyboardCallback(han,e)
global midcontour
if midcontour==1
    return;
end
h = guidata(han);
if (strcmp(e.Key,'uparrow'))
    h.slc=min(h.img.dim(h.direction),h.slc+1);
    guidata(han,h);
    DisplayVolume();
elseif (strcmp(e.Key,'downarrow'))
    h.slc=max(1,h.slc-1);
    guidata(han,h);
    DisplayVolume();
end


return;

