function [ visual_words ] = as_bag( im, vocabulary, type, dense )
%AS_BAG

if ~exist('type', 'var')
    type = 'RGB';
end

if ~exist('dense', 'var')
    dense = 0;
end


[~, ~, imsizez] = size(im);
if imsizez ~= 3
    error('This image is grayscale')
end

descriptors = sift_descriptors(im, type, dense);
descriptors = double([descriptors{1}', descriptors{2}', descriptors{3}']);

[ndesc, ~] = size(descriptors);
[nvocs, ncols] = size(vocabulary);


visual_words = zeros(ndesc, ncols);
for i = 1:ndesc
    descriptor = descriptors(i, :);
    best_norm = inf;
    for j = 1:nvocs
        vocab = vocabulary(j, :);
        this_norm = norm(descriptor - vocab);
        if this_norm < best_norm
            best_norm = this_norm;
            center = vocab;
        end
    end
    visual_words(i, :) = center;
end


end

