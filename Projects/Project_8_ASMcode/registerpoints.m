

% finds R and t to minimize |R*x2+t-x1|^2
function [x2tox1,R,t] = registerpoints(x1,x2,w)
    if nargin<3
        w = ones(1,length(x1));
    end
    
    w = w/sum(w);
    
    x1m = x1*w';
    x2m = x2*w';

    C = (repmat(w,[3,1]).*[x1-repmat(x1m,[1,length(x1)])])*[x2-repmat(x2m,[1,length(x2)])]';
    [U,S,V] = svd(C);
    R = U*V';       
    t = x1m - R*x2m;
    x2tox1 = R*x2 + repmat(t,[1,length(x1)]);


return;
