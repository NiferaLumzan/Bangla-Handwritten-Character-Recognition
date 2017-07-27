img = imread('E:/8th semester/Thesis/Bangla-Handwritten-Character-Recognition/2.Words/1 (2).jpg');
        % I = img; 
        % img = rgb2gray(img);
        img = imbinarize(img);
        % img = imcomplement(img);
%         img = imresize(img, [64,128]); 
        [row, column] = size(img);
        I = img; 
        
        %------ rowsum  ------------%
        rowSum = zeros(1,row); 
        for i = 1:row  
            r = 0;
            for j = 1:column
                r = r + img(i,j);
            end
            rowSum(i) = r;    
        end      
        %---------- separation  --------------%
        
        % MATRA TA DHORTE HOBE. MATRA THEKE BAKI IMAGE ER 50 PERCENT ER
        % MODHE MINIMUM COLUMN GULA 0 KORE DITE HOBE.       
        setUpperMatra = 1;
        s = 0;
        s1 = 0;
        s3 = floor(row/1.5)-2;
        for x = 1:floor(row/1.5)-2
           count = 0;
           if(rowSum(x+2) > rowSum(x)*2 || rowSum(x+1) > rowSum(x)*2)
               s = s+1;
               slocation = x;
               for y = 1:5
                   if(rowSum(x)*1.5 < rowSum(x+y) ) 
                       count = count+1;
                   end
               end
               if(count >= 5 )
                   s1 = s1+1;
                   s2 = count;
                   setUpperMatra = x;  
%                    break;
               end
           end
        end
        %---- column sum according to setUpperMatra ----------%
        columnSum = zeros(1,column); 
        for i = 1:column  
            col = 0;
            for j = setUpperMatra:row
                col = col + img(j,i);
            end
            columnSum(i) = col;    
        end  
        %find the minimum value from the columnSum and eleminate
        %the corresponding stroke from the image
        minimum = min(columnSum); 
        for x = 1:column
            [k,l] = min(columnSum(1:column));
            if(k < minimum+8)
                columnSum(l) = 999999;
                for i = setUpperMatra:(row/2+10)
                    img(i,l) = 0;
                end
            end
        end
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

%         imshow(blobImg);
%         axis on;
        img = rgb2gray(blobImg);
        img = imbinarize(img);
        img = bwareaopen(img, 50);
        cc = bwconncomp(img);
        props = regionprops(cc, 'I');
%         for i = 1:cc.NumObjects
%             objects = props(i).Image;
%             fileName = sprintf('%d%d.jpg',image,i);
%             fullFileName = fullfile('E://8th semester/Thesis/Bangla-Handwritten-Character-Recognition/3.Characters',fileName);
%             imwrite(objects,fullFileName,'jpg');
%         end
        imshowpair(I,blobImg,'montage');
        axis on;  