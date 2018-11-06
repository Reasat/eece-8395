clear all
close all
clc
% 2. For the entire dataset
% a. Compute the overall confusion matrix between the ground truth and each of the 3 raters
% b. Compute the overall foreground sensitivity and specificity of each of the 3 raters
%% Define filepaths
filepaths_gt=glob('..\..\Data\*\structures\mandible.nrrd');
filepaths_t1=glob('..\..\Data\*\structures\target2.nrrd');
filepaths_t2=glob('..\..\Data\*\structures\target2.nrrd');
filepaths_t3=glob('..\..\Data\*\structures\target2.nrrd');
n_sample=3;
%% Initialize variables to store data
volume_gts_vec=zeros(1,n_sample);
volume_t1s_vec=zeros(1,n_sample);
volume_t2s_vec=zeros(1,n_sample);
volume_t3s_vec=zeros(1,n_sample);

tp1_vec=zeros(1,n_sample); tn1_vec=zeros(1,n_sample);fp1_vec=zeros(1,n_sample);fn1_vec=zeros(1,n_sample);
tp2_vec=zeros(1,n_sample); tn2_vec=zeros(1,n_sample);fp2_vec=zeros(1,n_sample);fn2_vec=zeros(1,n_sample);
tp3_vec=zeros(1,n_sample); tn3_vec=zeros(1,n_sample);fp3_vec=zeros(1,n_sample);fn3_vec=zeros(1,n_sample);

dice_t1_vec=zeros(1,n_sample);
dice_t2_vec=zeros(1,n_sample);
dice_t3_vec=zeros(1,n_sample);
dice_mv_vec=zeros(1,n_sample);
hausdorff1_vec=zeros(1,n_sample);
hausdorff2_vec=zeros(1,n_sample);
hausdorff3_vec=zeros(1,n_sample);
hausdorffmv_vec=zeros(1,n_sample);
meandist1_vec=zeros(1,n_sample);
meandist2_vec=zeros(1,n_sample);
meandist3_vec=zeros(1,n_sample);
meandistmv_vec=zeros(1,n_sample);

for i= 1:n_sample
    gt = ReadNrrd(filepaths_gt{i});
    t1 = ReadNrrd(filepaths_t1{i});
    t2 = ReadNrrd(filepaths_t2{i});
    t3 = ReadNrrd(filepaths_t3{i});
    gts = isosurface(gt.data,0.5);
    gts.vertices = gts.vertices.*repmat(gt.voxsz,[length(gts.vertices),1]);
    t1s = isosurface(t1.data,0.5);
    t1s.vertices = t1s.vertices.*repmat(t1.voxsz,[length(t1s.vertices),1]);
    t2s = isosurface(t2.data,0.5);
    t2s.vertices = t2s.vertices.*repmat(t2.voxsz,[length(t2s.vertices),1]);
    t3s = isosurface(t3.data,0.5);
    t3s.vertices = t3s.vertices.*repmat(t3.voxsz,[length(t3s.vertices),1]);
    
    mv = t1;
    mv.data =double(t1.data + t2.data + t3.data > 1.5);
    mvs = isosurface(mv.data,0.5);
    mvs.vertices = mvs.vertices.*repmat(mv.voxsz,[length(mvs.vertices),1]);
    
    
    %% Calculate volume
    volume_gts=VolumeofMesh(gts);
    volume_t1s=VolumeofMesh(t1s);
    volume_t2s=VolumeofMesh(t2s);
    volume_t3s=VolumeofMesh(t3s);
    
    %% Calculate tp,tn,fp,fn 
    tp1,fp1,tn1,fn1=class_perf(gt.data,t1.data);
    tp2,fp2,tn2,fn2=class_perf(gt.data,t2.data);
    tp3,fp3,tn3,fn3=class_perf(gt.data,t3.data);
    
    %% Dice coefficient
    dice_t1=dice(t1.data,gt.data);
    dice_t2=dice(t2.data,gt.data);
    dice_t3=dice(t3.data,gt.data);
    dice_mv=dice(mv.data,gt.data);
    
    %% Mean symmetric absolute surface, and Hausdorff distance
    [mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t1s);
    meandist1=mean([mn1,mn2]);
    hausdorff1=max([mx1,mx2]);
    
    [mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t2s);
    meandist2=mean([mn1,mn2]);
    hausdorff2=max([mx1,mx2]);
    
    [mn1,mn2,mx1,mx2]=SurfaceDistance(gts,t3s);
    meandist3=mean([mn1,mn2]);
    hausdorff3=max([mx1,mx2]);
    
    [mn1,mn2,mx1,mx2]=SurfaceDistance(gts,mvs);
    meandistmv=mean([mn1,mn2]);
    hausdorffmv=max([mx1,mx2]);
    
    %% Store all data
    volume_gts_vec(i)=volume_gts;
    volume_t1s_vec(i)=volume_t1s;
    volume_t2s_vec(i)=volume_t2s;
    volume_t3s_vec(i)=volume_t3s;
    
    tp1_vec(i)=tp1; tn1_vec(i)=tn1;fp1_vec(i)=fp1;fn1_vec(i)=fn1;
    tp2_vec(i)=tp2; tn2_vec(i)=tn2;fp2_vec(i)=fp2;fn2_vec(i)=fn2;
    tp3_vec(i)=tp3; tn3_vec(i)=tn3;fp3_vec(i)=fp3;fn3_vec(i)=fn3;
    
    dice_t1_vec(i)=dice_t1;
    dice_t2_vec(i)=dice_t2;
    dice_t3_vec(i)=dice_t3;
    dice_mv_vec(i)=dice_mv;
    
    hausdorff1_vec(i)=hausdorff1;
    hausdorff2_vec(i)=hausdorff2;
    hausdorff3_vec(i)=hausdorff3;
    hausdorffmv_vec(i)=hausdorffmv;
    
    meandist1_vec(i)=meandist1;
    meandist2_vec(i)=meandist2;
    meandist3_vec(i)=meandist3;
    meandistmv_vec(i)=meandistmv;
