
value_of_moments= zeros(7,1);
result = struct('Name',{'o_12.jpg'},'Actions',{'Original','Half sized','90 degree','180 degree'},...
    'm',value_of_moments);



%-----------------------------------------------------------------------%
%------------------------image pre processing---------------------------%
%-----------------------------------------------------------------------%
im = imread('o_12.jpg');
IM = imresize(im,[255,255]);
IM = rgb2gray(IM);
IM = medfilt2(IM);
% [m,n] = size(IM);
M = mean(IM);
t = graythresh(IM);
Iblur = imgaussfilt(IM, 1);
IM = Iblur;
T = adaptthresh(IM, 0.7);   %used adaptthresh to determine threshold to use in binarization operation.
BW = imbinarize(IM,T);  %Convert image to binary image, specifying the threshold value.

%----------------erosion-----------------------------%
se = strel('line',4,10);
erodedI = imerode(BW,se);

%-----------------dilation---------------------------%
se1 = strel('line',4,10);
BW2 = imdilate(erodedI,se1);
%-----------------------------seven moment apply-----------%
a= BW2;
a_half = imresize(a,0.5);
a_rotate_90_degree = imrotate(a,90);
a_rotate_180_degree = imrotate(a,180);

subplot(2,2,1), imshow(a)
subplot(2,2,3), imshow(a_rotate_90_degree)
subplot(2,2,4), imshow(a_rotate_180_degree)

format long
result(1).m = invmoments(a)
result(2).m = invmoments(a_half)
result(3).m = invmoments(a_rotate_90_degree)
result(4).m = invmoments(a_rotate_180_degree)

%     a_inv_mom_normal = -sign(a_inv_mom).*(log10(abs(a_inv_mom)));
%     a_half_inv_mom_normal = -sign(a_half_inv_mom).*(log10(abs(a_half_inv_mom)));
%     a_rotate_9_degree_inv_mom_normal = -sign(a_rotate_9_degree_inv_mom).*(log10(abs(a_rotate_9_degree_inv_mom)));
%     a_rotate_45_degree_inv_mom_normal = -sign(a_rotate_45_degree_inv_mom).*(log10(abs(a_rotate_45_degree_inv_mom)));
%     format long
% Results(1,:) = a_inv_mom;
% Results(2,:) = a_half_inv_mom;
% Results(3,:) = a_rotate_9_degree_inv_mom;
% Results(4,:) = a_rotate_45_degree_inv_mom;
% writetable(struct2table(result,'AsArray',true),'sevenMoment_o_12.xlsx'); 
%     plot(Results);
