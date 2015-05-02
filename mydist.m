function z = mydist(w,p)
%  w : SxR weight matrix 
%  p : RxQ input matrix 
%  
%  z : SxQ matrix of distances between w's rows and p's columns.
%  
%   Matlab dist(w,p) returns the same result as mydist(w,p). But, 'mydist'
%   requires far less memory to compute. (It can help to overcome 'Out of
%   memory error' in newrb and ohters.)

%Author: Ashok Kumar Pant, 2013
%Central Dept. of Computer Science and IT, TU, Kathmandu, Nepal.

[S,~] = size(w);
[~,Q] = size(p);
w=w';
z=zeros(S,Q);
for i=1:S
    for j=1:Q
        z(i,j)=sqrt(sum((w(:,i)-p(:,j)).^2));
    end
end
