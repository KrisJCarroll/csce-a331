% simple.pro
% Glenn G. Chappell
% 22 Apr 2019
%
% For CS F331 / CSCE A331 Spring 2019
% Code from 4/22 - Prolog: Simple Programming


% ***** Syntax *****


% Single-line comment

/* Multi-line
   comment */

% Prolog syntax is free-form.
is_bit(0).
is_bit(  % No space allowed before left parenthesis
    1
    )
    .

% Try ("?-" is the prompt):
%   ?- is_bit(1).
%   ?- 'is_bit'(0).
%   ?- is_bit(2).
%   ?- is_bit(X).

@:$(10).
'q q q'(20).
'q q q'(21).

% Try:
%   ?- @:$(X).
%   ?- '@:$'(X).
%   ?- 'q q q'(X).


% ***** Facts, Queries, Rules, Goals *****


% Some facts:
is_child_of(bill, zeke).
is_child_of(jill, zeke).
is_child_of(will, zeke).
is_child_of(alice, bill).
is_child_of(bob, bill).
is_child_of(carol, bill).
is_child_of(xavier, jill).

% Try some queries:
%   ?- is_child_of(bill, zeke).
%   ?- is_child_of(zeke, bill).
%   ?- is_child_of(bill, jill).
%   ?- is_child_of(X, zeke).
%   ?- is_child_of(X, Y).

% Queries may include multiple terms, separated by commas.
% Any variable that is bound in a term remains bound to the same value
% in all later terms.

% Try fancier queries:
%   ?- is_child_of(alice, X), is_child_of(X, zeke).
%   ?- is_child_of(X, zeke), is_child_of(Y, X).

% Some rules:

% is_parent_of(?a, ?b)
is_parent_of(A, B) :- is_child_of(B, A).

% is_grandchild_of(?a, ?b)
is_grandchild_of(A, B) :- is_child_of(A, X), is_child_of(X, B).

% is_grandparent_of(?a, ?b)
is_grandparent_of(A, B) :- is_grandchild_of(B, A).

% is_sibling_of(?a, ?b)
is_sibling_of(A, B) :-
    is_child_of(A, X),
    is_child_of(B, X),
    A \= B.

% Try:
%   ?- is_sibling_of(alice, X).
%   ?- is_sibling_of(X, Y).
%   ?- is_sibling_of(X, Y), X @< Y.
% "@<" is a total order on all terms.


% ***** Conventions *****


% sq/2 means that sq is a predicate that takes two arguments.
% Arguments can be marked:
%   + input only; argument cannot be free variable
%   - output only; argument must be free variable
%   ? input or output
% See comments before various predicates in this file for examples of
% how these may be used.


% ***** Negation *****


% Starting the name of a predicate with "\" typically means *not* (this
% is a convention, not a rule of the PL).

% \+ is a 1-argument predicate that can be used as a prefix operator. It
% succeeds if its argument fails. So it means *negation*.

% is_cousin_of(?a, ?b)
% Succeeds when values are first cousins, based on is_child_of facts.
is_cousin_of(A, B) :-
    is_grandchild_of(A, X),
    is_grandchild_of(B, X),
    \+ is_sibling_of(A, B),
    A \= B.

% Try:
%   ?- is_cousin_of(alice, X).
%   ?- is_cousin_of(X, Y).


% ***** Numerical Computation *****


% Try:
%   ?- X = (1+sqrt(5))/2.
%   ?- is(X, (1+sqrt(5))/2).
%   ?- X is (1+sqrt(5))/2.
%   ?- X = (1+sqrt(5))/2, Y = X*X, Z is Y.
%   ?- X is 7/2.
%   ?- X is 7//2.
%   ?- X is 7.5//2.
% The last line above should result in an exception being raised.

% gcd(+a, +b, ?c)
% gcd(A, B, C) means the gcd of A and B is C. A, B should be nonnegative
% integers. C should be a nonnegative integer or a free variable.
gcd(0, B, B).
gcd(A, B, C) :- A > 0, X is B mod A, gcd(X, A, C).

% Note. The fact above:
%   gcd(0, B, B).
% has the same effect that either of the following rules would have:
%   gcd(0, B, C) :- B = C.
%   gcd(0, B, B) :- true.

% Try:
%   ?- gcd(30, 105, X).
%   ?- gcd(30, 105, 15).
%   ?- gcd(30, 105, 14).
%   ?- gcd(X, 105, 15).
% The last line above should result in an exception being raised.

