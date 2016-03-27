models = cell(nlabels, 1);
for i = 1:nlabels
    % Train SVM
    pos_hists = hists{i};
    neg_hists = cell(nlabels - 1, 1);
    k = 1;
    for j = 1:nlabels
        if ~strcmp(labels{i}, labels{j})
            neg_hists{k} = hists{j};
            k = k + 1;
        end
    end
    neg_hists = cell2mat(neg_hists);
    % temp = randperm(nim_train * (nlabels - 1));
    % neg_hists = neg_hists(temp(1:400), :);

    train_set = [pos_hists; neg_hists];
    train_labels = [ones(size(pos_hists, 1), 1) ;...
                    zeros(size(neg_hists, 1), 1)];

    models{i} = svmtrain(train_labels, train_set, '-s 2');
end
