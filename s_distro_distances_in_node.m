
clear all,
n=1000;
eps=.05;

p=rand(1,2);

for i=1:n-1
  p=cat(1,p,rand(1,2));
  dist=squareform(pdist(p));
  if(sum(dist(end,:)<eps)>=2)
    p(end,:)=[];
  end
end

figure(1),plot(p(:,1),p(:,2),'.')
d=pdist(p);
figure(2),hist(d,30)

% best fit is a rayleigh distribution
% R = raylrnd(B,m,n)
% with B=.14147;

d_test=raylrnd(.14147,1,22366);
figure(3),hist(d_test,30);