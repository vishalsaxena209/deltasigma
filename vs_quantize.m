function v = vs_quantize(y,n,LSB)
% v = ds_quantize(y,n=2,LSB=0.1)
% Quantize y to 
% an odd integer in [-n+1, n-1], if n is even, or
% an even integer in [-n+1, n-1], if n is odd.
% The Step heights and widths are equal to LSB
% n can be a column vector which specifies how to quantize the rows of y
if nargin<2
    n=2;
end
if length(n)==1
    n = n*ones(size(y));
elseif size(n,1)==size(y,1)
    n = n*ones(1,size(y,2));
end

i = rem(n,2)==0;	
v = zeros(size(y));
v(i) = (floor(y(i)/LSB + 0.5))*LSB;	% mid-rise quantizer
v(~i) = (floor((y(~i)/LSB + 0.5)))*LSB;	% mid-tread quantizer

% Limit the output
L = (n-1)*LSB/2;
for m=[-1 1]
    i = m*v>L;
    if any(i(:))
	v(i) = m*L(i);
    end
end
