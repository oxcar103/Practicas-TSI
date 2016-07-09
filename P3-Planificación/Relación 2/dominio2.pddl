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
         (destino ?p - person ?c - city)
         (distancia ?x ?y ?d)
         (hay-fuel ?a ?c1 ?c2)
         (hay-fuel-fast ?a ?c1 ?c2)
         (suficiente-fuel-slow ?a ?c1 ?c2)
         (suficiente-fuel-fast ?a ?c1 ?c2)
         (excede-fuel-fast ?a ?c1 ?c2)
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

   ;; el consecuente "vacío" se representa como "()" y significa "siempre verdad"
   (:derived
         (igual ?x ?x) ()
   )

   (:derived 
         (different ?x ?y) (not (igual ?x ?y))
   )

   (:derived 
         (distancia ?x ?y - city ?d - number)
         (or
            (bind ?d (distance ?y ?x))
            (bind ?d (distance ?x ?y))
         )
   )

   ;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual, 
   ;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
   ;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1.
   ;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
   ;; restricción más compleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
   ;; los siguientes ejercicios).
   (:derived
         (hay-fuel ?a - aircraft ?c1 - city ?c2 - city)
         (> (fuel ?a) (slow-burn ?a))
   )

   (:derived
         (hay-fuel-fast ?a - aircraft ?c1 - city ?c2 - city)
         (and (distancia ?c1 ?c2 - city ?d - number)
              (>= (fuel ?a) (* ?d (fast-burn ?a)))
         )
   )

   (:derived
         (suficiente-fuel-fast ?a - aircraft ?c1 - city ?c2 - city)
         (and (distancia ?c1 ?c2 - city ?d - number)
              (< (+ (total-fuel-used) (* ?d (fast-burn ?a))) (fuel-limit))
         )
   )

   (:derived
         (suficiente-fuel-slow ?a - aircraft ?c1 - city ?c2 - city)
         (and (distancia ?c1 ?c2 - city ?d - number)
              (< (+ (total-fuel-used) (* ?d (slow-burn ?a))) (fuel-limit))
         )
   )

   (:derived
         (excede-fuel-fast ?a - aircraft ?c1 - city ?c2 - city)
         (and (distancia ?c1 ?c2 - city ?d - number)
              (< (+ (+ (total-fuel-used) (* ?d (fast-burn ?a))) (capacity ?a)) (fuel-limit))
         )
   )

   (:task transport-person
         :parameters (?p - person ?c - city)

      (:method Case1 ; si la persona está en la ciudad no se hace nada
         :precondition (at ?p ?c)
         :tasks ()
      )

      (:method Case2 ;si no está en la ciudad destino, pero avión y persona están en la misma ciudad
         :precondition (and (at ?p - person ?c1 - city)
                            (at ?a - aircraft ?c1 - city)
                        )
         :tasks (
                 (forall (?x - person)
                    (when (and (destino ?x ? person ?c ? city)
                               (at ?x - person ?c1 - city)
                               (> (free-seat) 0)
                          )
                          (and (decrease (free-seat) 1)
                               (board ?x ?a ?c1)
                          )
                    )
                 )
                 (mover-avion ?a ?c1 ?c)
                 (forall (?x - person)
                    (when (and (destino ?x ? person ?c ? city)
                               (at ?x - person ?a - aircraft)
                          )
                          (and (increase (free-seat) 1)
                               (debark ?x ?a ?c)
                          )
                    )
                 )
                )
      )

      (:method Case3 ; si no está en la ciudad destino, y tampoco avion y persona están en la misma ciudad
         :precondition (and (at ?p - person ?c1 - city)
                            (at ?a - aircraft ?c2 - city)
                       )
         :tasks (
                 (mover-avion ?a ?c2 ?c1)
                 (forall (?x - person)
                    (when (and (destino ?x ? person ?c ? city)
                               (at ?x - person ?c1 - city)
                               (> (free-seat) 0)
                          )
                          (and (decrease (free-seat) 1)
                               (board ?x ?a ?c1)
                          )
                    )
                 )
                 (mover-avion ?a ?c1 ?c)
                 (forall (?x - person)
                    (when (and (destino ?x ? person ?c ? city)
                               (at ?x - person ?a - aircraft)
                          )
                          (and (increase (free-seat) 1)
                               (debark ?x ?a ?c)
                          )
                    )
                )
               )
      )
   )

   (:task mover-avion
         :parameters (?a - aircraft ?c1 - city ?c2 - city)

      (:method fuel-suficiente ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                               ;; volar desde ?c1 a ?c2
                               ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
                               ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
                               ;; descomponsición de la tarea mover-avión "fallará". 
                               ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
                               ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
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
                            (excede-fuel-fast ?a ?c1 ?c2)
                       )
         :tasks (
                 (refuel ?a ?c1)
                 (zoom ?a ?c1 ?c2)
                )
      )

      (:method vuela-rapido
         :precondition ( and (hay-fuel-fast ?a ?c1 ?c2)
                             (suficiente-fuel-fast ?a ?c1 ?c2)
                       )
         :tasks (
                 (zoom ?a ?c1 ?c2)
                )
      )

      (:method vuela-lento
         :precondition (and (hay-fuel ?a ?c1 ?c2)
                            (suficiente-fuel-slow ?a ?c1 ?c2)
                       )
         :tasks (
                 (fly ?a ?c1 ?c2)
                )
      )
   )

   (:import "Primitivas-Zenotravel.pddl") 
)
