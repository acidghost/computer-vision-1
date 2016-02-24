function pixelError = compareIm( im1, im2 )
% COMPAREIM Compare two pictures are same within a small epsilon value

[size_y, size_x, size_c] = size(im1);

eps = 1e-12;
error = zeros(size_y, size_x, size_c);

for y=1:size_y;
    for x=1:size_x;
        p1 = im1(y, x);
        p2 = im2(y, x);
        error(y,x) = abs(p1 - p2);
        %assert(p1 > p2 - eps && p1 < p2 + eps, '1D convolution results are not the same as 2D one!')
    end
end

pixelError = mean(error, 3);
end