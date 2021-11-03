function X_nsamp = get_samples(X,nsamp)

% uses Jitendra Malik's sampling method

x = X(:,1);
y = X(:,2);



N=length(x);
k=3;
Nstart=min(k*nsamp,N);

ind0=randperm(N);
ind0=ind0(1:Nstart);

xi=x(ind0);
yi=y(ind0);
xi=xi(:);
yi=yi(:);


d2=dist2([xi yi],[xi yi]);
d2=d2+diag(Inf*ones(Nstart,1));

s=1;
while s
   % find closest pair
   [a,b]=min(d2);
   [c,d]=min(a);
   I=b(d);
   J=d;
   % remove one of the points
   xi(J)=[];
   yi(J)=[];
   d2(:,J)=[];
   d2(J,:)=[];
   if size(d2,1)==nsamp
      s=0;
   end
end

X_nsamp(:,1) = xi;
X_nsamp(:,2) = yi;