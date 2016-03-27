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

    sample_idx = randperm(nim_train * nlabels);
    train_set = [pos_hists; neg_hists];
    train_set = train_set(sample_idx, :);
    train_labels = [ones(size(pos_hists, 1), 1) ;...
                    repmat(-1, size(neg_hists, 1), 1)];
    train_labels = train_labels(sample_idx);

    models{i} = svmtrain(train_labels, train_set, '-s 0 -t 0 -c 1');
end