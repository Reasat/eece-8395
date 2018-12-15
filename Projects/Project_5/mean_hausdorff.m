function [meandist, hausdorff]=mean_hausdorff(label1,label2)
[mn1,mn2,mx1,mx2]=SurfaceDistance(label1,label2);
meandist=mean([mn1,mn2]);
hausdorff=max([mx1,mx2]);
end