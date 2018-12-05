

%% Initial Testing for matlab model 

% iniitial testing with a very simple model of network with only 5 neurons.
% All neurons have two ouptuts and one input except for the 5th neuron
% which has three inputs.

%from   
%    to n1 n2 n3 n4 n5
% n1        *
% n2           *  
% n3     *        *
% n4        *        *
% n5     *     *

W = [ 
        0 1 0 0 0;
        0 0 1 0 0;
        1 0 0 1 0;
        0 1 0 0 1;
        1 0 1 0 0];

%% definition of each neuron

c=0.04; % threshold constant
D=0.07; % decay constant
Sfire=1.5;

a=1; % time-to-fire constats
b=0;

%n1
S1=rand(1,1);
Sth1=1+c;
A1=2*rand(1,1)-1;
W1=rand(1,1);

%n2
S2=rand(1,1);
Sth2=1+c;
A2=2*rand(1,1)-1;
W2=rand(1,1);

%n3
S3=rand(1,1);
Sth3=1+c;
A3=2*rand(1,1)-1;
W3=rand(1,1);

%n4
S4=rand(1,1);
Sth4=1+c;
A4=2*rand(1,1)-1;
W4=rand(1,1);

%n5
S5=rand(1,1);
Sth5=1+c;
A5=2*rand(1,1)-1;
W5=rand(1,1);

%% simulation
Events=[]; %init event list
t=0; %init time

if(S1>Sth1)
  
  S1_=S1;
  
elseif(S1<Sth1)
  
  
  if(S1_>Sth1)
    ttF=a/(S-1)-b;
    addEvent(1,ttF);
  end
end


function addEvent(neuronN,ttf)

Events=cat(Events,[neuronN,ttf]);

end





