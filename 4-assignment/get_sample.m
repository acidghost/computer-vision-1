function [ sample, sample_idx ] = get_sample( N, nsamples, data, dimension )
%GET_SAMPLE Get a random sample

sample_idx = randperm(N);
sample_idx = sample_idx(1:nsamples);
if exist('dimension', 'var') && dimension == 1
    sample = data(sample_idx);
else
    sample = data(:, sample_idx);
end

end

