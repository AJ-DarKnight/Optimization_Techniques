clc;
clear all;

%Dual Simplex
%constraint should be <= sign and Obj Fn is Maxm

%Min Z=5x1+6x2 => Max Z= -5x1-6x2
%st. x1+x2>=2; 4x1+x2>=4; x1,x2>=0
%st=> -x1-x2<=-2; -4x1-x2 <= -4; x1,x2>=0

%example taken
%Max Z=-2x1-x3
%st. x1+x2-x3>=5; x1-2x2+4x3>=8; x1,x2,x3>=0
%st=> -x1-x2+x3<=-5; -x1+2x2-4x3<=-8; x1,x2,x3>=0

var={'x1','x2','x3','s1','s2','Soln'};
Cost=[-2 0 -1 0 0 0];
Info=[-1 -1 1; -1 2 -4];
b=[-5;-8];
s=eye(size(Info,1));

A=[Info s b];

%Start BFS
BV=[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end

%Zj-Cj
zjcj=Cost(BV)*A-Cost;

zj_cj=[zjcj; A];
SimplexTable=array2table(zj_cj);
SimplexTable.Properties.VariableNames(1:size(zj_cj,2))=var

RUN=true;
while RUN
    
sol=A(:,end);
if any(sol<0)
    fprintf('NOT Feasible\n');
    
    %Leaving Variable
    [lval, pivot_row]=min(sol);
    fprintf('Leaving Row is %d\n',pivot_row);
    
    %Entering Variable
    row=A(pivot_row, 1:end-1);
    ZJ=zjcj(:,1:end-1);
    
    for i=1:size(row,2)
        if row(i)<0
            ratio(i)=abs(ZJ(i)./row(i));
        else
            ratio(i)=inf;
        end
    end
    
    [mval, pivot_col]=min(ratio);
    fprintf('Entering Column is %d\n',pivot_col);
    
    %Updating BV
    BV(pivot_row)=pivot_col;
    fprintf('Basic Variables (BV)');
    disp(var(BV));
    
    %Pivot Key
    key=A(pivot_row,pivot_col);
    A(pivot_row,:)=A(pivot_row,:)./key;
    
    %Update for next iteration
    for i=1:size(A,1)
        if i~=pivot_row
            A(i,:)=A(i,:)-A(i,pivot_col).*A(pivot_row,:);
        end
    end
    
    zjcj=Cost(BV)*A-Cost;
    zj_cj=[zjcj; A];
    SimplexTable=array2table(zj_cj);
    SimplexTable.Properties.VariableNames(1:size(zj_cj,2))=var
    
else
    RUN=false;
    BFS=zeros(1,size(A,2));
    BFS(BV)=A(:,end);
    BFS(end)=sum(BFS.*Cost);
    Optimal_BFS=array2table(BFS);
    Optimal_BFS.Properties.VariableNames(1:size(Optimal_BFS,2))=var
    fprintf('FEASIBLE & OPTIMAL\n');
end
end
