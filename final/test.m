% test_data = cell(nlabels, 1);
% for i = 1:nlabels
%     label = labels{i};
%     class_metadata = metadata.(label);
%     bags = cell(class_metadata.test, 1);
%     for j = 1:class_metadata.test
%         impath = sprintf(class_metadata.impath, 'test', j);
%         disp(['Reading ' impath])
%         im = imread(impath);
%         im = im2double(im);
%         bags{j} = as_bag(im, vocabulary, sift_type, sift_dense);
%     end
%     test_data{i} = hist_from_bags(bags, nbins);
% end


predicted = cell(nlabels, 1);
for i = 1:nlabels
    label = labels{i};
    class_test_data = test_data{i};

    for j = 1:size(class_test_data, 1)
        test_im = class_test_data(j, :);
        decision_values = cell(nlabels, 1);
        for k = 1:nlabels
            model = models{k};

            [~, ~, decision_values{k}] = svmpredict(...
                double(i == k), test_im, model, '-q');
        end
        [~, c] = max(cell2mat(decision_values));
        fprintf('%s classified as %s\n', label, labels{c});
    end
end
