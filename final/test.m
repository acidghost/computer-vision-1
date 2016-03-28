% Get testing data
test_data = cell(nlabels, 1);
test_data_impaths = cell(nlabels, 1);
for i = 1:nlabels
    label = labels{i};
    class_metadata = metadata.(label);
    bags = cell(class_metadata.test, 1);
    impaths = cell(class_metadata.test, 1);
    for j = 1:class_metadata.test
        impath = sprintf(class_metadata.impath, 'test', j);
        impaths{j} = impath;
        disp(['Reading ' impath])
        im = imread(impath);
        im = im2double(im);
        bags{j} = as_bag(im, vocabulary, sift_type, sift_dense);
    end
    test_data{i} = hist_from_bags(bags, vocabulary);
    test_data_impaths{i} = impaths;
end


% This contains a list of impaths and decision values sorted by decreasing
% decision value. Each element in predicted is the result of classification
% using one classifier over all (200) images.
predicted = cell(nlabels, 1);
for i = 1:nlabels
    label = labels{i};
    model = models{i};
    predicted{i} = struct();

    offset = 1;
    for j = 1:nlabels
        class_test_data = test_data{j};
        class_impaths = test_data_impaths{j};

        for k = 1:size(class_test_data, 1)
            test_im = class_test_data(k, :);
            [~, ~, dv] = svmpredict(0, test_im, model, '-q');

            predicted{i}(offset).impath = class_impaths{k};
            predicted{i}(offset).score = dv;
            offset = offset + 1;
        end
    end

    [~, sorted_idx] = sort([predicted{i}.score], 'descend');
    predicted{i} = predicted{i}(sorted_idx);
end

html_table = html_table_results(predicted, size(cell2mat(test_data), 1), nlabels);
aps = zeros(nlabels, 1);
for i = 1:nlabels
    aps(i) = average_precision(predicted{i}, 50, labels{i});
    fprintf('AP for %s is %.4f\n', labels{i}, aps(i));
end
map = sum(aps) / nlabels;
fprintf('\nMAP is %.4f\n', map);
