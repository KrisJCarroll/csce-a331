% take.pro
% author: Kristopher Carroll
% CSCE A331
% Assignment 7

% take/3
% take(+n, +x, ?e)
% n is a non-negative integer, x is a list and e is a list consisting of the first n items of x
% or all of x if n > length of x
%   if n is a nonnegative integer, x and e are both lists, succeeds if e is the correct list
%   if n is a nonnegative integer, x is a list and e is a free variable, succeeds with e containing first n items of x or all of x 
%       if n > length x

take(N, [], []). % x exhausted, success.
take(0, LIST, []). % n exhausted, success.
take(N, [H1|T1], [H2|T2]) :- H1 = H2, Y is N-1, take(Y, T1, T2). % x and e are non-empty, check their heads and recurse on tails
take(N, [H1|T1], LIST) :- Y is N-1, take(Y, T1, [LIST|H1]). % heads didn't match, build e with remaining values of x
