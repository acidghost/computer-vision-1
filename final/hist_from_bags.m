function [ hist ] = hist_from_bags( bags, nbins )
%HIST_FROM_BAGS Compute histogram from raw BoVW


hist = zeros(size(bags, 1), nbins);
for j = 1:size(bags, 1)
    bag = bags{j};
    h = histogram(bag, nbins);
    hist(j, :) = h.Values;
end

end

