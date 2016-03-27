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


% this contains an array of struct for each label
% each struct contains the impath, predicted label and the score
% TODO: instead of creating a list for each CORRECT label
% we should create a list for each classifier
predicted = cell(nlabels, 1);
for i = 1:nlabels
    label = labels{i};
    class_test_data = test_data{i};
    class_impaths = test_data_impaths{i};
    predicted{i} = struct();

    for j = 1:size(class_test_data, 1)
        test_im = class_test_data(j, :);
        decision_values = cell(nlabels, 1);
        for k = 1:nlabels
            model = models{k};

            [~, ~, decision_values{k}] = svmpredict(...
                double(i == k), test_im, model, '-q');
        end
        [dv, c] = max(cell2mat(decision_values));
        fprintf('%s classified as %s\n', label, labels{c});

        predicted{i}(j).impath = class_impaths{j};
        predicted{i}(j).prediction = c;
        predicted{i}(j).score = dv;
    end
    
    [~, sorted_idx] = sort([predicted{i}.score], 'descend');
    predicted{i} = predicted{i}(sorted_idx);
end
