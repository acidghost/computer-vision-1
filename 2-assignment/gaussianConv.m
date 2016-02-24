function im_out = gaussianConv( im_path, sigma_x, sigma_y )
%GAUSSIANCONV Convolute an image with a 2D Gaussian filter

kernel_length = 11;

% Load image
im = im2double(imread(im_path));
size_c = size(im, 3);

% Create 1-dimensional kernels
kernel_x = gaussian(sigma_x, kernel_length)';
kernel_y = gaussian(sigma_y, kernel_length);
% Create 2-dimensional kernel
kernel = kernel_x * kernel_y;

% Apply 2D kernel to image
im_out = zeros(size(im));
for i=1:size_c;
    im_out(:,:,i) = conv2(im(:,:,i), kernel, 'same');
end

end

