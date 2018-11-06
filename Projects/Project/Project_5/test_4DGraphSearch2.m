function test_4DGraphSearch2
global r c d img rset searchbox Done Pointer mndef vardef;
im = ReadNrrd('0522c0001\img.nrrd');
crp = im;
crp.data = im.data(160:360,140:340,30:85);
img = crp.data;
crp.dim = size(crp.data);
crp.data = crp.data/10+100;
figure(1); close(1); figure(1); colormap(gray(256));
DisplayVolume(crp,1,102);
figure(2); close(2); figure(2); colormap(gray(256));
DisplayVolume(crp,2,100);
[r,c,d] = size(crp.data);

rset = [4.75 5.5 6.6 8.14 10.12];

seedxyz = [105,120,10];
seednode = (seedxyz(3)-1 + ((seedxyz(1)-1)*c + (seedxyz(2)-1))*d )*length(rset) + 1;
endxyz = [105,105,37];
for i=1:length(rset)
endnode(i) = (endxyz(3)-1 + ((endxyz(1)-1)*c + (endxyz(2)-1))*d)*length(rset) + i;
end

searchbox = [80,120, 80,140, 10,37];

Done = zeros(r*c*d*length(rset),1);
Pointer = zeros(r*c*d*length(rset),1);