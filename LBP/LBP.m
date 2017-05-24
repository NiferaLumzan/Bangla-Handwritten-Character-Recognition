im = imread('o_1.jpg');
im1 = imread('ko_1.jpg');
IM = imresize(im,[255,255]);
IM1 = imresize(im1,[255,255]);
IM = rgb2gray(IM);
IM1 = rgb2gray(IM1);
IM = medfilt2(IM);
IM1 = medfilt2(IM1);
% [m,n] = size(IM);
M = mean(IM);
M1 = mean(IM1);
t = graythresh(IM);
t1 = graythresh(IM1);
Iblur = imgaussfilt(IM, 1);
Iblur1 = imgaussfilt(IM1, 1);
IM = Iblur;
IM1 = Iblur1;
T = adaptthresh(IM, 0.7);   %used adaptthresh to determine threshold to use in binarization operation.
T1 = adaptthresh(IM1, 0.7); 
BW = imbinarize(IM,T);  %Convert image to binary image, specifying the threshold value.
BW1 = imbinarize(IM1,T1);

%----------------erosion-----------------------------%
se = strel('line',4,10);
erodedI = imerode(BW,se);
se1 = strel('line',4,10);
erodedI1 = imerode(BW1,se1);
%-----------------dilation---------------------------%
se1 = strel('line',4,10);
BW2 = imdilate(erodedI,se1);
se12 = strel('line',4,10);
BW3 = imdilate(erodedI1,se12);

imshowpair(BW2,BW3,'montage');

lbpBricks1 = extractLBPFeatures(BW2,'Upright',false);
lbpBricks2 = extractLBPFeatures(BW3,'Upright',false);
brickVsBrick = (lbpBricks1 - lbpBricks2).^2;

figure
bar([lbpBricks1; lbpBricks2]','grouped')
title('Squared Error of LBP Histograms')
xlabel('LBP Histogram Bins')
legend('Bricks vs Rotated Bricks','Bricks vs Carpet')




