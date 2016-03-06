clear, close all


regions_size = 15;
quiver_scale = 10;
show_loops = 5;

impath1 = 'assets/sphere1.ppm';
impath2 = 'assets/sphere2.ppm';

% impath1 = 'assets/synth1.pgm';
% impath2 = 'assets/synth2.pgm';

% impath1 = 'assets/pingpong/0000.jpeg';
% impath2 = 'assets/pingpong/0001.jpeg';

% impath1 = 'assets/person_toy/00000001.jpg';
% impath2 = 'assets/person_toy/00000002.jpg';

im1 = imread(impath1);
im2 = imread(impath2);
[u, v] = lucas_kanade(im1, im2, regions_size, show_loops, quiver_scale);

% Plot frames side by side
figure
subplot 121, imagesc(im1), hold on
quiver(u, v, quiver_scale)
title('First frame'), hold off
subplot 122, imagesc(im2), hold on
quiver(u, v, quiver_scale)
title('Second frame'), hold off
