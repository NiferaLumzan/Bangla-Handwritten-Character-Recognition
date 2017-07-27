% Load training and test data using imageSet.
trainingDir = fullfile('E:\8th semester\Thesis\Bangla-Handwritten-Character-Recognition\TrainingDataSet');
testDir = fullfile('E:\8th semester\Thesis\Bangla-Handwritten-Character-Recognition\TestDataSet');

% imageSet recursively scans the directory tree containing the images.
trainingSet = imageSet(trainingDir,   'recursive');
testSet  = imageSet(testDir, 'recursive');

img = read(trainingSet(1), 1);
img = imresize(img, [64,64]);

% Extract HOG features and HOG visualization
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);
% figure;
% imshow(img); hold on;
% plot(vis8x8);
% title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_16x16))]});

cellSize = [8 8];
hogFeatureSize = length(hog_8x8);

trainingFeatures = [];
trainingLabels   = [];

testFeatures = [];
testLabels   = [];

for digit = 1:numel(trainingSet)
    
    numImages = trainingSet(digit).Count;
    features  = zeros(numImages, hogFeatureSize);
    
    for i = 1:numImages

        img = read(trainingSet(digit), i);

        % Apply pre-processing steps
        IM = imresize(img,[64,64]);
        IM = rgb2gray(IM);
        IM = medfilt2(IM);
        M = mean(IM);
        % t = graythresh(IM);
        % Iblur = imgaussfilt(IM, 1);
        % IM = Iblur;
        T = adaptthresh(IM, 0.7);   %used adaptthresh to determine threshold to use in binarization operation.
        BW = imbinarize(IM,T);  %Convert image to binary image, specifying the threshold value.

        %----------------erosion------------%
        se = strel('line',4,10);
        erodedI = imerode(BW,se);
        %-----------------dilation-----------%
        se1 = strel('line',4,10);
        BW3 = imdilate(erodedI,se1);
        
        %------finding HOG featurs for each images-----------%
        features(i, :) = extractHOGFeatures(BW3, 'CellSize', cellSize);

    end

    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(trainingSet(digit).Description, numImages,1);

    trainingFeatures = [trainingFeatures; features];   %#ok<AGROW>
    trainingLabels   = [trainingLabels; labels];   %#ok<AGROW>
end

% classfication using SVM.
classifier = fitcecoc(trainingFeatures, trainingLabels);


%%%%%%%%%%%%%%% Test Dataset %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for digit = 1:numel(testSet)
    
    numImages = testSet(digit).Count;
    features  = zeros(numImages, hogFeatureSize);

    for i = 1:numImages
        
        img = read(testSet(digit), i);
        
        % Apply pre-processing steps
        IM = imresize(img,[64,64]);
        IM = rgb2gray(IM);
        IM = medfilt2(IM);
        M = mean(IM);
        % t = graythresh(IM);
        % Iblur = imgaussfilt(IM, 1);
        % IM = Iblur;
        T = adaptthresh(IM, 0.7);   %used adaptthresh to determine threshold to use in binarization operation.
        BW = imbinarize(IM,T);  %Convert image to binary image, specifying the threshold value.

        %----------------erosion-----------------------------%
        se = strel('line',4,10);
        erodedI = imerode(BW,se);
        %-----------------dilation---------------------------%
        se1 = strel('line',4,10);
        BW3 = imdilate(erodedI,se1);
        
        %------finding HOG featurs for each images-----------%
        features(i, :) = extractHOGFeatures(BW3, 'CellSize', cellSize);

    end

    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(trainingSet(digit).Description, numImages,1);

    testFeatures = [testFeatures; features];   %#ok<AGROW>
    testLabels   = [testLabels; labels];   %#ok<AGROW>
end

% [testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testSet, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMatPercentage = bsxfun(@rdivide,confMat,sum(confMat,2));

save('trainingFeaturesHOG.mat','trainingFeatures');
save('testFeaturesHOG.mat','testFeatures');

% helperDisplayConfusionMatrix(confMat)
% [C,order] = confusionmat(testLabels,predictedLabels)