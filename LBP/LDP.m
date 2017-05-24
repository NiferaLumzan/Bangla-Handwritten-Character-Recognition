function result=ldp(I)
%Kirsch Mask
m0=[-3 -3 5;-3 0 5;-3 -3 5];
m1=[-3 5 5;-3 0 5;-3 -3 -3];
m2=[5 5 5;-3 0 -3;-3 -3 -3];
m3=[5 5 -3;5 0 -3;-3 -3 -3];
m4=[5 -3 -3;5 0 -3;5 -3 -3];
m5=[-3 -3 -3;5 0 -3;5 5 -3];
m6=[-3 -3 -3;-3 0 -3;5 5 5];
m7=[-3 -3 -3;-3 0 5;-3 5 5];
Iin=double(I);
[row,col]=size(I);
result=zeros(row,col);
b0=abs(filter2(m0,Iin));
b1=abs(filter2(m1,Iin));
b2=abs(filter2(m2,Iin));
b3=abs(filter2(m3,Iin));
b4=abs(filter2(m4,Iin));
b5=abs(filter2(m5,Iin));
b6=abs(filter2(m6,Iin));
b7=abs(filter2(m7,Iin));
for i=1:row
    for j=1:col
        codebit=zeros(1,8);
        t(1,1)=1;
        t(1,2)=b7(i,j);
        t(2,1)=2;
        t(2,2)=b6(i,j);
        t(3,1)=3;
        t(3,2)=b5(i,j);
        t(4,1)=4;
        t(4,2)=b4(i,j);
        t(5,1)=5;
        t(5,2)=b3(i,j);
        t(6,1)=6;
        t(6,2)=b2(i,j);
        t(7,1)=7;
        t(7,2)=b1(i,j);
        t(8,1)=8;
        t(8,2)=b0(i,j);
        t=sortrows(t,2);
        codebit(t(8,1))=1;
        codebit(t(7,1))=1;
        codebit(t(6,1))=1;
        result(i,j)=bin2dec(num2str(codebit));
    end
end
end%end of function 