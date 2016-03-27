function [ histValues ] = hist_from_bags( bags, vocabulary, show )
%HIST_FROM_BAGS Compute histogram from raw BoVW

if ~exist('show', 'var')
    show = 0;
end

nbins = size(vocabulary, 1);
histValues = zeros(size(bags, 1), nbins);

binranges = 1:nbins;

for j = 1:size(bags, 1)
    bag = bags{j};
    
    num_words = size(bag, 1);
    
%     h = histogram(bag, nbins);
%     histValues(j, :) = h.Values / num_words;
    
    bag_words = zeros(nbins, 1);
    
    % Compare words to vocabulary
    for h = 1:num_words
        for i = 1:nbins
            if isequal(bag(h, :), vocabulary(i, :))
                bag_words(i) = bag_words(i) + 1;
            end
        end
    end
        
    % Compute frequency of visual words
    % [bincounts] = histc(bag_words,binranges);
    
    % Normalize values
    % histValues(j, :) = bincounts / nbins;
    histValues(j, :) = bag_words / num_words;
    
    if show
        figure
        subplot (1, 2, 1);   hist(bag, nbins);
        subplot (1, 2, 2);   bar(binranges, histValues(j, :), 'histc');
    end
    %hist(bag_words);
end

end

