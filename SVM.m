
load ZernikeData.txt;
original = ZernikeData(:,2:3);
image = ZernikeData(:,1); 
SVMStruct = svmtrain(original,image,'ShowPlot',true);
xnew = [
0.000536467	-117.1772193
];


images = svmclassify(SVMStruct, xnew,'ShowPlot',true);
hold on;
plot(xnew(:,1),xnew(:,2),'ro','MarkerSize',12);
hold off

% load fisheriris
% xdata = meas(51:end,3:4);
% group = species(51:end);
% figure;
% svmStruct = svmtrain(xdata,group,'ShowPlot',true);
% Xnew = [5 2; 4 1.5];
% species = svmclassify(svmStruct,Xnew,'ShowPlot',true)
% hold on;
% plot(Xnew(:,1),Xnew(:,2),'ro','MarkerSize',12);
% hold off