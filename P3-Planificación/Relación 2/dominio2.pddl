(define (domain zeno-travel)

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

   (:types aircraft person city - object)
   (:constants slow fast - object)
   (:predicates
         (at ?x - (either person aircraft) ?c - city)
         (in ?p - person ?a - aircraft)
         (different ?x ?y)
         (igual ?x ?y)
         (hay-fuel ?a ?c1 ?c2)
   )
   (:functions
         (fuel ?a - aircraft)
         (distance ?c1 - city ?c2 - city)
         (slow-speed ?a - aircraft)
         (fast-speed ?a - aircraft)
         (slow-burn ?a - aircraft)
         (fast-burn ?a - aircraft)
         (capacity ?a - aircraft)
         (refuel-rate ?a - aircraft)
         (total-fuel-used)
         (boarding-time)
         (debarking-time)
         (fuel-limit)
   )

   ;; el consecuente "vac�o" se representa como "()" y significa "siempre verdad"
   (:derived
         (igual ?x ?x) ()
   )

   (:derived 
         (different ?x ?y) (not (igual ?x ?y))
   )


   ;; este literal derivado se utiliza para deducir, a partir de la informaci�n en el estado actual, 
   ;; si hay fuel suficiente para que el avi�n ?a vuele de la ciudad ?c1 a la ?c2
   ;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1.
   ;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
   ;; restricci�n m�s copleja  si en lugar de 1 se representa una expresi�n m�s elaborada (esto es objeto de
   ;; los siguientes ejercicios).
   (:derived
         (hay-fuel ?a - aircraft ?c1 - city ?c2 - city)
         (> (fuel ?a) (slow-burn ?a))
   )

   (:task transport-person
         :parameters (?p - person ?c - city)

      (:method Case1 ; si la persona est� en la ciudad no se hace nada
         :precondition (at ?p ?c)
         :tasks ()
      )

      (:method Case2 ;si no est� en la ciudad destino, pero avi�n y persona est�n en la misma ciudad
         :precondition (and (at ?p - person ?c1 - city)
                            (at ?a - aircraft ?c1 - city)
                        )
         :tasks ( 
                 (board ?p ?a ?c1)
                 (mover-avion ?a ?c1 ?c)
                 (debark ?p ?a ?c )
                )
      )

      (:method Case3 ; si no est� en la ciudad destino, y tampoco avion y persona est�n en la misma ciudad
         :precondition (and (at ?p - person ?c1 - city)
                            (at ?a - aircraft ?c2 - city)
                       )
         :tasks (
                 (mover-avion ?a ?c2 ?c1)
                 (board ?p ?a ?c1)
                 (mover-avion ?a ?c1 ?c)
                 (debark ?p ?a ?c )
                )
      )
   )

   (:task mover-avion
         :parameters (?a - aircraft ?c1 - city ?c2 -city)

      (:method fuel-suficiente ;; este m�todo se escoger� para usar la acci�n fly siempre que el avi�n tenga fuel para
                               ;; volar desde ?c1 a ?c2
                               ;; si no hay fuel suficiente el m�todo no se aplicar� y la descomposici�n de esta tarea
                               ;; se intentar� hacer con otro m�todo. Cuando se agotan todos los m�todos posibles, la
                               ;; descomponsici�n de la tarea mover-avi�n "fallar�". 
                               ;; En consecuencia HTNP har� backtracking y escoger� otra posible v�a para descomponer
                               ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciaci�n para la variable ?a)
         :precondition (hay-fuel ?a ?c1 ?c2)
         :tasks (
                 (fly ?a ?c1 ?c2)
                )
      )

      (:method fuel-insuficiente-fly
         :precondition( not(hay-fuel ?a ?c1 ?c2) )
         :tasks(
                (refuel ?a ?c1)
                (fly ?a ?c1 ?c2)
               )
      )

      (:method fuel-insufuciente-zoom
         :precondition (and (not(hay-fuel ?a ?c1 ?c2))
                            (< (+ (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a))) (capacity ?a)) (fuel-limit))
                       )
         :tasks (
                 (refuel ?a ?c1)
                 (zoom ?a ?c1 ?c2)
                )
      )

      (:method vuela-rapido
         :precondition ( and (>= (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a)))
                             (< (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a))) (fuel-limit))
                       )
         :tasks (
                 (zoom ?a ?c1 ?c2)
                )
      )

      (:method vuela-lento
         :precondition (and (hay-fuel ?a ?c1 ?c2)
                            (< (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a))) (fuel-limit))
                       )
         :tasks (
                 (fly ?a ?c1 ?c2)
                )
      )
   )

   (:import "Primitivas-Zenotravel.pddl") 
)
