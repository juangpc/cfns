
clear all,

%% attempt to 


%define network properties
n=100; %number of neurons
t=0; %global time
maxSimTime=100; % milliseconds

%build network
[net1.W,net1.Dlay,net1.A]=generateNetworkConnectionsToK(n,70);
%A=presynapse
%W=postsynapse
%Dlay=axonal delay

% W=W*2;
% W=W./max(max(W));

net1.Dlay=0.0001.*net1.Dlay; %only for testing purposes.

c=0.04; % threshold constant
net1.Sth=1+c; %thresshold value

net1.a=1;
net1.b=0; %ttf defines S max.
net1.v=5; %spike transmission speed (m/s)
net1.D=0.2; %decay constant

net1.tarp=.2; % absolute refractory period

%define states initially
net1.S=generateNetworkState(n,net1.Sth);

%initialize event list
evlist=[];
for i=1:n %for every neuron
  if (net1.S(i,1)>net1.Sth)
    ttf=(net1.a/(net1.S(i,1)-1))-net1.b;
    evlist=cat(1,evlist,[1 i t+ttf 0]);
  end
end
evlist=sortrows(evlist,3);


%event types:
% (1) Fire
% (2) Burning (input spike)
% (3) End of refractory state
%
% event 2nd item is Neuron number
% event 3rd item is Global time of event
% event 4th item is membrane potential to add to neuron state  ONLY DEFINED IN
% EVENTS OF TYPE 2.


%%
on=true;
while(on)
[net1.S,evlist]=networking(net1,evlist);
if(evlist(1,1)==1)
  plot(evlist(1,3),evlist(1,2),'.r');
  hold on,
end
evlist(1,:)=[];
evlist=sortrows(evlist,3);
if(isempty(evlist))
  on=false;
end
end

%% 




