clc;
clear all;

%Simplex
%Firstly, we transform Minimization to Maximization
%eg. Min Z = x1 - 3x2 + 2x3 => Max Z = -x1 + 3x2 - 2x3
%st 3x1 - x2 + 2x3 <= 7; -2x1 + 4x2 <=12; -4x1 + 3x2 + 8x3 <= 10;
%x1,x2,x3>=0

Info=[3 -1 2; -2  4 0; -4 3 8];
b=[7; 12; 10];

%slack variable to create an Identity Matrix of size equal to number of rows or constraints
s=eye(size(Info,1)); %rows of Info i.e. Constraints

A=[Info s b]

%Cost can be Cost=zeros(size(A,2)); Cost(1:Noofvariables)=C;
%where
%Noofvariables=3 or as follows
%here we have taken C as Cost already
C=[-1 3 -2 0 0 0 0];

%Basic Variables are the slack ones to be taken
%No. of Variables+1 till last
BV=4:size(A,2)-1 %S1 S2 S3 => zj-cj

%for Zj-Cj Row
zjcj=C(BV)*A-C %initial

%for Zj-Cj Table
zj_cj=[zjcj; A]

SimplexTable=array2table(zj_cj)
SimplexTable.Properties.VariableNames(1:size(zj_cj,2))={'x1','x2','x3','s1','s2','s3','Soln'}

RUN=true;
while RUN
    
if any(zjcj<0) %for negative value if there is then proceed else we get optimal readily
    %[minv, minidx]=min(zjcj(1:size(A,2)-1) %not to take in soln value as that we do not require
    
    %Entering Variable is the most minimum value

    ZC=zjcj(1:end-1);
    [var, pivot_col]=min(ZC);
    fprintf('Minimum Element of Zj-Cj row is %d and the Pivot Column is %d\n',var,pivot_col);
    
    %Minimum Ratio is subsequent soln values divided by the pivot column values like 7/-1, 12/4, 10/3
    
    %Leaving Variable
    sol=A(:,end); %for Solution column
    col=A(:,pivot_col);
    
    if all(col<=0)
        error('LPP Unbounded. All entries <=0 in column %d',pivot_col);
    else%for Row
        %ratio=sol./col element wise however we do not want to encounter -ve values neither 0 for the minimum subsequently so we will use the following method
        
        for i=1:size(col,1)
            if col(i)>0
                ratio(i)=sol(i)./col(i);
            else
                ratio(i)=inf;
            end
        end
        
        [minratio, pivot_row]=min(ratio);
        fprintf('Minimum Ratio corresponding to Pivot Row is %d \n',pivot_row);
        fprintf('Leaving Variable is %d \n',BV(pivot_row));
    end
    
    BV(pivot_row)=pivot_col;
    disp('New Basic Variables :');
    disp(BV)
    
    %For Pivot key
    key=A(pivot_row,pivot_col);
    
    %for next iteration update will be for all values but pivot row
    A(pivot_row,:)=A(pivot_row,:)./key; %we have o make all column value 0 for this pivot so we will perform the subsequent 
    
    for i=1:size(A,1)
        if i~=pivot_row
            A(i,:)=A(i,:)-A(i,pivot_col).*A(pivot_row,:);
        end
        zjcj=zjcj-zjcj(pivot_col).*A(pivot_row,:);
        
        %New Table
        ZC=[zjcj; A];
        Table=array2table(ZC)
        Table.Properties.VariableNames(1:size(ZC,2))={'x1','x2','x3','s1','s2','s3','Soln'}
        
        BFS=zeros(1,size(A,2));
        BFS(BV)=A(:,end);
        BFS(end)=sum(BFS.*C);
        Current_BFS=array2table(BFS)
        Current_BFS.Properties.VariableNames(1:size(Current_BFS,2))={'x1','x2','x3','s1','s2','s3','Soln'}
        
    end
    
else
    RUN=false;
    disp('Optimal Solution')
end
end

