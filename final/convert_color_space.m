function converted = convert_color_space( img, color_space )
%CONVERT_COLOR_SPACE Converts an image into the given color space


% convert image into given c. s.
converted = zeros(size(img));
if strcmp(color_space, 'opp');
    % convert to opponent color space
    R = double(img(:, :, 1));
    G = double(img(:, :, 2));
    B = double(img(:, :, 3));
    converted(:, :, 1) = (R - G) / sqrt(2);
    converted(:, :, 2) = (R + G - 2 * B) / sqrt(6);
    converted(:, :, 3) = (R + G + B) / sqrt(3);
    
elseif strcmp(color_space, 'rgb');
    % convert to rgb color space
    for i=1:3;
        converted(:, :, i) = double(img(:,:,i)) ./ double(img(:,:,1) + img(:,:,2) + img(:,:,3));
    end
    
elseif strcmp(color_space, 'hsv');
    % convert to HSV
    converted = rgb2hsv(img);
else
    error('Invalid color space %s\n', color_space);
end


end

