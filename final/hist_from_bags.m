function [ histValues ] = hist_from_bags( bags, vocabulary )
%HIST_FROM_BAGS Compute histogram from raw BoVW

nbins = size(vocabulary, 1);
histValues = zeros(size(bags, 1), nbins);

binranges = 1:10;

for j = 1:size(bags, 1)
    bag = bags{j};
    
    % h = histogram(bag, nbins);
    % histValues(j, :) = h.Values;
    
    num_words = size(bag, 1)
    bag_words = zeros(num_words, 1);
    
    % Compare words to vocabulary
    for h = 1:num_words
        for i = 1:nbins
            if isequal(bag(h, :), vocabulary(i, :))
                bag_words(h) = i;
            end
        end
    end
        
    % Compute frequency of visual words
    [bincounts] = histc(bag_words,binranges);
    
    % Normalize values
    histValues(j, :) = bincounts / num_words;
    
    figure
    subplot (1, 2, 1);   hist(bag, nbins);
    subplot (1, 2, 2);   bar(binranges, histValues(j, :), 'histc');
    %hist(bag_words);
end

end

