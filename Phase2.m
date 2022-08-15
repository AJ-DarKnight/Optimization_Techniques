clc;
clear all;

%2 Phase
%Firstly, we transform Minimization to Maximization
%eg. Min Z = 7.5x1 - 3x2 => Max Z = -7.5x1 + 3x2 - A1 - A2
%st 3x1 - x2 - x3 >= 7; x1 - x2 + x3 >= 2; x1,x2,x3 >=0
%st => 3x1-x2-x3-s1+A1=3; x1-x2+x3-s2+A2=2; x1,x2,x3,s1,s2,A1,A2,>=0

%var={'x1','x2','x3','s1','s2','A1','A2','Soln'};
%Ovar={'x1','x2','x3','s1','s2','Soln'};

var={'x1','x2','x3','s1','s2','A1','Soln'};
Ovar={'x1','x2','x3','s1','s2','Soln'};

%original C=[x1 x2 x3 s1 s2 A1 A2 Soln]
%orgC=[-7.5 3 0 0 0 -1 -1 0];
%Info=[3 -1 -1 -1 0 1 0 3; 1 -1 1 0 -1 0 1 2];
%BV=[6 7]; %A1 A2


orgC=[5 -4 3 0 0 1 0]
Info=[2 1 -6 0 0 1 20; 6 5 10 1 0 0 76; 8 -3 6 0 1 0 50]
BV=[6];

%Phase I
%Cost=[0 0 0 0 0 -1 -1 0]; %Cost of this 1stPhase Obj Fnn
Cost=[0 0 0 0 0 1];
A=Info;
StartBV=find(Cost<0); %To define Artificial Variables

[BFS,A]=Phase2_Fnc(A,BV,Cost,var);

%Phase II (removal of additional variable)

A(:,StartBV)=[]; %removal of artificial variable column
orgC(:,StartBV)=[]; %removal of artificial variable cost

[OptBFS, OptA]=Phase2_Fnc(A,BFS,orgC,Ovar);

FinalBFS=zeros(1,size(A,2));
FinalBFS(OptBFS)=OptA(:,end);
FinalBFS(end)=sum(FinalBFS.*orgC);

OptimalBFS=array2table(FinalBFS);
OptimalBFS.Properties.VariableNames(1:size(OptimalBFS,2))=Ovar;
