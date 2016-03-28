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
nim_visual_voc = 200; % default 200


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
K = 400; % default 400
fprintf('\nClustering with K=%d\n', K)
tic
vocabulary = vl_kmeans(voc_features', K, 'algorithm', 'ann')';
toc


%% Training

% Create one SVM model per label
nim_train = nim_visual_voc;
bags_by_class = cell(nlabels, 1);

% Load training data
for i = 1:nlabels
    
    % Create training set
    label = labels{i};
    class_metadata = metadata.(label);

    % Get examples (exclude samples used for dictionary creation)
    sample_idx = get_sample_excl(nim_train, class_metadata.train, dict_samples(i, :));
    bags = cell(nim_train, 1);

    for s = 1:numel(sample_idx)
        sample_id = sample_idx(s);
        fprintf('Loading train: %s\t%d\n', label, s);
        
        % Read image in and get descriptors
        impath = sprintf(class_metadata.impath, 'train', sample_id);
        im = imread(impath);
        im = im2double(im);
        
        % Find visual words present in image
        bags{s} = as_bag(im, vocabulary, sift_type, sift_dense);
    end
    
    bags_by_class{i} = bags;
end

hists = cell(nlabels, 1);
for i = 1:nlabels
    bags = bags_by_class{i};
    % Compute normalized histograms
    hists{i} = hist_from_bags(bags, vocabulary);
end

