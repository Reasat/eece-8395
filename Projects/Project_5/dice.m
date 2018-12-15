function dc=dice(data1,data2)
% calculate dice
data1=data1(:);
data2=data2(:);
tp=sum(data1 & data2);
fp=sum(~data1 & data2);
%tn=sum(sum(sum((~data1 & ~data2))));
fn=sum(data1 & ~data2);
dc=2*tp/(2*tp+fp+fn);
end








