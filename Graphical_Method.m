clc;
clear all;
%Max : 2x1 + 1x2 : x1+2x2<=10; x1+x2<=6; x1-2x2<=1
A=[1 2; 1 1; 1 -2; 1 0; 0 1];
B=[10; 6; 1; 0; 0];
C=[2 1]
p=[0; 0] %points

for i=1:5
    A1=A(i,:);
    B1=B(i,:);
    
    for j=i+1:5
        A2=A(j,:);
        B2=B(j,:);
        
        A4=[A1; A2];
        B4=[B1; B2];
        
        X=inv(A4)*B4
        X=max(0,X)
        p=[p X];
    end
end

pp=p'
point=unique((pp), 'rows') %no repetition of any values

PT=Graphical_Method_Fnc_Constraint(point) 
for i=1:size(PT,1)
    fnc(i,:)=sum(PT(i,:).*C)
end

sol=[PT fnc] %X1 X2 Z

[xval, ind]=max(fnc) %min then min statement
optv=sol(ind,:)
OPTIMAL_BFS=array2table(optv) %table form
