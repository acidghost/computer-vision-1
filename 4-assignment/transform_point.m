function p = transform_point(px, py, affine1, affine2)

p = affine1 * [px; py] + affine2;

end

