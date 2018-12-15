function DisplayMesh(M, color, opacity)
if nargin<2
    color=[1,0,0];
    opacity=1;
end
if nargin<3
    opacity=1;
end
figure
p=patch(M);
set(p,'FaceColor',color,'EdgeColor','none', 'FaceAlpha', opacity);
axis vis3d;
daspect([1,1,1])
if isempty(findobj(gcf, 'Type','Light'))
    camlight headlight;
end