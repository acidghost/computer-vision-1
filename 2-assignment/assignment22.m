% Main assignment 2.2 script

im_path = 'imgs/zebra.png';
sigma_x = 2;
sigma_y = 2;
kernel_length = 11; 

%% Apply 2D kernel to image
im_out2 = gaussianConv( im_path, sigma_x, sigma_y );

%% Apply 1D kernels to image

% Load image
im = im2double(imread(im_path));
size_c = size(im, 3);

% Create 1-dimensional kernels
kernel_x = gaussian(sigma_x, kernel_length)';
kernel_y = gaussian(sigma_y, kernel_length);

% Convolve first columns and then rows
im_out1 = zeros(size(im));
for i=1:size_c;
    im_out1(:,:,i) = conv2(kernel_y, kernel_x, im(:,:,i), 'same');
end

%% Compare the results of 1D convolution and 2D one
pixelError_col = compareIm(im_out1_col, im_out2);
equiv_col = mean(mean(pixelError_col));

pixelError = compareIm(im_out1, im_out2);
equiv = mean(mean(pixelError));

%% Plots and images

% Show original image
figure
subplot(1,3,1);
imshow(im, []);
title('Original');
sx_str = num2str(sigma_x); sy_str = num2str(sigma_y);
% Show image filtered with 2D kernel
subplot(1,3,2);
imshow(im_out2, []);
title(['2D filtered _{\sigma_x=', sx_str, ', \sigma_y=', sy_str, '}']);
% Show image filtered with 1D kernels
subplot(1,3,3);
imshow(im_out1, []);
title(['1D filtered _{\sigma_x=', sx_str, ', \sigma_y=', sy_str, '}']);

% % Heat map to visualize error per pixel in middle step of 1D
% e_c_str = num2str(equiv_col);
% title_v = ['1D first filter vs 2D filter. Average = ', e_c_str];
% hm_col = HeatMap(pixelError_col);
% addTitle(hm_col, title_v);
% % Heat map for final image
% e_str = num2str(equiv);
% title_v = ['1D final filter vs 2D filter. Average = ', e_str];
% hm = HeatMap(pixelError);
% addTitle(hm, title_v);
