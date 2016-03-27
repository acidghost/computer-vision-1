function [ descriptors, frames ] = sift_descriptors( im, type, dense )
%SIFT_DESCRIPTORS

%% Checks and definitions
% Define type of sampling
if ~exist('dense', 'var')
    dense = 0;
end

% Check for descriptor type
if ~strcmp(type, 'rgb') && ~strcmp(type, 'RGB') && ~strcmp(type, 'opp')
    error('SIFT type not supported: %s', type)
end

% Transform to grayscale
[~, ~, imsizez] = size(im);

if imsizez ~= 1
    imgray = rgb2gray(im);
else
    imgray = im;
end

% Transform to color space
if ~strcmp(type, 'RGB')
    im = convert_color_space(im, type);
end

% Check images are single datatype
if ~isa(im, 'single')
    im = im2single(im);
    imgray = im2single(imgray);
end

%% Get descriptors
frames = cell(1, imsizez);
descriptors = cell(1, imsizez);

if ~dense
    % detect keypoints in intensity image
    keypoints = vl_sift(imgray);
end

for z = 1:imsizez
    imc = im(:, :, z);
    if dense
        % Note, need to presmooth it. dsift is equivalent to sift by default unless options are turned on 
        [framesc, descs] = vl_dsift(imc);
    else
        % get descriptors for channel around keypoints
        [framesc, descs] = vl_sift(imc, 'Frames', keypoints);
        framesc = framesc(1:2, :);
    end
    frames{z} = framesc;
    descriptors{z} = descs;
end


end

