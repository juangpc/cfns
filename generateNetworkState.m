function S = generateNetworkState(n,Sth)

S=[rand(1,n)*2*Sth; %internal state potential
  zeros(1,n); % global time for last update
  zeros(1,n)]'; %refractory state flag   
end



