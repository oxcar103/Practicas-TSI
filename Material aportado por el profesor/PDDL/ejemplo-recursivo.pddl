﻿;; volar lo más rápido posible sin gastar más de x fuel usando (fuel-limit)



(define (domain pelis)




(:requirements

  :typing

  :fluents

  :derived-predicates

  :negative-preconditions

  :universal-preconditions

  :disjuntive-preconditions

  :conditional-effects

  :htn-expansion


  ; Requisitos adicionales para el manejo del tiempo

  :durative-actions

  :metatags

 )



(:types person - object)

(:constants disney terror - object)

(:predicates (edad ?x - person ?e - number)

             (en-cola ?x - person)

             )


(:task infiere

	:parameters()


  (:method recurre1
	:precondition (and (edad ?x ?e) (en-cola ?x) (>= ?e 18))

  :tasks ( (ver-peli-terror ?x)

           (infiere)))


  (:method recurre2

	:precondition (and (edad ?x ?e) (en-cola ?x) (< ?e 18))

   :tasks ( (ver-peli-disney ?x)

            (infiere)))


  (:method caso-base

	:precondition():tasks())
)


(:durative-action ver-peli-disney

 :parameters (?p - person )

 :duration (= ?duration 2)

 :condition (and  (en-cola ?p) )

                 
 :effect (and  (not (en-cola ?p))))



(:durative-action ver-peli-terror

 :parameters (?p - person )

 :duration (= ?duration 2)

 :condition (and  (en-cola ?p) )

                 
 :effect (and  (not (en-cola ?p))))
 )
