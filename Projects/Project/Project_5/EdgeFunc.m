function [Edges,EdgeCost] = EdgeFunc(node)
global Edgs EdgCosts Edg_lens;
Edges = Edgs(node,1:Edg_lens(node));
EdgeCost = EdgCosts(node,1:Edg_lens(node));
return;