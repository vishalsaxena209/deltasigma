% Compare Blackman-harris and Hann windows with the rect window
close all; clear all; clc;
L = 32;
wvtool(rectwin(L),hann(L),blackmanharris(L));



