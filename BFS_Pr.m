clc;
clear all;
%max z=2x1+3x2+4x3+7x4 : st : 2x1+3x2-x3+4x4=8 ; x1-2x2+6x3-7x4=-3 (make it non-negative) ; x1>=0
A=[2 3 -1 4; -1 2 -6 7];
B=[8; 3];
C=[2 3 4 7];
n=size(A,2) %variable=no of columns
m=size(A,1) %constraints=no of rows

%command for nCm Combn
ns=nchoosek(n,m)  %total basic solution
t=nchoosek(1:n,m) %pairs of basic solution

SOL=[]

for i=1:ns
    Y=zeros(n,1)
    f=t(i,:)
    B1=A(:,t(i,:))
    X=inv(B1)*B
    
    %for feasible soln positive vals
    if X>=0 & X~=inf & X~=-inf
        Y(t(i,:))=X
        SOL=[SOL Y]
    end
end

Z=C*SOL %Objective Function
[zMax, zIndx]=max(Z)
bfs=SOL(:,zIndx) %optimal BFS value

opt_value=[bfs' zMax]
opt=array2table(opt_value)
opt.Properties.VariableNames(1:size(opt_value,2))={'x1','x2','x3','x4','soln'}