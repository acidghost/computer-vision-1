function [matches_index matches_1 matches_2] = get_keypoints(im1, im2)
% GET_KEYPOINTS return keypoints matchings between two given images

run('vlfeat-0.9.20/toolbox/vl_setup')

%% Transform images
[~, ~, channels] = size(im1);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end 

im1 = im2single(im1);
im2 = im2single(im2);


%% Detect frames (keypoints) and descriptors and matches
[frames1, desc1] = vl_sift(im1);
[frames2, desc2] = vl_sift(im2);

matches_index = vl_ubcmatch(desc1, desc2);

%% Get points according to indexes in 'matches'
matches_1 = frames1(1:2, matches_index(1, :));
matches_2 = frames2(1:2, matches_index(2, :));

end