function [ imtrans ] = transform_image( im, params, invert )
%TRANSFORM_IMAGE Transform the given image using the affine transformation
%                defined by 'params' using nearest neighbor interpolation

[ imsizey, imsizex ] = size(im);

if ~exist('invert', 'var')
    invert = 0;
end

[ xsize, ysize, xmin, ymin ] = find_transformation_bound(size(im), params, invert);
imtrans = zeros(ysize, xsize);
% for each pixel in the new image
for y = 0:ysize-1
    for x = 0:xsize-1
        % get inverse transform of that point starting from transformed
        % minimum along x and y axes
        tp = transform_point(xmin + x, ymin + y, params, ~invert);
        if tp(1) < 1 || tp(2) < 1 || tp(1) > imsizex || tp(2) > imsizey
            imtrans(y+1, x+1) = 0;
        else
            % nearest neighbor interpolation
            tp = round(tp);
            imtrans(y+1, x+1) = im(tp(2), tp(1));
        end
    end
end


end

