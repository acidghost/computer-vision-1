function [ transformed_x, transformed_y ] = transform_points( x, y, params )
%TRANSFORM_POINTS Transform points in [x, y] using affine transformation
%                 with 'params' parameters


affine1 = [params(1) params(2);...
           params(3) params(4)];

affine2 = [params(5); params(6)];


npts = size(x, 2);
transformed_x = zeros(1, npts);
transformed_y = zeros(1, npts);
for i = 1:npts
    px = x(i);
    py = y(i);
    p = affine1 * [px; py] + affine2;
    transformed_x(1, i) = p(1);
    transformed_y(1, i) = p(2);
end

end
