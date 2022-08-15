%Represent the given LPP in Tabular form as well find all basic feasible solutions of the given LPP

clc;
clear all;
c=[4 3 0 0 ];
a=[1 1;2 1];
B=[8;10];

sign=[0 0];
s=eye(size(a,1));
ind=find(sign>0);
s(ind,:)=-s(ind,:);

A=[a s];

m=size(A,1);   %Number of equations
n=size(A,2);   %Number of variables

mat= [a s B];
cons=array2table(mat);
cons.Properties.VariableNames(1:size(mat,2))={'x1','x2','s1','s2','B'}

if(n>m)
    nv=nchoosek(n,m);
    t=nchoosek(1:n,m);
    
    sol=[];
    for i=1:nv
        y=zeros(n,1);
        x=A(:,t(i,:))\B;
        y(t(i,:))=x;
        if all(x>=0 & x~=inf & x~=-inf)
            sol=[sol y];
            
        end
    end
else
    error('Solution Does not Exist');
end
z=c*sol;
[zmax,zind]=max(z);
BFS=sol(:,zind);

optimal=array2table(BFS)