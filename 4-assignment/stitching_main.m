clear, close all

%% Read images
% im1 is left, im2 is right
impath1 = 'assets/left.jpg';
impath2 = 'assets/right.jpg';

im1 = im2single(imread(impath1));
im2 = im2single(imread(impath2));

[imsizey, imsizex, channels] = size(im1);

%% Get keypoints
N = 5;
[parameters keypoints_x1 keypoints_y1] = get_best_transformation(im1, im2, N);


%% Estimate length
[estimated_x estimated_y] = find_transformation_bound([imsizey imsizex], parameters);

 
%% Stitch
new_image = zeros(estimated_y, estimated_x);

im2_t = transform_image(im1, parameters);

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




