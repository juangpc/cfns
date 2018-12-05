function S = generateNetworkState(n,W)

c=0.04; % threshold constant
Smax=10;
Sth=1+c;
% D=0.07; % decay constant

% 
% a=1; % time-to-fire constats
% b=0;

S = cell(n,1);

for i = 1 : n
  S=rand(1,1)*Smax;
  A=W(i,:);
  for j = 1 : length(A);
  
 
end



