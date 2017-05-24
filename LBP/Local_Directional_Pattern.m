im = imread('ko_1.jpg');
IM = imresize(im,[255,255]);
IM = rgb2gray(IM);
% IM = medfilt2(IM);
% % [m,n] = size(IM);
% M = mean(IM);
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
BW2 = imdilate(erodedI,se1);

result = LDP(BW2);
imshowpair(IM,result,'montage');