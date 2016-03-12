clear, close all

%% Detect frames (keypoints), descriptors and matches
impath1 = 'assets/left.jpg';
impath2 = 'assets/right.jpg';
im1 = imread(impath1);
im2 = imread(impath2);

[im1sizey, im1sizex, channels] = size(im1);
[im2sizey, im2sizex, ~] = size(im2);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end

im1 = im2single(im1);
im2 = im2single(im2);

[frames1, frames2, matches] = get_matches(im1, im2);

%% Set up and perform RANSAC
N = 5;
P = 3;
radius = 10;
[best_params, inliers_count] = ransac(N, P, radius, frames1, frames2, matches, im1, im2);


%% Estimate length
[xsize, ysize, xmin, ymin] = find_transformation_bound([im2sizey, im2sizex], best_params);

estimated_x = round(im1sizex + xsize - xmin);
%max([im1sizex im2sizex xsize]);
estimated_y = round(im1sizey + ysize - ymin);
%max([im1sizey im2sizey ysize]);

 
%% Stitch
new_image = zeros(estimated_y, estimated_x);

im2_t = transform_image(im2, best_params, 1);
figure
imshow(im2_t);

for i = 1:estimated_y
   for j = 1:estimated_x
       % copy first image
       if(i <= im1sizey) && (j  <= im1sizex)
           new_image(i, j) = im1(i, j);
       elseif (i <= im1sizey)
           new_image(i, j) = im2_t(i, j-im1sizex);
       elseif (j  <= im1sizex)
           new_image(i, j) = im2_t(i-im1sizey, j);
       else
           new_image(i, j) = im2_t(i-im1sizey, j-im1sizex);
       end
   end
end

figure
imshow(new_image);




