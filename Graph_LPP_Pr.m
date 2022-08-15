clc;
clear all;
%x1+2x2<=2000; x1+x2<=1500; x2<=600
A=[1 2; 1 1; 0 1]; %coeff of x1 is zero
B=[2000; 1500; 600];
y=0:1:max(B) %taking till the maximum %also can use y=0:1:max(B)
for i=1:1:3
    x=(B(i) - (A(i,1).*y))./A(i,2) %. operator for element wise 
    x=max(0,x) %domain and to not include -ve values
    hold on;
    plot(y,x)
    hold off;
end