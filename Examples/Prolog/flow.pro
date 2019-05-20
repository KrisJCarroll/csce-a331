% flow.pro
% Glenn G. Chappell
% Started: 26 Apr 2019
% Updated: 29 Apr 2019
%
% For CS F331 / CSCE A331 Spring 2019
% Code from 4/26 & 4/29 - Prolog: Flow of Control


% ***** Preliminaries *****


% Output atom (think: string): write(ATOM)
% Output newline: nl
% Both always succeed.

% hello_world/0
% Print hello-world message.
hello_world :- write('Hello, world!'), nl.

% Try:
%   ?- hello_world.

% Prolog has strangely limited built in facilities for input. We will
% use read_number/1, which takes a free variable, reads a number from
% the standard input, and sets the variable to it. An exception is
% thrown if a number is not typed.

% Try:
%   ?- write('Type a number: '), read_number(X).

% true/0 - always succeeds
% fail/0 - never succeeds

% Try:
%   ?- true.
%   ?- fail.


% ***** Basic Repetition *****


% print_squares/2
% print_squares(A, B) prints a message indicating the squares of
% integers A, A+1, ... up to B, each on a separate line.
print_squares(A, B) :- A =< B, S is A*A,
                       write(A), write(' squared is '), write(S), nl,
                       A1 is A+1, print_squares(A1, B).

% Try:
%   ?- print_squares(2, 8).


% ***** Encapsulated Flow *****


% We can also encapsulate the recursion in a predicate.

% myfor/3
% If X is bound, succeed if A <= X <= B.
% If X is free, succeed with X = N for each N with A <= B <= B.
myfor(X, A, B) :- A =< B, X = A.
myfor(X, A, B) :- A =< B, A1 is A+1, myfor(X, A1, B).

% So "myfor" starts a loop. How do we end it?
% One answer: fail.
% "fail" never succeeds; so it always backtracks.

% Try:
%   ?- myfor(3, 1, 5).
%   ?- myfor(7, 1, 5).
%   ?- myfor(X, 1, 5).
%   ?- myfor(X, 1, 5), write(X), nl.
%   ?- myfor(X, 1, 5), write(X), nl, fail.

% print_squares2/2
print_squares2(A, B) :-
    myfor(X, A, B),
        S is X*X,
        write(X),
        write(' squared is '),
        write(S),
        nl,
    fail.

% Try:
%   ?- print_squares2(2, 8).

% Prolog includes "myfor", in the form of "for".


% ***** Cut *****


% "!" (read as "cut")
% - Always succeeds.
% - Once a cut has been done:
%   - Backtracking past the cut is not allowed, for the current goal.
%   - Included in this: use of another definition for the current goal
%     is not allowed.

% Cut can be used as a "break".

% near_sqrt/1
% For A > 0. near_sqrt(A) prints largest integer whose square is <= A.
near_sqrt(A) :-
    for(X, 1, A),
        X2 is X*X,
        X2 > A, !,
        X1 is X-1,
        write(X1),
        nl.

% Try:
%   near_sqrt(105).

% Cut can do if ... else.

% Consider the following C++ code.
%
%   void test_big(int n)
%   {
%       if (n > 6)
%           cout << n << " IS A BIG NUMBER!" << endl;
%       else
%           cout << n << " is not a big number." << endl;
%   }
%
% Here it is in Prolog:

% test_big/1
% test_big(+n) prints a message indicating whether n > 6.
test_big(N) :- N > 6, !, write(N), write(' IS A BIG NUMBER!'), nl.
test_big(N) :- write(N), write(' is not a big number.'), nl.

% Try:
%   ?- test_big(100).
%   ?- test_big(2).

% More generally, cut can be used to ensure that only one definition of
% a predicate is used.

% Here is our "gcd" predicate from simple.pro:
% gcd(0, B, B).
% gcd(A, B, C) :- A > 0, X is B mod A, gcd(X, A, C).

% And here is a rewritten version, using cut:

% gcd(+a, +b, ?c)
% gcd(A, B, C) means the gcd of A and B is C. A, B should be nonnegative
% integers. C should be a nonnegative integer or a free variable.
gcd(0, B, C) :- !, B = C.
gcd(A, B, C) :- X is B mod A, gcd(X, A, C).

% Try:
%   ?- gcd(30, 105, X).
%   ?- gcd(30, 105, 15).
%   ?- gcd(30, 105, 14).

% With cut, we can write "not".

% not/1
% Given a zero-argument predicate or compound term. Succeeds if the
% given term fails.
not(T) :- call(T), !, fail.
not(_).

% Prolog includes "not", in the form of "\+".


% ***** Other Loops *****


% true/0 always succeeds, but only once.

% myrepeat/0 succeeds an unlimited number of times.
myrepeat.
myrepeat :- myrepeat.

% Prolog includes "myrepeat", in the form of "repeat".

% We can use myrepeat to do a while-true-break loop.

squares_interact :-
    myrepeat,
        write('Type a number (0 to quit): '),
        read_number(X),
        nl,
        write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl,
    X = 0,
    write('Bye!'), nl.

% Try:
%   ?- squares_interact.

% ";" is OR, just as "," is AND. The precedence of ";" is lower than
% that of ",".

% To deal with precedence issues, and to restrict the effect of a cut,
% use parentheses, as below.

% Here is squares_interact rewritten to do its "break" in the middle of
% the loop.

squares_interact2 :-
    repeat,
        write('Type a number (0 to quit): '),
        read_number(X),
        nl,
        (X = 0, !
        ;write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl, fail),
    write('Bye!'), nl.

% Try:
%   ?- squares_interact2.

