function [ imtrans ] = transform_image( im, params, invert )
%TRANSFORM_IMAGE Transform the given image using the affine transformation
%                defined by 'params' using nearest neighbor interpolation

[ imsizey, imsizex ] = size(im);

if ~exist('invert', 'var')
    invert = 0;
end

[ xsize, ysize, xmin, ymin ] = find_transformation_bound(size(im), params, ~invert);
imtrans = zeros(ysize, xsize);
% for each pixel in the new image
for y = 0:ysize-1
    for x = 0:xsize-1
        % get inverse transform of that point starting from transformed
        % minimum along x and y axes
        tp = transform_point(ymin + y, xmin + x, params, invert);
        tpy = tp(1);
        tpx = tp(2);
        if tpy < 1 || tpx < 1 || tpx > imsizex || tpy > imsizey
            imtrans(y+1, x+1) = 0;
        else
            % nearest neighbor interpolation
            tpx = round(tpx);
            tpy = round(tpy);
            imtrans(y+1, x+1) = im(tpy, tpx);
        end
    end
end


end

