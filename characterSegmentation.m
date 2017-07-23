%%%%%%%%%%%%%%%% character separation %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('160.jpg');
% I = img; 
% img = rgb2gray(img);
img = imbinarize(img);
% img = imcomplement(img);
% img = imresize(img, [32,128]); 
[row, column] = size(img);
I = img; 

rowSum = zeros(1,row); 
for i = 1:row  
    r = 0;
    for j = 1:column
        r = r + img(i,j);
    end
    rowSum(i) = r;    
end

countZeros = 0;
for i = 1:row
   if(rowSum(i)== 0)
       countZeros = countZeros + 1; 
   end
   if(countZeros <= 10)
       
   end
end
%----------- eleminating 'u' kar ---------%
m = row;
for x = 1:row
    if(x <= 7) 
        img(m,:) = 0;
    end
    m = m-1;   
end
%---------------- separation  --------------%
columnSum = zeros(1,column); 
for i = 1:column  
    col = 0;
    for j = 1:row
        col = col + img(j,i);
    end
    columnSum(i) = col;    
end
%find the minimum value from the columnSum and eleminate
%the corresponding stroke from the image
minimum = min(columnSum); 
for x = 1:column
    [k,l] = min(columnSum(1:column));
    if(k == minimum || k < minimum+4)
        columnSum(l) = 999999;
        for i = 1:(row/2)
            img(i,l) = 0;
        end
    end
end
% imshowpair(I,img,'montage');
% axis on;
%--------------------------------------%
%------------ Blob analysis -----------%
%--------------------------------------%
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
for i=1: blobNum
      rect = int16([b(i,1), b(i,2), b(i,3), b(i,4)]);
      blobImg = step(shapeInserter, blobImg, rect);
end

imshow(blobImg);
axis on;
img = rgb2gray(blobImg);
img = imbinarize(img);
img = bwareaopen(img, 50);
cc = bwconncomp(img);
props = regionprops(cc, 'I');
for i = 1:cc.NumObjects
    objects = props(i).Image;
    fileName = sprintf('obj%3.3d8obj.jpg',i);
    fullFileName = fullfile('E://8th semester/Thesis/Bangla-Handwritten-Character-Recognition/3.Characters',fileName);
    imwrite(objects,fullFileName,'jpg');
    %     figure;
%     imshow(props(i).Image);
end
% imshowpair(I,blobImg,'montage');
% axis on;