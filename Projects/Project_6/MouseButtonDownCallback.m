function MouseButtonDownCallback(h,e)
a = get(h,'SelectionType');
if   ~strcmp(a,'normal')
    return;
end
a = get(gca,'CurrentPoint');
x = round(a(1,1));
y = round(a(1,2));
inp = guidata(h);
inp.pnts(end+1,:) = [x y inp.slc inp.rad];
guidata(h,inp);