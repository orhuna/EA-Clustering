function dist = point_distance(point,point_set)
% Set Accumulator for Distances to be Zero
accum_dist = zeros(size(point_set,1),1);
% Calculate Euclidean Distances in All Dimensions
for dim = 1 : size(point_set,2)
    accum_dist = accum_dist + (point(dim) - point_set(:,dim)).^2 ;
end
dist = sqrt(accum_dist) ;