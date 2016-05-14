function v = applyQuantizerNL(y,n,kq)
% Apply quantizer non-linearity
% Used for describing function analysis
% Limit the output

v = kq*y;
L = n-1;

for i=1:length(y)
    if (abs(y(i)) > L)
        v(i) = L*sgn(y(i));
    end
end