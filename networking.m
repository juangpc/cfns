function [S,evlist]=networking(net,evlist)

  W=net.W;
  Dlay=net.Dlay;
  A=net.A;
  
  S=net.S;
  Sth=net.Sth;
  a=net.a;
  b=net.b;
  v=net.v;
  D=net.D;

  tarp=net.tarp;

  if(evlist(1,1)==1) %firing spike event
    jneurons=find_connections(evlist(1,2),W);
    for j=1:length(jneurons) 
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

end





