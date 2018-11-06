function coor=ind2coor(ind)
global r
coor=[fix(ind/r)+1, rem(ind,r)];
