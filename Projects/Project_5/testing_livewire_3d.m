% img = ReadNrrd('D:\Data\EECE_8395\0522c0001\img.nrrd');
dir_data='C:\Users\greas\Box\Vanderbilt_Vivobook_Windows\EECE_8395\EECE_395';
img = ReadNrrd([dir_data '\0522c0001\img.nrrd']);
slcim = img;
fp = [260,150,70];
sp = [320,220,107];
slcim.data = img.data(fp(1):sp(1),fp(2):sp(2),fp(3):sp(3))/2+100;
slcim.dim = size(slcim.data);
figure(1); close(1); hfig = figure(1); colormap(gray(256));

DisplayVolume(slcim,3,19);
% cntrs=LiveWireSegment3D();
% save 'cntrs.mat' cntrs
load('cntrs.mat')
cntr2vol = slcim;
cntr2vol.data(:)=0;
neibs = [-1 0;+1 0;0 -1; 0 +1];
slices=18:20;
for i_sl=1:length(slices)
    slcnum=slices(i_sl);
    tot = sum(cntrs(1,:, slcnum)~=0);
    for j=1:tot
        cntr2vol.data(cntrs(1,j, slcnum),cntrs(2,j, slcnum), slcnum)=1;
    end
    cntr2vol.data = cntr2vol.data*255;
    figure(1); close(1); hfig = figure(1); colormap(gray(256));
    DisplayVolume(cntr2vol,3,19);
    hold on;
    plot(cntrs(1,1:tot,slcnum),cntrs(2,1:tot,slcnum),'r')
    cntr2vol.data = cntr2vol.data/255;
    
    done = zeros(cntr2vol.dim(1),cntr2vol.dim(2));
    list1 = zeros(cntr2vol.dim(1)*cntr2vol.dim(2),2);
    list2 = zeros(cntr2vol.dim(1)*cntr2vol.dim(2),2);
    fillval=0;
    lenlist1=1;
    lenlist2=0;
    list1(1,:) = [1,1];
    done(1,1)=1;
    while (lenlist1)
        cur = list1(lenlist1,:);
        lenlist1 = lenlist1-1;
        for j=1:length(neibs)
            nd =cur + neibs(j,:);
            if nd(1)>0 && nd(2)>0 && nd(1)<=cntr2vol.dim(1) && nd(2)<=cntr2vol.dim(2) && ~done(nd(1),nd(2))
                if cntr2vol.data(nd(1),nd(2),slcnum) == 0
                    lenlist1 = lenlist1+1;
                    list1(lenlist1,:) = nd;
                else
                    lenlist2 = lenlist2+1;
                    list2(lenlist2,:) = nd;
                end
                done(nd(1),nd(2))=1;
            end
        end
    end
    figure(2); close(2); hfig = figure(2); colormap(gray(256));
    image(done'*255)
    
    while (lenlist1)
        while (lenlist1)
            cur = list1(lenlist1,:);
            lenlist1 = lenlist1-1;
            % this if statement fills in the foreground when we are in a
            % foreground fill iteration
            if cntr2vol.data(cur(1),cur(2),slcnum)==0 && fillval
                cntr2vol.data(cur(1),cur(2),slcnum)=1;
            end
            for j=1:length(neibs)
                nd =cur + neibs(j,:);
                % allows filling in the foreground on foreground fill iterations
                if nd(1)>0 && nd(2)>0 && nd(1)<=cntr2vol.dim(1) && nd(2)<=cntr2vol.dim(2) && ~done(nd(1),nd(2))
                    if cntr2vol.data(nd(1),nd(2),slcnum) == 0
                        lenlist1 = lenlist1+1;
                        list1(lenlist1,:) = nd;
                    else
                        lenlist2 = lenlist2+1;
                        list2(lenlist2,:) = nd;
                    end
                    done(nd(1),nd(2))=1;
                end
            end
            list1 = list2;
            lenlist1 = lenlist2;
            lenlist2 = 0;
            fillval = 1 - fillval;
        end
    end
end

cntr2vol.data = cntr2vol.data*255;
figure(1); close(1); hfig = figure(1); colormap(gray(256));
DisplayVolume(cntr2vol,3,19);
hold on;
plot(cntrs(1,1:tot,slcnum),cntrs(2,1:tot,slcnum),'r')

gt_optic_nerve=ReadNrrd([dir_data, '\0522c0001\structures\OpticNerve_L.nrrd']);
gt_optic_nerve.data= gt_optic_nerve.data(fp(1):sp(1),fp(2):sp(2),fp(3):sp(3));