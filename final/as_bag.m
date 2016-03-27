function [ visual_words ] = as_bag( im, vocabulary, type, dense )
%AS_BAG takes an image and returns the visual words found from the
%vocabulary

if ~exist('type', 'var')
    type = 'RGB';
end

if ~exist('dense', 'var')
    dense = 0;
end

%% Compute color descriptors using sift
descriptors = sift_descriptors(im, type, dense);

if size(descriptors, 2) == 3
    descriptors = double([descriptors{1}', descriptors{2}', descriptors{3}']);
else
    descriptors = double([descriptors{1}', descriptors{1}', descriptors{1}']);
end

[ndesc, ~] = size(descriptors);
[nvocs, ncols] = size(vocabulary);


%% Assign descriptors to closest vocabulary bag
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

