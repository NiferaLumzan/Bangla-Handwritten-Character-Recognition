inputImageName = 'set_1.jpg397 (2).jpg'; 
img = imread(inputImageName);
img = imcomplement(img); 
% T = adaptthresh(img, 0.1);  
img = imbinarize(img);
img = imcomplement(img); 
[row, column] = size(img);
imshow(img);
axis on;

columnSum = zeros(1,column); 
for i = 1:column  
    col = 0;
    for j = 1:row
        col = col + img(j,i);
    end
    columnSum(i) = col;    
end

finish = 0;  
for i = 1:column-1
    if(i <= finish)
       continue;  
    else
        wordColumn = 0;
        if(columnSum(i+1) > columnSum(i) && columnSum(i) == 0)
            init = i+1;
            countZeros = -1;
            for j = i+1:column
                if(columnSum(j) == 0)
                    countZeros = countZeros +1;
                end
                if(countZeros < 5)                    
                    wordColumn = wordColumn + 1; 
                else
                    finish = j;
                    word = zeros(row,wordColumn);
                    break;
                end
            end            
            
%             rowSum = zeros(1,row); 
%             for p = 1:row  
%                 r = 0;
%                 for q = init:finish
%                     r = r + word(p,q);
%                 end
%                 rowSum(p) = r;    
%             end
%             countZeros = 0;
%             for p = 1:row
%                if(rowSum(p)== 0)
%                    countZeros = countZeros + 1; 
%                else
%                    break;                    
%                end
%             end
            for k = 1:row
                n=1;
                for l = init:finish  
                   word(k,n) = img(k,l);
                   n = n+1;
                end
            end
            
            objects = word;
            outputImageName = '%d.jpg';
            fileName = sprintf(outputImageName,finish);
            fullFileName = fullfile('E://8th semester/Thesis/Bangla-Handwritten-Character-Recognition/2.Words',fileName);
            imwrite(objects,fullFileName,'jpg');
        end
    end
end
    
    