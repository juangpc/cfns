function [W,D,A]=generateNetworkConnections(n)

%connectivity matrix
%connectivity is from ROW to COLUMN!!!!

%A=presynapse
%W=postsynapse
%D=axonal delay

W=rand(n);
W(1:n+1:end)=0;

D=rand(n);
D(1:n+1:end)=0;

A=rand(n)*2-ones(n);
A(1:n+1:end)=0;

end

