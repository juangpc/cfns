function W=generateNetworkConnections(n)


% W = [ 
%         0 1 0 0 0;
%         0 0 1 0 0;
%         1 0 0 1 0;
%         0 1 0 0 1;
%         1 0 1 0 0];
%       
      
W = randi([0 1],n); %random network with degree = 0.5
W = W - diag(diag(W)); %no autoconnections

end