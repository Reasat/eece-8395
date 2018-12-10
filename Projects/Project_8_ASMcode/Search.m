%perform the asm search
function shp = Search(shp,msh,pca,im,gt)
[trilist,trilistcnt] = VertexTriangleNeighbors(msh(1).m);

maxiter=50;
shp = shp';

alpha = 0.5;
maxtol = .01;
P = 12;
w = pca.w;
indx=find(w>0);
f = msh(1).m.faces;

for i=1:maxiter
    vnorms = findnorms(shp,f,indx, trilist, trilistcnt);
    
    %this vectorizes the image interpolation of all the intensity profiles
    %along all the normals
    ints = reshape(interp3(im.data,(repmat(shp(indx,1),[2*P+3,1]) + ...
        repmat(vnorms(indx,1)*alpha,[2*P+3,1]).*reshape(repmat([-P-1:P+1],[length(indx),1]),[(2*P+3)*length(indx),1]))/im.voxsz(1),...
        (repmat(shp(indx,2),[2*P+3,1]) + ...
        repmat(vnorms(indx,2)*alpha,[2*P+3,1]).*reshape(repmat([-P-1:P+1],[length(indx),1]),[(2*P+3)*length(indx),1]))/im.voxsz(2),...
        (repmat(shp(indx,3),[2*P+3,1]) + ...
        repmat(vnorms(indx,3)*alpha,[2*P+3,1]).*reshape(repmat([-P-1:P+1],[length(indx),1]),[(2*P+3)*length(indx),1]))/im.voxsz(3)),...
        [length(indx),2*P+3]);
    %gradient of intensity profiles
    grd = ints(:,3:end)-ints(:,1:end-2);
    % world's simplest search function: we want the most negative gradient
    % possible as the normals cross from bright bone to dark soft tissue at
    % the edge of the mandible
    [~,maxk] = min(grd');
    
    figure(3); clf;
    m.faces = f;
    m.vertices = shp;
    DisplayMesh(m);
    campos([-203.4072 -119.3906  779.8221])
    camtarget([208.3237  292.3403  97.5467])
    camup([ 0.5000    0.5000    0.7071])
    camva(10)
    hold on;
    %displays the normals we have found
    DisplayMesh(gt,[0,1,0],.5);
    for k=1:length(indx)
        plot3([shp(indx(k),1);shp(indx(k),1)+vnorms(indx(k),1)],[shp(indx(k),2);shp(indx(k),2)+vnorms(indx(k),2)],[shp(indx(k),3);shp(indx(k),3)+vnorms(indx(k),3)],'k')
    end
    drawnow
    cand=shp;
    %candidates are the points that result from the line searches
    cand(indx,:) = shp(indx,:) + vnorms(indx,:).*alpha.*repmat(maxk'-P-1,[1,3]);
    % here we fit the weighted ASM model to the candidates
    nshp = reshape(fit(pca,reshape(cand',[3*length(shp),1])),[3,length(shp)])';
    
    %convergence criteria
    tol = mean(abs(nshp(:)-shp(:)))
    shp = nshp;
    if tol < maxtol
        break;
    end
    
end




