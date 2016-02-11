function img = convert_color_space( image_name, color_space )
%CONVERT_COLOR_SPACE Loads and converts an image into the given color space

img = imread(image_name);

% convert image into given c. s.
if strcmp(color_space, 'opponent');
    % convert to opponent color space
elseif strcmp(color_space, 'rgb');
    % convert to rgb color space
elseif strcmp(color_space, 'hsv');
    % convert to HSV
    img = rgb2hsv(img);
else
    error('Invalid color space %s\n', color_space);
end

% display the channels separately
figure
subplot(1, 3, 1)
imshow(img(:,:,1))
subplot(1, 3, 2)
imshow(img(:,:,2))
subplot(1, 3, 3)
imshow(img(:,:,3))

end

