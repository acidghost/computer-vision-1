%% AP results per parameter settings
RGB = [0.8463 0.8872 0.7344 0.9238 0.8480];
rgb = [0.9728 0.8969 0.8278 0.7775 0.8687];
opp = [0.9570 0.9218 0.9392 0.8438 0.9155];

RGB_RBFkernel  = [0.8732 0.7919 0.6892 0.8486 0.8007];
RGB_polykernel = [0.6967 0.6202 0.5176 0.6342 0.6172];
RGB_sigmkernel = [0.8650 0.7982 0.6780 0.8459 0.7968];

RGB_50train = [0.9121 0.8640 0.6185 0.9016 0.8241];
rgb_50train = [0.9736 0.8558 0.8322 0.7590 0.8552];
opp_50train = [0.9003 0.9233 0.9051 0.8018 0.8826];

RGB_1600voc = [0.9399 0.8744 0.6194 0.8895 0.8308];
RGB_4000voc = [0.9464 0.9076 0.7766 0.9303 0.8902];

dense = [0.9362 0.8897 0.9552 0.8467 0.9069];

%% Color descriptors
data = [RGB; rgb; opp];

figure
h = bar(data');

labels = {'Airplanes','Cars', 'Faces','Motorbikes', 'mean'};
set(gca, 'XTick', 1:5, 'XTickLabel', labels);

leg = cell(1,3);
leg{1}='RGBSIFT'; leg{2}='rgbSIFT'; leg{3}='opponentSIFT';
legend(h,leg, 'Location','eastoutside');
ylabel('Average Precision');
title('AP for different color descriptors');

%% SVM kernel
data = [RGB; RGB_RBFkernel; RGB_polykernel; RGB_sigmkernel];

figure
h = bar(data');

labels = {'RGB','Cars', 'Faces','Motorbikes', 'mean'};
set(gca, 'XTick', 1:5, 'XTickLabel', labels);

leg = cell(1,4);
leg{1}='Linear'; leg{2}='RBF'; leg{3}='Polynomial'; leg{4}='Sigmoid';
legend(h,leg, 'Location','eastoutside');
ylabel('Average Precision');
title('AP for different kernel type');

%% Training set size plot
data = [RGB; RGB_50train];
parameters = [200; 50];

figure
plot(parameters, data);

leg = cell(1,2);
leg{1}='Airplanes'; leg{2}='Cars'; leg{3}='Faces'; leg{4}='Motorbikes'; leg{5}='mean';
legend(leg, 'Location','eastoutside');
ylabel('Average Precision');
xlabel('Training size');
title('AP vs training images per class');

%% Training set size per color descriptor
mAP_400train = [RGB(end) rgb(end) opp(end)];
mAP_50train  = [RGB_50train(end) rgb_50train(end) opp_50train(end)];
data = [mAP_50train; mAP_400train];

figure
h = bar(data');

labels = {'RGB', 'rgb', 'opp'};
set(gca, 'XTick', 1:3, 'XTickLabel', labels);

leg = cell(1,2);
leg{1}='50 training images per class'; leg{2}='200 training images per class';
legend(h,leg, 'Location','eastoutside');
ylabel('Average Precision');
title('AP for different training set size');

%% Vocabulary size
data = [RGB; RGB_1600voc; RGB_4000voc];
parameters = [400; 1600; 4000];

figure
plot(parameters, data);

leg = cell(1,2);
leg{1}='Airplanes'; leg{2}='Cars'; leg{3}='Faces'; leg{4}='Motorbikes'; leg{5}='mean';
legend(leg, 'Location','eastoutside');
ylabel('Average Precision');
xlabel('Vocabulary size');
title('AP vs Vocabulary size');

%% Dense vs keypoint
data = [RGB_50train; dense];

figure
h = bar(data');

labels = {'Airplanes','Cars', 'Faces','Motorbikes', 'mean'};
set(gca, 'XTick', 1:5, 'XTickLabel', labels);

leg = cell(1,2);
leg{1}='Keypoint sampling'; leg{2}='Dense sampling';
legend(h,leg, 'Location','eastoutside');
ylabel('Average Precision');
title('AP for different sampling techniques');

