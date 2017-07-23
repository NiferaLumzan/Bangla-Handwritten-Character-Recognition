
inputImageName = 'set_2.jpg'; 
img = imread(inputImageName);
% img = imresize(img,[500,1000]);
img = rgb2gray(img);
img = medfilt2(img);
T = adaptthresh(img, 0.7);  
img = imbinarize(img,T);
img = imcomplement(img); 
[row, column] = size(img);
imshow(img);
axis on;

rowSum = zeros(1,row); 
for i = 1:row  
    r = 0;
    for j = 1:column
        r = r + img(i,j);
    end
    rowSum(i) = r;    
end

minimum = min(rowSum);
finish = 0;  
% isFirst = 0; 
% trackFinish = 0; 
for i = 1:row-1    
    if(i <= finish)
       continue;  
    else
        lineRows = 0;   
        if( rowSum(i) < 10 && rowSum(i) < rowSum(i+1))            
            for j = i+1:row
%                 [value, loc] = min(rowSum(j:row)); 
                if(rowSum(j)> 8 )                    
                    lineRows = lineRows +1; 
                else
                    if(lineRows < 40)
                       continue; 
                    else
                        init = i;
                        finish = j;
                        line = zeros(lineRows,column);
                        break;
                    end
                end
            end     
            n=1;
            for k = init:finish 
                for l = 1:column  
                    if(k <= init+8 && rowSum(k) < 10)
                        continue;
                    else
                        line(n,l) = img(k,l);
                    end
                end
                n = n+1;
            end 
            objects = line;
            outputImageName = '%s%d.jpg';
            fileName = sprintf(outputImageName,inputImageName,finish);
            fullFileName = fullfile('E://8th semester/Thesis/Bangla-Handwritten-Character-Recognition/1.Lines',fileName);
            imwrite(objects,fullFileName,'jpg');
        end        
%         if(trackFinish ~= finish)
%             trackFinish = finish; 
%             isFirst = 1; 
%         else
%             isFirst = 0;
%         end        
    end     
end



