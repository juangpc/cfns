
clear all,
close all,

%define network properties
n=100; %number of neurons
c=0.04; % threshold constant
Sth=1+c; %thresshold value
a=1; %time to fire (ttf) constant 
b=0; %ttf defines S max.
v=5; %spike transmission speed (m/s)[mm/ms]
D=0.3; %decay constant
t=0; %global time
tarp=2; % absolute refractory period (arp)[ms]

maxSimTime=100; % milliseconds

%build network
[W,Dlay,A]=generateNetworkConnectionsToK(n,40);
%A=presynapse
%W=postsynapse
%Dlay=axonal delay

W=W*2;
% W=W./max(max(W));
Dlay=0.0001.*Dlay; %only for testing purposes.

%define states initially
S=generateNetworkState(n,Sth);


%initialize event list
evlist=[];
for i=1:n %for every neuron
  if (S(i,1)>Sth)
    ttf=(a/(S(i,1)-1))-b;
    evlist=cat(1,evlist,[1 i t+ttf 0]);  %event type 1 ==> fire
  end
end
inputTimes=linspace(0,maxSimTime,maxSimTime/.5);
for i=1:n
  for evI=inputTimes
    evlist=cat(1,evlist,[2 i evI+i/25 0]);
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


%% main iteration
evlog=[];
while(~isempty(evlist) && (evlist(1,3)<maxSimTime))
  fprintf(['\nSimulation time now: ' num2str(evlist(1,3),'%8.4f')]);
  if(evlist(1,1)==1) %firing spike event
    jneurons=find_connections(evlist(1,2),W);
    for j=1:length(jneurons) %burnin event generator
      new_event=[2 jneurons(j) ... 
        evlist(1,3)+Dlay(evlist(1,2),jneurons(j))/v ...
        A(evlist(1,2),jneurons(j))*W(evlist(1,2),jneurons(j)) ...
        ];
      evlist=cat(1,evlist,new_event);  
    end
    %evlist=sortrows(evlist,3);
    S(evlist(1,2),1)=0; %new state = 0 just after firing
    S(evlist(1,2),2)=evlist(1,3); %time of update
    S(evlist(1,2),3)=1; %refractory state flag ON
    new_event=[3 evlist(1,2) evlist(1,3)+tarp 0];
    evlist=cat(1,evlist,new_event);
    
  elseif(evlist(1,1)==2) %burning spike (spike reception) event
    if(S(evlist(1,2),3)==0) %only if not in refractory state
      if(S(evlist(1,2),1)>=Sth) %neuron in active state
        dT=(evlist(1,3)-S(evlist(1,2),2));
        Tr=(S(evlist(1,2),1)-1)^2*dT/(a-(S(evlist(1,2),1)-1)*dT);
        S(evlist(1,2),1)=S(evlist(1,2),1)+evlist(1,4)+Tr; %update new state
        S(evlist(1,2),2)=evlist(1,3); %update time
        
        %update previous firing event
        ev_firing=find(evlist(:,1)==1);
        expired_event=ev_firing(evlist(ev_firing,2)==evlist(1,2));
        if(S(evlist(1,2),1)>=Sth) %continues in active state
          ttf=(a/(S(evlist(1,2),1)-1))-b;
          evlist(expired_event,3)=S(evlist(1,2),2)+ttf;
        elseif(S(evlist(1,2),1)<Sth) %active to passive transition
          evlist(expired_event,:)=[]; %eliminate previous firing event
        end
      else %neuron in passive state
        dT=(evlist(1,3)-S(evlist(1,2),2));
        S(evlist(1,2),1)=S(evlist(1,2),1)*exp(-dT/D)+evlist(1,4);
        S(evlist(1,2),2)=evlist(1,3);
        
        if(S(evlist(1,2),1)>=Sth) %passive to active transition
          ttf=(a/(S(evlist(1,2),1)-1))-b;
          new_event=[1 evlist(1,2) evlist(1,3)+ttf 0];
          evlist=cat(1,evlist,new_event);
        end
      end
      
      if(S(evlist(1,2),1)<0)
        S(evlist(1,2),1)=0;
      end
      
    end
    
  elseif(evlist(1,1)==3) %refractory state
    S(evlist(1,2),3)=0; %update refractory flag
  end
  
  evlog=cat(1,evlog,evlist(1,:));
  evlist(1,:)=[];
  
  %reorder events
  evlist=sortrows(evlist,3);  
  
end


%% plot some neuron
% S_1=Stotal(1,:);
% for ii=2:length(Stotal)
%   if(Stotal(ii,2)~=S_1(end,2))
%     S_1=cat(1,S_1,Stotal(ii,1:2));
%   end
% end
% 
% plot(S_1(:,2),S_1(:,1))
% plot(S_1(:,1),S_1(:,2))

%% raster plot
figure(1),
for i=1:size(evlog,1)
  if(evlog(i,1)==1)
    plot(evlog(i,3),evlog(i,2),'.r');
    hold on,
  end
end

%% 


