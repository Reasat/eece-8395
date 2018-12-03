function [f] = EnforceMirrorBoundary(f)
    % This function enforces the mirror boundary conditions
    % on the 3D input image f. The values of all voxels at 
    % the boundary is set to the values of the voxels 2 steps 
    % inward
    [N M ] = size(f);
 
    xi = 2:M-1;
    yi = 2:N-1;
 
    % Coners
    f([1 N], [1 M]) = f([3 N-2], [3 M-2]);
 
    % Edges
    f([1 N], [1 M]) = f([3 N-2], [3 M-2]);
    f(yi, [1 M]) = f(yi, [3 M-2]);
    f([1 N], xi) = f([3 N-2], xi); 
end