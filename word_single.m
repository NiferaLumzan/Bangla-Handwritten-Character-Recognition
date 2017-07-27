inputImageName = 'E:/8th semester/Thesis/Bangla-Handwritten-Character-Recognition/1.Lines/set_2.jpg2070.jpg';
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
rowSum = zeros(1,row); 

finish = 0;  
for i = 1:column-1
    if(i <= finish)
       continue;  
    else
        wordTotalColumn = 0;
        if(columnSum(i+1) > columnSum(i) && columnSum(i) == 0)
            init = i+1;
            countZeros = 0;            
            for j = init:column     % looking for end of a word
                if(columnSum(j) == 0)   
                    countZeros = countZeros +1; 
                end
                if(countZeros <= 8)                     
                    wordTotalColumn = wordTotalColumn + 1; %--wordTotalColumn->total column number in the word
                else                    
                    finish = j; %--finish->column of finishing line of word in line image               
                    break;
                end
            end
            %-- row sum is counting for perticular word area
            for p = 1:row  
                r = 0;
                for q = init:finish
                    r = r + img(p,q);
                end
                rowSum(p) = r;    
            end
            %-- counting blank space in upperside & lowerside of the image
            countUpperEmpty = 0;
            countLowerEmpty = 0;
            for p = 1:row
               if(rowSum(p) == 0)
                   countUpperEmpty = countUpperEmpty + 1;
               else
                   break;
               end
            end 
            for p = row:-1:1
               if(rowSum(p) == 0)
                   countLowerEmpty = countLowerEmpty+1;
               else
                   break;
               end               
            end
            %----creating word matrix (frame) for new image
            if(countUpperEmpty > 0 && countLowerEmpty > 0)
                word = zeros(row-(countUpperEmpty+countLowerEmpty),wordTotalColumn);
            elseif(countLowerEmpty > 0)
                    word = zeros(row-countLowerEmpty,wordTotalColumn);                
            elseif(countUpperEmpty > 0)
                word = zeros(row-countUpperEmpty,wordTotalColumn);
            else
                word = zeros(row,wordTotalColumn);
            end
            %-- moving word into new image
            m = 1;
            for k = countUpperEmpty+1:row-countLowerEmpty
                n = 1;
                for l = init:finish
                   word(m,n) = img(k,l);
                   n = n+1;
                end
                m = m+1;
            end  
            %------ naming and saveing images
            emptyWord = isempty(word);            
            if(emptyWord == 0)
                objects = word;
                outputImageName = '%d%d.jpg';
                fileName = sprintf(outputImageName,i,finish);
%                 fullFileName = fullfile('E://8th semester/Thesis/Bangla-Handwritten-Character-Recognition/2.Words',fileName);
%                 imwrite(objects,fullFileName,'jpg');
            end
        end
    end
end