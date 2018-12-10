% fits our asm to a shape vector
function x = fit(asm,d)

[r,c] = size(d);
nv = r/3;
[x2tox1,Ro,to] = registerpoints(reshape(asm.mn,[3,nv]),reshape(d,[3,nv]),asm.w');


b = asm.phi*[x2tox1(:)-asm.mn];
MD = sqrt(sum(b.*b./asm.e));
if (MD > 3)
    b = b*3/MD;
end

po = asm.mn + (b'*asm.U)';
Ii = inv([Ro,to;0 0 0 1]);
R = Ii(1:3,1:3);
t = Ii(1:3,4);
x = reshape(R*reshape(po,[3,nv]) + repmat(t,[1,nv]),[r,1]);
return;

