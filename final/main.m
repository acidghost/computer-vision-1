set_env, clear, close all

metadata.airplanes.impath = './Caltech4/ImageData/airplanes_%s/img%03d.jpg';
metadata.airplanes.train = 500;
metadata.airplanes.test = 50;
metadata.cars.impath = './Caltech4/ImageData/cars_%s/img%03d.jpg';
metadata.cars.train = 465;
metadata.cars.test = 50;
metadata.faces.impath = './Caltech4/ImageData/faces_%s/img%03d.jpg';
metadata.faces.train = 400;
metadata.faces.test = 50;
metadata.motorbikes.impath = './Caltech4/ImageData/motorbikes_%s/img%03d.jpg';
metadata.motorbikes.train = 500;
metadata.motorbikes.test = 50;

labels = fieldnames(metadata);


sift_dense = 0;
sift_type = 'RGB';
nim_visual_voc = 50;

all_features = cell(nim_visual_voc * length(labels), 1);
dict_samples = zeros(numel(labels), nim_visual_voc);
k = 1;
for i = 1:length(labels)
    label = labels{i};
    class_metadata = metadata.(label);
    if nim_visual_voc > class_metadata.train
        error('Not enough training images available!')
    end

    sample_idx = randperm(class_metadata.train, nim_visual_voc);
    dict_samples(i, :) = sample_idx;
    for s = 1:numel(sample_idx)
        sample_id = sample_idx(s);
        impath = sprintf(class_metadata.impath, 'train', sample_id);
        fprintf('Label: %s\t%d\n', label, s);
        im = imread(impath);
        im = im2double(im);
        descriptors = sift_descriptors(im, sift_type, sift_dense);
        if size(descriptors, 2) == 3
            all_features{k} = [descriptors{1}', descriptors{2}', descriptors{3}'];
        else
            fprintf('Image %s is grayscale\n', impath)
            all_features{k} = [descriptors{1}', descriptors{1}', descriptors{1}'];
        end
        k = k + 1;
    end
end
all_features = double(cell2mat(all_features));

% cluster all descriptors
K = 10;
fprintf('\nClustering with K=%d\n', K)
[~, vocabulary] = kmeans(all_features, K, 'OnlinePhase', 'off');



fprintf('\n\nStarting training...\n\n')
nim_train = 50;
nbins = 10;
models = cell(numel(labels), 1);
for i = 1:length(labels)
    label = labels{i};
    class_metadata = metadata.(label);
    fprintf('Training model for %s\n\n', label)

    % get positive examples
    sample_idx = get_sample_excl(nim_train, class_metadata.train, dict_samples(i, :));
    bags = cell(nim_train, 1);
    for s = 1:numel(sample_idx)
        sample_id = sample_idx(s);
        impath = sprintf(class_metadata.impath, 'train', sample_id);
        fprintf('Label: %s\t%d\n', label, s);
        im = imread(impath);
        im = im2double(im);
        bags{s} = as_bag(im, vocabulary, sift_type, sift_dense);
    end

    % get negative examples
    neg_bags = cell(nim_train * (length(labels) - 1), 1);
    for j = 1:length(labels)
        neg_label = labels{j};
        if strcmp(neg_label, label)
            continue
        end
        neg_class_metadata = metadata.(neg_label);
        neg_sample_idx = get_sample_excl(nim_train, neg_class_metadata.train, dict_samples(j, :));
        for s = 1:numel(neg_sample_idx)
            sample_id = neg_sample_idx(s);
            impath = sprintf(neg_class_metadata.impath, 'train', sample_id);
            fprintf('Neg Label: %s\t%d\n', neg_label, s);
            im = imread(impath);
            im = im2double(im);
            neg_bags{s} = as_bag(im, vocabulary, sift_type, sift_dense);
        end
    end

    % compute normalized histograms
    pos_hist = zeros(size(bags, 1), K);
    for j = 1:size(bags, 1)
        bag = bags{j};
        h = histogram(bag, nbins);
        pos_hist(j, :) = h.Values;
    end
    neg_hist = zeros(size(neg_bags, 1), K);
    for j = 1:size(neg_bags, 1)
        bag = neg_bags{j};
        h = histogram(bag, nbins);
        neg_hist(j, :) = h.Values;
    end


    % train SVM
    models{i} = svmtrain([zeros(size(pos_hist, 1), 1); ones(size(neg_hist, 1), 1)], [pos_hist; neg_hist]);
end




reset_env
