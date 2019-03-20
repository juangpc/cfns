function [W,D,A]=generateNetworkConnectionsToK(n,f)

%connectivity matrix
%connectivity is from ROW to COLUMN!!!!

%n= number of neurons
%f= fan out

%W=postsynapse
%D=axonal delay
%A=presynapse

W=rand(n);
W(1:n+1:end)=0;%main diagonal = 0
W(W<(1-f/n))=0;


D=rand(n);
D(1:n+1:end)=0; %main diagonal = 0

A=rand(n)*2-ones(n);
A(1:n+1:end)=0;

end

