% registers a set of shape vectors to each other
function d = registerdataset(din,w)
[r,n] = size(din);
mno = zeros([3,r/3]);
if nargin<2
    w = ones(r/3,1);
end
errtol = 0.01;
d = reshape(din,[3,r/3,n]);
for k=1:1000
    if k==1
        for l=2:n
            d(:,:,l) = registerpoints(d(:,:,1),d(:,:,l),w');
        end
    else
        for l=1:n
            d(:,:,l) = registerpoints(mn,d(:,:,l),w');
        end
    end
    mn = mean(d,3);
    tol = sum(sum(abs(mn-mno)));
    if (tol<errtol)
        break;
    end
    mno=mn;
end
k
tol

d = reshape(d,[r,n]);

return;


