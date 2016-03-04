
clear, close all


% im_format = 'assets/person_toy/000000%02d.jpg';
% nfirst = 1;
% nim = 104;
im_format = 'assets/pingpong/00%02d.jpeg';
nfirst = 0;
nim = 52;
im_indexes = nfirst+1:nim;

im_first = imread(sprintf(im_format, nfirst));
[nrows, ncols, nchan] = size(im_first);

ims_rgb = zeros(nrows, ncols, nchan, length(im_indexes) + 1);
ims = zeros(nrows, ncols, length(im_indexes) + 1);
ims_rgb(:, :, :, 1) = im_first(:, :, :);
ims(:, :, 1) = im2double(rgb2gray(im_first));

for i = im_indexes
    impath = sprintf(im_format, i);
    im = imread(impath);
    ims_rgb(:, :, :, i+1) = im(:, :, :);
    ims(:, :, i+1) = im2double(rgb2gray(im));
end


kernel_length = 11;
sigma = 1;
window_size = 3;
threshold = 7;
[H, r, c] = harris_corners(sprintf(im_format, nfirst), kernel_length, sigma, window_size, threshold);


regions_size = 5;
half_region = floor(regions_size / 2);


u = r; v = c;
figure
for i = im_indexes
    j = i - 1;
    impath1 = sprintf(im_format, j);
    impath2 = sprintf(im_format, j + 1);

    [ u, v ] = rm_keypoints(floor([u v]), half_region, size(im_first));

    [ du, dv ] = lucas_kanade( impath1, impath2, regions_size, 0, 0, [u v] );
    
    imagesc(ims(:, :, i)), colormap gray, hold on
    plot(u, v, 'bo')
    quiver(u, v, du, dv, 1, 'r'), hold off
    drawnow, pause(.5)
    
    u = u + du;
    v = v + dv;
end
