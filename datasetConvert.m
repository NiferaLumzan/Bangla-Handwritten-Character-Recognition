% Load training and test data using imageSet.
trainingDir = fullfile('E:\8th semester\Thesis\Bangla-Handwritten-Character-Recognition\Data-2\50');
trainingSet = imageSet(trainingDir,'recursive');


for digit = 1:numel(trainingSet)
    
    numImages = trainingSet(digit).Count; 
    label = repmat(trainingSet(digit).Description,1);
    intlabel = int32(str2num(label));
    for i = 1:numImages

        img = read(trainingSet(digit), i);

        % Apply pre-processing steps
%         img = imresize(img,[64,64]);
        img = rgb2gray(img);
        img = medfilt2(img);
        T = adaptthresh(img, 0.7);   %used adaptthresh to determine threshold to use in binarization operation.
        img = imbinarize(img,T);  %Convert image to binary image, specifying the threshold value.
        %----------------erosion------------%
        se = strel('line',4,10);
        img = imerode(img,se);
        %-----------------dilation-----------%
        se1 = strel('line',4,10);
        img = imdilate(img,se1);        
        img = imcomplement(img); 
        
        binaryImg = img;
        hblob = vision.BlobAnalysis;
        hblob.AreaOutputPort = true;
        hblob.BoundingBoxOutputPort = true;
        hblob.MajorAxisLengthOutputPort = true;
        hblob.MinorAxisLengthOutputPort = true;

        [a, c, b, maxs, mins] = step(hblob, binaryImg);
        blobNum = size(c);
        binary_Image = im2uint8(binaryImg);
        shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor', 'Custom', 'CustomBorderColor', uint8([255 0 0]), 'LineWidth', 2);
        blobImg = repmat(binary_Image, [1, 1, 3]);
        for j=1: blobNum
              rect = int16([b(j,1), b(j,2), b(j,3), b(j,4)]);
              blobImg = step(shapeInserter, blobImg, rect);
        end
        
%         imshow(blobImg);
        img = rgb2gray(blobImg);
        img = imbinarize(img);        
        img = imresize(img,[64,64]);
        img = bwareaopen(img, 50);
        cc = bwconncomp(img);
        props = regionprops(cc, 'I');
        
        label = repmat(trainingSet(digit).Description,1);
        intlabel = int32(str2num(label));
        for j = 1:cc.NumObjects
            objects = props(j).Image;
            fileName = sprintf('%d%d%d.jpg',intlabel,j,i);
            fullFileName = fullfile('E://8th semester/Thesis/Bangla-Handwritten-Character-Recognition/Data_2',fileName);
            imwrite(objects,fullFileName,'jpg');
        end        
    end
end
