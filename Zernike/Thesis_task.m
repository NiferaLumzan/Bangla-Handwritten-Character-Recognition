%-----------------------------------------------------------------------%
%---------------------------Zernike Moment------------------------------%
%-----------------------------------------------------------------------%
%-----------creating structure for zernike moment-----------------------%
value_of_original = zeros(1,2);
value_of_nine= zeros(1,2);
value_of_fortyfive = zeros(1,2);
value_of_fifty= zeros(1,2);
value_of_ninety = zeros(1,2);
value_of_ninetyfive = zeros(1,2);
result = struct('Name',{},'Z',{},'original',value_of_original,'nine',value_of_nine,...
    'fortyfive',value_of_fortyfive,'fifty', value_of_fifty,'ninety', value_of_ninety,...
    'ninetyfive',value_of_ninetyfive);
z = 1;
result_count = 1; 
%-----------------------------------------------------------------------%
%--Reading multiple images from a folder and apply zernike--------------%
%-----------------------------------------------------------------------%
jpegFiles = dir('*.jpg'); %putting .jpg files into jpegFiles
numfiles = length(jpegFiles);
mydata = cell(1, numfiles); 
for k = 1:numfiles
    mydata{k} = imread(jpegFiles(k).name); 
    im = mydata{k};
    %-----------------------------------------------------------------------%
    %------------------------image pre processing---------------------------%
    %-----------------------------------------------------------------------%
    % im = imread('o_2.jpg');
    IM = imresize(im,[255,255]);
    IM = rgb2gray(IM);
    IM = medfilt2(IM);
    % [m,n] = size(IM);
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
    BW2 = imdilate(erodedI,se1);

    %------------edge detection(canny)-------------------%
    % p_edge = edge(BW2, 'Sobel');
    % BW3 = bwareaopen(imfill(p_edge, 'holes'),5);
    BW3 = edge(BW2,'Canny');


    %------finding 8 order zernike moment featurs for each images-----------%
    
    for i = 1:9
        for j = 1:9
            if(j <= i) %as in Redial polynomials[278 of chp 12] repetition is less than order 
                r = rem(i,2);
                s = rem(j,2);
                if(r == 0 && s == 0)%even order needs even repetition of Zernike.                     
                    im_name = jpegFiles(k).name;
                    result= applyZernike(result,BW3,result_count,im_name,i,j);
                    result_count = result_count+1;        %increment of the value of Z
                end
                if(r ~= 0 && s ~= 0)                   
                   	im_name = jpegFiles(k).name;
                    result= applyZernike(result,BW3,result_count,im_name,i,j);                    
                    result_count = result_count+1;        %increment of the value of Z
                end
            end
        end
    end
end

%-------------------------------File saved into xlMS file --------------------------%
% save('newstruct.mat', 'struct', 'result');
writetable(struct2table(result,'AsArray',true),'ZernikeBetweenSixLetters.xlsx'); 




