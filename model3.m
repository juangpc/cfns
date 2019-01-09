
clear all,
close all,

%define network properties
n=1000; %number of neurons
d=0.04; % threshold constant
Sth=1+d; %thresshold value
a=1; %time to fire (ttf) constant a
b=0; %ttf defines S max.
v=5; %spike transmission speed (m/s)
D=0.05; %decay constant
t=0; %global time
tarp=2; % absolute refractory period

maxSimTime=100000;

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



%% main iteration
evlog=[];
Stotal=[];
while(~isempty(evlist) && (evlist(1,3)<maxSimTime))
  if(evlist(1,1)==1) %firing spike event
    jneurons=find_connections(evlist(1,2),W);
    for j=1:length(jneurons)
      new_event=[2 jneurons(j) ...
        evlist(1,3)+Dlay(evlist(1,2),jneurons(j))/v ...
        A(evlist(1,2),jneurons(j))*W(evlist(1,2),jneurons(j)) ...
        ];
      evlist=cat(1,evlist,new_event);
      evlist=sortrows(evlist,3);
    end
    S(evlist(1,2),1)=0; %new state = 0 just after firing
    S(evlist(1,2),2)=evlist(1,3); %time of update
    S(evlist(1,2),3)=1; %refractory state flag ON
    new_event=[3 evlist(1,2) evlist(1,3)+tarp 0];
    evlist=cat(1,evlist,new_event);
    evlist=sortrows(evlist,3);
    
  elseif(evlist(1,1)==2) %burning spike (spike reception) event
    if(S(evlist(1,2),3)==0) %only if not in refractory state
      if(S(evlist(1,2),1)>=Sth) %neuron in active state
        dT=(evlist(1,3)-S(evlist(1,2),2));
        Tr=(S(evlist(1,2),1)-1)^2*dT/(a-(S(evlist(1,2),1)-1)*dT);
        S(evlist(1,2),1)=S(evlist(1,2),1)+evlist(1,4)+Tr;
        S(evlist(1,2),2)=evlist(1,3);
        
        if(S(evlist(1,2),1)>=Sth) %continues in active state
          %erase previous firing event
          ev_firing=find(evlist(:,1)==1);
          expired_event=ev_firing(find(evlist(ev_firing,2)==evlist(1,2)));
          evlist(expired_event,:)=[];

          %generate new updated firing event
          ttf=(a/(S(evlist(1,2),1)-1))-b;
          new_event=[1 evlist(1,2) S(evlist(1,2),2)+ttf 0];
          evlist=cat(1,evlist,new_event);
          evlist=sortrows(evlist,3);
        
        elseif(S(evlist(1,2),1)<Sth) %active to passive transition
          ev_firing=find(evlist(:,1)==1);
          expired_event=ev_firing(find(evlist(ev_firing,2)==evlist(1,2)));
          evlist(expired_event,:)=[];
        end
      else %neuron in passive state
        dT=(evlist(1,3)-S(evlist(1,2),2));
        S(evlist(1,2),1)=S(evlist(1,2),1)*exp(-dT/D)+evlist(1,4);
        S(evlist(1,2),2)=evlist(1,3);
        
        if(S(evlist(1,2),1)>=Sth) %passive to active transition
          ttf=(a/(S(evlist(1,2),1)-1))-b;
          new_event=[1 evlist(1,2) evlist(1,3)+ttf 0];
        end
      end
    end
    
  elseif(evlist(1,1)==3) %refractory state
    S(evlist(1,2),3)=0;
    %S(evlist(1,2),2)=evlist(1,3);
  end
  evlog=cat(1,evlog,evlist(1,:));
  evlist(1,:)=[];
  Stotal=cat(2,Stotal,S(:,1));
end





