function [ transformed_x, transformed_y ] = transform_points( x, y, params, invert )
%TRANSFORM_POINTS Transform points in [x, y] using affine transformation
%                 with 'params' parameters


if ~exist('invert', 'var')
    invert = 0;
end

npts = size(x, 2);
transformed_x = zeros(1, npts);
transformed_y = zeros(1, npts);
for i = 1:npts
    p = transform_point(x(i), y(i), params, invert);
    transformed_x(1, i) = p(1);
    transformed_y(1, i) = p(2);
end


end

