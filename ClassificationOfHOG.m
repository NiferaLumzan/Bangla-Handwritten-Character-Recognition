% Load training and test data using imageSet.
trainingDir = fullfile('E:\8th semester\Thesis\Bangla-Handwritten-Character-Recognition\TrainingDataSet');
testDir = fullfile('E:\8th semester\Thesis\Bangla-Handwritten-Character-Recognition\TestDataSet');

% imageSet recursively scans the directory tree containing the images.
trainingSet = imageSet(trainingDir,   'recursive');
testSet     = imageSet(testDir, 'recursive');

img = read(trainingSet(1), 1);
img = imresize(img,[255,255]);

% Extract HOG features and HOG visualization
[hog_255x255, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
plot(vis4x4);
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_255x255))]});

cellSize = [4 4];
hogFeatureSize = length(hog_255x255);

trainingFeatures = [];
trainingLabels   = [];

testFeatures = [];
testLabels   = [];
%-----------creating structure for zernike moment------------------%


for digit = 1:numel(trainingSet)
    
    numImages = trainingSet(digit).Count;
    features  = zeros(numImages, hogFeatureSize, 'single');
    
    for i = 1:numImages

        img = read(trainingSet(digit), i);

        % Apply pre-processing steps
        IM = imresize(img,[255,255]);
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

    trainingFeatures = [trainingFeatures; features];   %#ok<AGROW>
    trainingLabels   = [trainingLabels; labels];   %#ok<AGROW>
end

% classfication using SVM.
classifier = fitcsvm(trainingFeatures, trainingLabels);



%%%%%%%%%%%%%%% Test Dataset %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for digit = 1:numel(testSet)
    
    numImages = trainingSet(digit).Count;
    features  = zeros(numImages, hogFeatureSize, 'single');

    for i = 1:numImages

        img = read(testSet(digit), i);

        % Apply pre-processing steps
        IM = imresize(img,[255,255]);
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
    testLabels   = [testLabels; labels];   
end

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% helperDisplayConfusionMatrix(confMat)
% [C,order] = confusionmat(testLabels,predictedLabels)
