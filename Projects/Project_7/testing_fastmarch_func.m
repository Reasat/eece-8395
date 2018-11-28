r=25;
c=25;
d=1;
img = zeros(r,c,d);
rad = 4;
for i=1:r
    for j=1:c
        for k=1:d
            img(i,j,k) = sqrt((i-r/2)*(i-r/2) +(j-c/2)*(j-c/2) +(k-d/2)*(k-d/2))- rad;
        end
    end
end
figure(1);clf; colormap(gray(256));
image(20*(img(:,:,ceil(d/2))+rad));
hold on;
contour(img(:,:,ceil(d/2)),[0,0],'r');

dmap = FastMarch(img,200,0,[]);
mean(abs(dmap(:)-img(:)))
max(abs(dmap(:)-img(:)))

figure(3); clf;
colormap(gray(256));
image((dmap(:,:,ceil(d/2))+rad)*20)
hold on;
contour(dmap(:,:,ceil(d/2)),[0,0],'r');

figure(4); clf;
colormap(gray(256));
image(abs(dmap-img)*500)
