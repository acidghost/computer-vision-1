clear, close all


% im_format = 'assets/person_toy/00000%03d.jpg';
% nfirst = 1;
% nim = 104;
im_format = 'assets/pingpong/00%02d.jpeg';
nfirst = 0;
nim = 52;

im_indexes = nfirst+1:nim;

im_first = imread(sprintf(im_format, nfirst));
[nrows, ncols, nchan] = size(im_first);


% Detect corner features using Harris corner detector
kernel_length = 11;
sigma = 1.5;
window_size = 11;
threshold = 10;
[H, r, c] = harris_corners(sprintf(im_format, nfirst), kernel_length, sigma, window_size, threshold);


regions_size = 15;


u = r; v = c;
figure
% For each pair of consecutive frames, compute displacement vectors
% of keypoints to track using Lucas-Kanade optical flow estimation
for i = im_indexes
    impath1 = sprintf(im_format, i - 1);
    impath2 = sprintf(im_format, i);
    im1 = imread(impath1);
    im2 = imread(impath2);

    ksize = size(u, 1);
    % Remove keypoints for which the region falls outside the image boundaries
    [ u, v ] = rm_keypoints([u v], regions_size, size(im1));
    fprintf('Removed %d keypoints (outside viewport)\n', ksize - size(u, 1));

    % Apply LK. Need to round points to pixel location
    [ du, dv ] = lucas_kanade(im1, im2, regions_size, 0, 0, round([u v]));
    
    imagesc(im1), hold on
    plot(v, u, 'bo')
    quiver(v, u, dv, du, 1, 'r'), hold off
    drawnow, pause(.3)
    
    % Add motion vector components to tracked features
    u = u + du;
    v = v + dv;
end
