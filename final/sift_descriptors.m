function [ frames, descriptors ] = sift_descriptors( im, type, dense )
%SIFT_DESCRIPTORS


if ~exist('dense', 'var')
    dense = 0;
end

if ~strcmp(type, 'rgb') && ~strcmp(type, 'RGB') && ~strcmp(type, 'opp')
    error('SIFT type not supported: %s', type)
end

if ~strcmp(type, 'RGB')
    im = convert_color_space(im, type);
end

[~, ~, imsizez] = size(im);

if ~isa(im, 'single')
    im = im2single(im);
end

frames = cell(1, imsizez);
descriptors = cell(1, imsizez);
for z = 1:imsizez
    imc = im(:, :, z);
    if dense
        [framesc, descs] = vl_dsift(imc);
    else
        [framesc, descs] = vl_sift(imc);
        framesc = framesc(1:2, :);
    end
    frames{z} = framesc;
    descriptors{z} = descs;
end


end

