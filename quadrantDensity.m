function [qd1,qd2,qd3,qd4] = quadrantDensity(I1,I2,I3,I4)
    
[k,l] = size(I1);
[o,p] = size(I2);
[q,r] = size(I3);
[s,t] = size(I4);

% for I1
totalPixelOfSkeleton = 0;
for i = 1:k
    for j = 1:l
        if(I1(i,j)== 1)
            totalPixelOfSkeleton = totalPixelOfSkeleton +1; 
        end
    end
end
qd1 = (k*l)/totalPixelOfSkeleton;

% for I2
totalPixelOfSkeleton = 0;
for i = 1:o
    for j = 1:p
        if(I2(i,j)== 1)
            totalPixelOfSkeleton = totalPixelOfSkeleton +1; 
        end
    end
end
qd2 = (k*l)/totalPixelOfSkeleton;

% for I3
totalPixelOfSkeleton = 0;
for i = 1:q
    for j = 1:r
        if(I3(i,j)== 1)
            totalPixelOfSkeleton = totalPixelOfSkeleton +1; 
        end
    end
end
qd3 = (k*l)/totalPixelOfSkeleton;

% for I4
totalPixelOfSkeleton = 0;
for i = 1:s
    for j = 1:t
        if(I4(i,j)== 1)
            totalPixelOfSkeleton = totalPixelOfSkeleton +1; 
        end
    end
end
qd4 = (k*l)/totalPixelOfSkeleton;

end