
clear all,
close all,

%define network properties
n=10; %number of neurons
d=0.04; % threshold constant
Sth=1+d; %thresshold value
a=1; %time to fire (ttf) constant a
b=0; %ttf defines S max.
v=5; %spike transmission speed (m/s)
t=0; %global time

%build network
[W,Dlay,A]=generateNetworkConnections(n);
%A=presynapse
%W=postsynapse
%Dlay=axonal delay

%define states initially
S=generateNetworkState(n,Sth);

%initialize event list
evlist=[];
new_event=[];
for i=1:n
  if (S(i,1)>Sth)
    ttf=(a/(S(i,1)-1))-b;
    new_event=[1 i t+ttf 0];
    evlist=cat(1,evlist,new_event);
  end
end
evlist=sortrows(evlist,3);
clear new_event

% main iteration 
evlog=[];
while(~isempty(evlist))
  if(evlist(1,1)==1) %firing spike
    jneurons=find_connections(evlist(1,2),W);
    for j=1:length(jneurons)
      new_event=[2 jneurons(j) ...
        evlist(1,3)+Dlay(evlist(1,2),jneurons(j))/v ...
        A(evlist(1,2),jneurons(j))*W(evlist(1,2),jneurons(j)) ...
        ];
      evlist=cat(1,evlist,new_event);
      evlist=sortrows(evlist,3);
    end
  elseif(evlist(1,1)==2) %burning spike (spike reception)
    if(S(evlist(1,2),1)>=Sth) %neuron in active state
      dT=(evlist(1,3)-S(evlist(1,2),2));
      Tr=(S(evlist(1,2),1)-1)^2*dT/(a-(S(evlist(1,2),1)-1)*dT);
      S(evlist(1,2),1)=S(evlist(1,2),1)+evlist(1,4)+Tr;
    else %neuron in passive state
      S(evlist(1,2),1)=(S(evlist(1,2),1)+evlist(1,4))*
    end
  elseif(evlist(1,1)==3)
    %refractory state
  end
  evlog=cat(1,evlog,evlist(1,:));
  evlist(1,:)=[];
end





