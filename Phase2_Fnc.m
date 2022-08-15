function[BFS,A]=Phase2_Fnc(A,BV,Cost,var) %Matrix, Basic Variable, Cost, Variable description

zjcj=Cost(BV)*A-Cost;
%first row corresponds to zj-cj

RUN=true;
while RUN
    
ZC=zjcj(1:end-1); %last column is solution and we do not need that here

if any(ZC<0)
    %Entering Variable is for most negative variable
    [evar, pivot_col]=min(ZC);
    fprintf('Entering Column is %d\n',pivot_col);
    
    %Leaving Variable
    sol=A(:,end);
    col=A(:,pivot_col);
    
    if col<0
        fprintf('Unbounded');
    else
        for i=1:size(A,1)
            if col(i)>0
                ratio(i)=sol(i)./col(i);
            else
                ratio(i)=inf;
            end
        end
    end
    
    [minr, pivot_row]=min(ratio);
    fprintf('Leaving Row is %d\n',pivot_row);
    
    %Updating BFS
    BV(pivot_row)=pivot_col;
    
    key=A(pivot_row,pivot_col); %Pivot Key
    
    %New Entries
    A(pivot_row,:)=A(pivot_row,:)./key;
    
    for i=1:size(A,1)
        if i~=pivot_row
            A(i,:)=A(i,:)-A(i,pivot_col).*A(pivot_row,:);
        end
    end
    
    zjcj=zjcj-zjcj(pivot_col).*A(pivot_row,:);
    
    
    BFS=[zjcj;A];
    Table=array2table(BFS);
    Table.Properties.VariableNames(1:size(A,2))=var
    
    %updating for iteration
    BFS(BV)=A(:,end);
    
else
    RUN=false;
    fprintf('Optimal Solution\n');
end
end
