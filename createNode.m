function node=createNode(config)

if(nargin<1)
  
  config.n = 1000; %number of neurons, even
  config.p = .5; % rewiring prob. (0<=p<=1)
  config.k = 3; %mean degree, integer and even
  config.R =.7; %excitatory ratio (0<=R<=1)
  % 1<<ln(n)<<k<<n
  
  %pre-synaptic values
  config.mu_ex=.5; %excitatory gain mean value
  config.s_ex=.3; %excitatory sigma
  config.mu_inh=-.5; %inhibitory gain mean value
  config.s_inh=.3;
  
  %post-synaptic values
  config.mu_w=.5;
  config.s_w=.3;
end

%%

%output
node=[];

%params for the neuron model
node.a=config.a;  %default 1
node.b=config.b;  %default 0
node.c=config.c;  %default 0.04
node.D=config.D;  %default 0.2

node.tarp=config.tarp; %abs refractory period [ms]
node.Nb=config.Nb; %numero de firing per burst
node.IBI=config.IBI; %inter burst interval [ms]

%% intra node business

%generation of post-synaptic connectivity matrix
g=WattsStrogatz(config.n,config.k,config.p);
c=adjacency(g);
c=full(c); %initial postsynaptic connectivity matrix
node.W = normrnd(config.mu_w,config.s_w,config.n,config.n);

%delay matrix intranode
B=.14147;
L= raylrnd(B,config.n,config.n);
node.L= triu(L,1)+triu(L,1)';

%generation of pre-synaptic connectivity matrix
A = [abs(normrnd(config.mu_ex,config.s_ex,ceil(config.R*config.n),config.n));
  -abs(normrnd(config.mu_inh,config.s_inh,floor((1-config.R)*config.n),config.n))];
node.A=A(randperm(size(A,1)),:).*c;


end