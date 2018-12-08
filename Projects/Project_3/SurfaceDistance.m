
function [mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t1s)
% calculates mean surface distance
show_eta=1;
points=gts.vertices;
dist_gt2t1_min=1000*ones(1,length(points));
tic
for i=1:length(t1s.faces)
    dist=Points2TriangleDistance(t1s.vertices,t1s.faces(i,:),points);
    elapsed=toc;
    dist_gt2t1_min(dist_gt2t1_min>dist)=dist(dist_gt2t1_min>dist);
    if show_eta
        if mod(i,500)==0
            disp(['forward pass eta: ',num2str(elapsed/i*(length(t1s.faces)-i)/60) ' minutes'])
        end
    end
end

points=t1s.vertices;
dist_t12gt_min=1000*ones(1,length(points));
tic
for i=1:length(gts.faces)
    dist=Points2TriangleDistance(gts.vertices,gts.faces(i,:),points);
    elapsed=toc;
    dist_t12gt_min(dist_t12gt_min>dist)=dist(dist_t12gt_min>dist);
    if show_eta
        if mod(i,500)==0
            disp(['backward pass eta: ',num2str(elapsed/i*(length(gts.faces)-i)/60) ' minutes'])
        end
    end
end
mn1=mean(dist_gt2t1_min);
mn2=mean(dist_t12gt_min);
mx1=max(dist_gt2t1_min);
mx2=max(dist_t12gt_min);
end
