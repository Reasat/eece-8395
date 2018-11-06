function DisplayVolume(img, direction, slc)
% direction
% 1-> axial
% 2-> saggital
% 3-> coronal
if nargin<2
    direction=3; % coronal 
    slc=round(img.dim(2)/2); % y
end
if nargin<3
    if direction==3 %axial
        slc=round(img.dim(3)/2); % z
    end
    if direction==1 %saggital
        slc=round(img.dim(1)/2); % x
    end
    if direction==2 %coronal
        slc=round(img.dim(2)/2); % y
    end
end

inp.img = img;
inp.slc = slc;
inp.direction=direction;
hfig = figure(1);clf

DisplayImage(inp);

guidata(hfig,inp);%guidata(object_handle,data) stores the variable data with 
                  %the object specified by object_handle.
hfig = gcf;
set(hfig,'KeyPressFcn','');
% iptaddcallback(hfig,'KeyPressFcn',@MyKeyboardCallback3D);
iptaddcallback(hfig,'KeyPressFcn',@Callback3D);
%ID = iptaddcallback(obj,callback,func_handle) adds the function handle 
%func_handle to the list of functions to be called when the callback 
%specified by callback executes. callback specifies the name of a callback 
%property of the graphics object specified.