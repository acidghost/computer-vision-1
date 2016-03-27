set_env, clear, close all

%% Build metadata: 4 classes with corresponding training and testing sets
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
nlabels = length(labels);


%% Define parameters
sift_dense = 0;
sift_type = 'RGB';
nim_visual_voc = 2; % default 400


%% Build visual vocabulary
voc_features = cell(nim_visual_voc * nlabels, 1);
dict_samples = zeros(nlabels, nim_visual_voc);
k = 1;

for i = 1:nlabels
    label = labels{i};
    class_metadata = metadata.(label);
    if nim_visual_voc > class_metadata.train;
        error('Not enough training images available!')
    end
    
    % Sample from each class
    temp = randperm(class_metadata.train);
    sample_idx = temp(1:nim_visual_voc);
    
    dict_samples(i, :) = sample_idx;
    
    % Gather descriptors for all samples in that category
    for s = 1:numel(sample_idx)
        sample_id = sample_idx(s);
        fprintf('Label: %s\t%d\n', label, s);
        
        % Read image in and get descriptors
        impath = sprintf(class_metadata.impath, 'train', sample_id);
        im = imread(impath);
        im = im2double(im);
        descriptors = sift_descriptors(im, sift_type, sift_dense);
        
        % Determine dimensionality of descriptors
        if size(descriptors, 2) == 3
            voc_features{k} = [descriptors{1}', descriptors{2}', descriptors{3}'];
        else
            fprintf('Image %s is grayscale\n', impath)
            voc_features{k} = [descriptors{1}', descriptors{1}', descriptors{1}'];
        end
        k = k + 1;
    end
end

% Merge feature descriptors from all categories
voc_features = double(cell2mat(voc_features));

% Cluster all descriptors
K = 10;
fprintf('\nClustering with K=%d\n', K)
vocabulary = vl_kmeans(voc_features', K)';


%% Training

% Create one SVM model per label
fprintf('\n\nStarting training...\n\n')
nim_train = nim_visual_voc;
nbins = K;
models = cell(nlabels, 1);

% Construct models
for i = 1:nlabels
    
    % Create training set
    label = labels{i};
    class_metadata = metadata.(label);
    fprintf('Training model for %s\n\n', label)

    % Get positive examples (exclude samples used for dictionary creation)
    sample_idx = get_sample_excl(nim_train, class_metadata.train, dict_samples(i, :));
    pos_bags = cell(nim_train, 1);
    
    for s = 1:numel(sample_idx)
        sample_id = sample_idx(s);
        fprintf('Label: %s\t%d\n', label, s);
        
        % Read image in and get descriptors
        impath = sprintf(class_metadata.impath, 'train', sample_id);
        im = imread(impath);
        im = im2double(im);
        
        % Find visual words present in image
        pos_bags{s} = as_bag(im, vocabulary, sift_type, sift_dense);
    end

    % Get negative examples from each class
    neg_bags = cell(nim_train * (nlabels - 1), 1);
    
    for j = 1:nlabels
        neg_label = labels{j};
        
        % Ignore negative examples that are from your own label
        if strcmp(neg_label, label)
            continue
        end
        
        % Get negative examples (excluding samples used for dictionary
        % creation)
        neg_class_metadata = metadata.(neg_label);
        neg_sample_idx = get_sample_excl(nim_train, neg_class_metadata.train, dict_samples(j, :));
        
        
        for s = 1:numel(neg_sample_idx)
            sample_id = neg_sample_idx(s);
            fprintf('Neg Label: %s\t%d\n', neg_label, s);
            
            % Read image in and get descriptors
            impath = sprintf(neg_class_metadata.impath, 'train', sample_id);
            im = imread(impath);
            im = im2double(im);
            
            % Find visual word present in image (quantize features)
            neg_bags{s} = as_bag(im, vocabulary, sift_type, sift_dense);
        end
    end

    % Compute normalized histograms
    pos_hists = hist_from_bags(pos_bags, vocabulary);
    neg_hists = hist_from_bags(neg_bags, vocabulary);

    

    % Train SVM
    train_labels = [ones(size(pos_hists, 1), 1);...
                    zeros(size(neg_hists, 1), 1)];
    models{i} = svmtrain(train_labels, [pos_hists; neg_hists]);
end

