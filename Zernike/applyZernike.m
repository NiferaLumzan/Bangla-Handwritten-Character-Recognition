function [result] = applyZernike(result,BW3,z,im_name,n,m)
                    
                    result(z).Name = im_name;
                    result(z).Z = {n-1,m-1};
                    p = BW3;
    %                 figure(1);subplot(2,3,1);imshow(p);
    %                 title('0 degree rotated');
                    p = logical(not(p));
                    [~, AOH, PhiOH] = Zernikmoment(p,n,m);      % Call Zernikemoment fuction
                    result(z).original = {AOH, PhiOH };    %assign the value of A & phi into the structure element
    %                 xlabel({['A = ' num2str(AOH)]; ['\phi = ' num2str(PhiOH)]});

                    p = imrotate(BW3,9);  %-----------9 degree rotated ------------%
    %                 figure(1);subplot(2,3,2);imshow(p);
    %                 title('9 degree rotated');
                    p = logical(not(p));
                    [~, AOH, PhiOH] = Zernikmoment(p,n,m);      % Call Zernikemoment fuction
                    result(z).nine = {AOH, PhiOH };    %assign the value of A & phi into the structure element
    %                 xlabel({['A = ' num2str(AOH)]; ['\phi = ' num2str(PhiOH)]});

                    p = imrotate(BW3,45);  %----------- -45 degree rotated ------------%
    %                 figure(1);subplot(2,3,3);imshow(p);
    %                 title('45 degree rotated');
                    p = logical(not(p));
                    [~, AOH, PhiOH] = Zernikmoment(p,n,m);      % Call Zernikemoment fuction
                    result(z).fortyfive = {AOH, PhiOH };    %assign the value of A & phi into the structure element
    %                 xlabel({['A = ' num2str(AOH)]; ['\phi = ' num2str(PhiOH)]});

                    p = imrotate(BW3,50);  %-----------180 degree rotated ------------%
    %                 figure(1);subplot(2,3,4);imshow(p);
    %                 title('50 degree rotated');
                    p = logical(not(p));
                    [~, AOH, PhiOH] = Zernikmoment(p,n,m);      % Call Zernikemoment fuction
                    result(z).fifty = {AOH, PhiOH };    %assign the value of A & phi into the structure element
    %                 xlabel({['A = ' num2str(AOH)]; ['\phi = ' num2str(PhiOH)]});

                    p = imrotate(BW3,90);  %-----------90 degree rotated ------------%
    %                 figure(1);subplot(2,3,5);imshow(p);
    %                 title('90 degree rotated');
                    p = logical(not(p));
                    [~, AOH, PhiOH] = Zernikmoment(p,n,m);      % Call Zernikemoment fuction
                    result(z).ninety = {AOH, PhiOH };    %assign the value of A & phi into the structure element
    %                 xlabel({['A = ' num2str(AOH)]; ['\phi = ' num2str(PhiOH)]});

                    p = imrotate(BW3,95);  %-----------180 degree rotated ------------%
    %                 figure(1);subplot(2,3,6);imshow(p);
    %                 title('95 degree rotated');
                    p = logical(not(p));
                    [~, AOH, PhiOH] = Zernikmoment(p,n,m);      % Call Zernikemoment fuction
                    result(z).ninetyfive = {AOH, PhiOH };    %assign the value of A & phi into the structure element
    %                 xlabel({['A = ' num2str(AOH)]; ['\phi = ' num2str(PhiOH)]});
end