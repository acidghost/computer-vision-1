function [ ap ] = average_precision( predicted, classntest, label )
%AVERAGE_PRECISION Compute Average Precision given predictions

s = 0;
fc = 0;
for i = 1:size(predicted, 2)
    prediction = predicted(i);
    if numel(strfind(prediction.impath, label)) ~= 0
        fc = fc + 1;
    end
    s = s + (fc / i);
end

ap = s / classntest;

end

