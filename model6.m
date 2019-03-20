
clear all

%% create config structure for 4 nodes

config1.n = 10; 
config1.p = .5; 
config1.k = 3; 
config1.R =.7; 

config1.mu_ex=.5; 
config1.s_ex=.3; 
config1.mu_inh=-.5; 
config1.s_inh=.3;

config1.mu_w=.5;
config1.s_w=.3;

config1.a=1;
config1.b=0;
config1.c=.04;
config1.D=0.2;

config1.tarp=2;
config1.Nb=10;
config1.IBI=20;

node1=createNode(config1);

config1.n=20;
node2=createNode(config1);

config1.n=5;
node3=createNode(config1);
