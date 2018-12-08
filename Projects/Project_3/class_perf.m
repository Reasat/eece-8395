function [tp,fp,tn,fn]=class_perf(data1,data2)
% calculates tp, fp, tn, fn from ground truth and target
tp=sum(sum(sum((data1 & data2))));
fp=sum(sum(sum((~data1 & data2))));
tn=sum(sum(sum((~data1 & ~data2))));
fn=sum(sum(sum((data1 & ~data2))));
end
