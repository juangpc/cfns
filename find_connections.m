function c=find_connections(i,A)

n=size(A,1);
c=[];
%connectivity is from ROW to COLUMN
for j=1:n
  if(A(i,j)>0)
    c=cat(1,c,j);
  end
end

end



