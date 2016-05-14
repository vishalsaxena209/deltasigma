
clear all; clc;

NTF = tf([1 -2 1], [1], [],'variable', 'z^-1');
L1 = 1-(1/NTF);

[b1,a1] = tfdata(L1, 'v');
[r,p,k] = residue(b1,a1)



