close all


regions_size = 15;
quiver_scale = 15;
show_loops = 30;

impath1 = 'assets/sphere1.ppm';
impath2 = 'assets/sphere2.ppm';
[u, v] = lucas_kanade(impath1, impath2, regions_size, show_loops, quiver_scale);

% impath1 = 'assets/synth1.pgm';
% impath2 = 'assets/synth2.pgm';
% [u, v] = lucas_kanade(impath1, impath2, regions_size, show_loops, quiver_scale);

% impath1 = 'assets/pingpong/0000.jpeg';
% impath2 = 'assets/pingpong/0001.jpeg';
% [u, v] = lucas_kanade(impath1, impath2, regions_size, show_loops, quiver_scale);

% impath1 = 'assets/person_toy/00000001.jpg';
% impath2 = 'assets/person_toy/00000002.jpg';
% [u, v] = lucas_kanade(impath1, impath2, regions_size, show_loops, quiver_scale);
