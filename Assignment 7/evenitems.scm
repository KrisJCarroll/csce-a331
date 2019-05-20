#lang scheme
; evenitems.scm
; author: Kristopher Carroll
; CSCE A331
; Assignment 7


; evenitems takes a list and returns a list of the values found at even indices
; can take lists containing any types of values and the empty list
(define (evenitems list)
    (cond
       ((null? list) '()) ; checking if list is empty, return empty list
       ((null? (cdr list)) list) ; checking if only item in list, return the item
       (else (cons (car list) (evenitems (cddr list)))))) ; take the first item and recurse on remaining list after removing an additional item