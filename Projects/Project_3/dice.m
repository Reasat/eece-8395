function dc=dice(data1,data2)
% calculate dice
tp=sum(sum(sum((data1 & data2))));
fp=sum(sum(sum((~data1 & data2))));
%tn=sum(sum(sum((~data1 & ~data2))));
fn=sum(sum(sum((data1 & ~data2))));
dc=2*tp/(2*tp+fp+fn);
end








