%Constraint Code

function result=Graphical_Method_Fnc_Constraint(X) %Fnc name is same as file name

X1=X(:,1)
X2=X(:,2)

c1=round(X1+2.*X2-10) %x1+2x2<=10
h1=find(c1>0) %violating < sign
X(h1,:)=[] %putting it as null or deleting the values

X1=X(:,1)
X2=X(:,2)
c2=round(X1+X2-6) %x1+x2<=6
h2=find(c2>0)
X(h2,:)=[]

X1=X(:,1)
X2=X(:,2)

c3=round(X1-2.*X2-1) %x1-2x2<=1
h3=find(c3>0)
X(h3,:)=[]

result=X
end




