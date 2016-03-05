clear, close all


im_format = 'assets/person_toy/00000%03d.jpg';
nfirst = 1;
nim = 104;
% im_format = 'assets/pingpong/00%02d.jpeg';
% nfirst = 0;
% nim = 52;

im_indexes = nfirst+1:nim;

im_first = imread(sprintf(im_format, nfirst));
[nrows, ncols, nchan] = size(im_first);


kernel_length = 11;
sigma = 1;
window_size = 3;
threshold = 7;
[H, r, c] = harris_corners(sprintf(im_format, nfirst), kernel_length, sigma, window_size, threshold);


regions_size = 15;


u = r; v = c;
figure
for i = im_indexes
    impath1 = sprintf(im_format, i - 1);
    impath2 = sprintf(im_format, i);
    imrgb = imread(impath1);

    ksize = size(u, 1);
    [ u, v ] = rm_keypoints(round([u v]), regions_size, size(imrgb));
    fprintf('Removed %d keypoints (outside viewport)\n', ksize - size(u, 1));

    % use dv, du instead of du, dv
    [ dv, du ] = lucas_kanade( impath1, impath2, regions_size, 0, 0, [u v] );
    
    imagesc(imrgb), hold on
    plot(v, u, 'bo')
    quiver(v, u, dv, du, 1, 'r'), hold off
    drawnow, pause(.1)
    
    u = u + du;
    v = v + dv;
end
