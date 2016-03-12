clear, close all

%% Detect frames (keypoints), descriptors and matches
impath1 = 'assets/left.jpg';
impath2 = 'assets/right.jpg';
im1 = imread(impath1);
im2 = imread(impath2);

[imsizey, imsizex, channels] = size(im2);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end

im1 = im2single(im1);
im2 = im2single(im2);

[frames1, frames2, matches] = get_matches(im1, im2);

%% Set up and perform RANSAC
N = 1;
P = 3;
radius = 10;
[best_params, inliers_count] = ransac(N, P, radius, frames1, frames2, matches, im1, im2);


%% Estimate length
[estimated_x estimated_y] = find_transformation_bound([imsizey imsizex], best_params);

 
%% Stitch
new_image = zeros(estimated_y, estimated_x);

im2_t = transform_image(im1, best_params);

for i = 1:estimated_y
   for j = 1:estimated_x
       % copy first image
       if(i <= imsizey) && (j  <= imsizex)
           new_image(i, j) = im1(i, j);
       elseif (i <= imsizey)
           new_image(i, j) = im2_t(i, j-imsizex);
       else 
           new_image(i, j) = im2_t(i-imsizey, j);
       end
   end
end

figure
imshow(new_image);




