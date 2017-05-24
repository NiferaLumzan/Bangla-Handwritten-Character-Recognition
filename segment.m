function[I1,I2,I3,I4] = segment(BW4)

I1=BW4(1:size(BW4,1)/2,1:size(BW4,2)/2,:);
I2=BW4(size(BW4,1)/2+1:size(BW4,1),1:size(BW4,2)/2,:);
I3=BW4(1:size(BW4,1)/2,size(BW4,2)/2+1:size(BW4,2),:);
I4=BW4(size(BW4,1)/2+1:size(BW4,1),size(BW4,2)/2+1:size(BW4,2),:);
end