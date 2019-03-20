%% script to build watts strogatz algorithm.
clear all,

n = 10; %number of neurons, even
k = 3; %mean degree, integer and even
p = .5; % rewiring prob. (0<=p<=1)
R = .5; %excitatory ratio (0<=R<=1)
% 1<<ln(n)<<k<<n

g=WattsStrogatz(n,k,p);
c=adjacency(g);
c=full(c);

W = rand(n).*c;

B=.14147;
D= raylrnd(B,n,n);
D= triu(D,1)+triu(D,1)';

mu_ex=.5;
s_ex=.3;
mu_inh=-.5;
s_inh=.3;
A = [abs(normrnd(mu_ex,s_ex,R*n,n));
     -abs(normrnd(mu_inh,s_inh,(1-R)*n,n))];
A(randperm(size(A,1)),:);
A=A.*c;



%%

R=.3;
for N=10:1000
  fprintf(['\n' num2str(N,'%4i') ': ' num2str(ceil(N*R)+floor(N*(1-R)),'%4.3f') ': ' num2str(ceil(N*R),'%4.3f') ': ' num2str(floor(N*(1-R)),'%4.3f')]);
end
