
ntf = zpk([1 1],[0 0],1,1);
[ABCDc,tdac2] = realizeNTF_ct(ntf,'FB')