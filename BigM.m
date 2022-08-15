clc;
clear all;

%Big M
%Minimization to Maximization by multiplying with -1
%Min Z=2x1+x2 => Max Z= -2x1-x2-MA1-MA2 (where M>=0 and a huge number)
%st 3x1+x2=3; 4x1+3x2>=6; x1+2x2<=3; x1,x2>=0
%st => 3x1+x2+A1=3; 4x1+3x2-s2+A2=6; x1+2x2+s3=3; x1,x2,s2,s3,A1,A2>=0

var={'x1','x2','s2','s3','A1','A2','Soln'};

M=1000; %a large number we can assign any

Cost=[-2 -1 0 0 -M -M 0];
A=[3 1 0 0 1 0 3; 4 3 -1 0 0 1 6; 1 2 0 1 0 0 3];

s=eye(size(A,1));

%To find starting BFS

BV=[]; %directly to col value of A1 A2 i.e. BV=[5 6 4]
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end

%Initial Table
B=A(:,BV);
A=inv(B)*A;
zjcj=Cost(BV)*A-Cost;

zc=[zjcj; A];
SimplexTable=array2table(zc)
SimplexTable.Properties.VariableNames(1:size(zc,2))=var

RUN=true;
while RUN
ZC=zjcj(:,1:end-1);
if any(ZC<0)
    fprintf('Current BFS is NOT Optimal');
    
    %Entering Variable
    [evar, pivot_col]=min(ZC);
    fprintf('Entering Column %d\n',pivot_col);
    
    %Leaving Variable
    sol=A(:,end);
    col=A(:,pivot_col);
    
    if all(col)<=0
        fprintf('Unbounded');
    else
        for i=1:size(col,1)
            if col(i)>0
                ratio(i)=sol(i)./col(i);
            else
                ratio(i)=inf;
            end
        end
        [minR, pivot_row]=min(ratio);
        fprintf('Leaving Row is %d \n',pivot_row);
    end
    
    %Update BV and Table
    BV(pivot_row)=pivot_col;
    
    B=A(:,BV);
    A=inv(B)*A;
    zjcj=Cost(BV)*A-Cost;
    
    %New Table
    ZC=[zjcj; A];
    Table=array2table(ZC)
    Table.Properties.VariableNames(1:size(ZC,2))=var
        
else
    RUN=false;
    
    %Final Optimal
        BFS=zeros(1,size(A,2));
        BFS(BV)=A(:,end);
        BFS(end)=sum(BFS.*Cost);
        Current_BFS=array2table(BFS)
        Current_BFS.Properties.VariableNames(1:size(Current_BFS,2))=var

    fprintf('Optimal\n');
    
    end
end