end

%% 2a) Overall confusion matrix

tp1_all=sum(tp1_vec);
tn1_all=sum(tn1_vec);
fp1_all=sum(fp1_vec);
fn1_all=sum(fn1_vec);
T1=table([tp1_all; fn1_all],[fp1_all; tn1_all],...
'VariableNames',{'gt_negative','gt_positive'},...
'RowNames',{'t1_negative';'t1_positive'});

tp2_all=sum(tp2_vec);
tn2_all=sum(tn2_vec);
fp2_all=sum(fp2_vec);
fn2_all=sum(fn2_vec);
T2=table([tp2_all; fn2_all],[fp2_all; tn2_all],...
'VariableNames',{'gt_negative','gt_positive'},...
'RowNames',{'t2_negative';'t2_positive'});

tp3_all=sum(tp3_vec);
tn3_all=sum(tn3_vec);
fp3_all=sum(fp3_vec);
fn3_all=sum(fn3_vec);
T3=table([tp3_all; fn3_all],[fp3_all; tn3_all],...
'VariableNames',{'gt_negative','gt_positive'},...
'RowNames',{'t1_negative';'t1_positive'});

%% 2b) Sensitivity and Specificity

Se1=tp1_all/(tp1_all+fn1_all)
Sp1=tn1_all/(tn1_all+fp1_all)
Se2=tp2_all/(tp2_all+fn2_all)
Sp2=tn2_all/(tn2_all+fp2_all)
Se3=tp3_all/(tp3_all+fn3_all)
Sp3=tn3_all/(tn3_all+fp3_all)


%% 3c) Boxplot of overall results
%Volume
boxplot(volume_gts_vec)
boxplot(volume_t1s_vec)
boxplot(volume_t2s_vec)
boxplot(volume_t3s_vec)
%Dice
boxplot(dice_t1_vec)
boxplot(dice_t2_vec)
boxplot(dice_t3_vec)
boxplot(dice_mv_vec)
%Mean surface distance
boxplot(meandist1_vec)
boxplot(meandist2_vec)
boxplot(meandist3_vec)
boxplot(meandistmv_vec)
%Hausdorff distance
boxplot(hausdorff1_vec)
boxplot(hausdorff2_vec)
boxplot(hausdorff3_vec)
boxplot(hausdorffmv_vec)

%% 3d) Wilcoxon signed-rank test
[p_volume_1,h_volume_1] = signrank(volume_gts_vec,volume_t1s_vec);
[p_volume_2,h_volume_2] = signrank(volume_gts_vec,volume_t2s_vec);
[p_volume_3,h_volume_3] = signrank(volume_gts_vec,volume_t3s_vec);
[p_volume_12,h_volume_12] = signrank(volume_t1s_vec,volume_t2s_vec);
[p_volume_23,h_volume_23] = signrank(volume_t2s_vec,volume_t3s_vec);
[p_volume_13,h_volume_13] = signrank(volume_t1s_vec,volume_t3s_vec);

[p_dice_12,h_dice_12] = signrank(dice_t1_vec,dice_t2_vec);
[p_dice_23,h_dice_23] = signrank(dice_t2_vec,dice_t3_vec);
[p_dice_13,h_dice_13] = signrank(dice_t1_vec,dice_t3_vec);

[p_meandist_12,h_meandist_12] = signrank(meandist1_vec,meandist2_vec);
[p_meandist_23,h_meandist_23] = signrank(meandist2_vec,meandist3_vec);
[p_meandist_13,h_meandist_13] = signrank(meandist1_vec,meandist3_vec);

[p_hausdorff_12,h_hausdorff_12] = signrank(hausdorff1_vec,hausdorff2_vec);
[p_hausdorff_23,h_hausdorff_23] = signrank(hausdorff2_vec,hausdorff3_vec);
[p_hausdorff_13,h_hausdorff_13] = signrank(hausdorff1_vec,hausdorff3_vec);

T_wilk_volume=table([p_volume_1;p_volume_2;p_volume_3;p_volume_12;p_volume_23;p_volume_13],...
    [h_volume_1;h_volume_2;h_volume_3;h_volume_12;h_volume_23;h_volume_13],...
    'VariableNames',{'p_value','test_decision'},...
    'RowNames',{'gt and t1';'gt and t2';'gt and t3';'t1 and t2';'t2 and t3';'t1 and t3';});

T_wilk_dice=table([p_dice_12;p_dice_23;p_dice_13],...
    [h_dice_12;h_dice_23;h_dice_13],...
    'VariableNames',{'p_value','test_decision'},...
    'RowNames',{'t1 and t2';'t2 and t3';'t1 and t3';});

T_wilk_meandist=table([p_meandist_12;p_meandist_23;p_meandist_13],...
    [h_meandist_12;h_meandist_23;h_meandist_13],...
    'VariableNames',{'p_value','test_decision'},...
    'RowNames',{'t1 and t2';'t2 and t3';'t1 and t3';});

T_wilk_hausdorff=table([p_hausdorff_12;p_hausdorff_23;p_hausdorff_13],...
    [h_hausdorff_12;h_hausdorff_23;h_hausdorff_13],...
    'VariableNames',{'p_value','test_decision'},...
    'RowNames',{'t1 and t2';'t2 and t3';'t1 and t3';});
