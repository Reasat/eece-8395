sigma = 1;
maxiter = 300;
mindist=2.1;
gamma=.35;
r=50; c=50; d=1;
slc = r*c;
img = zeros(r,c,d);
img(15:35,15:35) = 1;
img(21:25,10:20) = 0;
img(10:14,25:27) = 1;
figure(1); clf; colormap(gray(256));
image(255*img);
title('ground truth');
img = .5 - img;
g = fspecial('gaussian',[5,5],sigma);
imgblur = conv2(img,g,'same');

[Y,X,Z] = meshgrid(1:c,1:r,1:d);
% grad = Gradient(imgblur,1:r*c*d);
% ngrad = reshape(sum(grad.*grad),[r,c]);
[grad_x,grad_y] = gradient(imgblur);
ngrad = (grad_x.*grad_x+grad_y.*grad_y);
speed = exp(-ngrad/(.08));
figure(2); clf; colormap(gray(256));

% image(speed*1000);
image(speed*200);

title('speed');
dmap = ones(size(img));
dmap(20:30,24:32)=-1;
iter = 0;
nb = [];

while iter<maxiter
    iter = iter+1;
    figure(2);
    hold off
    image(speed*200);
    hold on;
    contour(dmap,[0,0],'r');
    title('speed');
    drawnow;
    
    [dmap,nbin,nbout] = FastMarch(dmap,mindist,1,nb);
    figure(3);
    hold off;
    image(dmap*10+127);
    hold on;
    contour(dmap,[0,0],'r');
    title(['distance map iter=',num2str(iter)])
    drawnow;
    nb.q = [nbin.q(:,1:nbin.len),nbout.q(:,1:nbout.len)];
    nb.len = nbin.len+nbout.len;
    
    [kappa,ngrad] = Curvature (dmap,nb);
    figure(4);
    curvature = zeros(size(dmap));
    curvature(nb.q(1,(nb.q(2,1:nb.len)<=1))) = kappa(nb.q(2,1:nb.len)<=1);
    image(curvature*500+127);
    title('curvature');
    drawnow;
    
    speedc = -speed(nb.q(1,1:nb.len)).*(ngrad).*(kappa+gamma);
    dt = 1/max(abs(speedc(:)));
    dmap(nb.q(1,1:nb.len)) = dmap(nb.q(1,1:nb.len)) + dt*speedc;
end

[dmap,nbin,nbout] = FastMarch(dmap,mindist,1,nb);
figure(2);
hold off
image(speed*1000);
title('speed');
hold on;
contour(dmap,[0,0],'r');
figure(1);
hold on;
contour(dmap,[0,0],'r');
title('distance map');
