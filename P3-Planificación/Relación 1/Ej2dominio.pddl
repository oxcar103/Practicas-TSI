(define (domain BelkanWorld)

   (:requirements :typing)
   (:types jugador
           personaje
           objeto
           zona
   )

   (:predicates
         (at ?j - jugador ?z - zona)
         (at ?p - personaje ?z - zona)
         (at ?o - objeto ?z - zona)
         (conectada ?z1 - zona ?z2 - zona)
         (libre ?j - jugador)
         (cogido ?o - objeto ?j - jugador)
         (entregado ?o - objeto ?p - personaje)
   )

   (:functions (energia ?j - jugador))

   (:action ir
      :parameters (?j - jugador ?origen ?destino - zona)
      :precondition (and (at ?j ?origen)
                         (> (energia ?j) 0)
                         (or
                            (conectada ?origen ?destino)
                            (conectada ?destino ?origen)
                         )
                    )
      :effect (and (at ?j ?destino)
                   (not (at ?j ?origen))
                   (decrease (energia ?j) 1)
              )
   )

   (:action coger
      :parameters (?z - zona ?o - objeto ?j - jugador)
      :precondition (and (at ?o ?z)
                         (libre ?j)
                         (at ?j ?z)
                    )
      :effect (and (not (libre ?j))
                   (cogido ?o ?j )
                   (not (at ?o ?z))
              )
   )

   (:action dejar
      :parameters (?z - zona ?o - objeto ?j - jugador)
      :precondition (and (cogido ?o ?j)
                         (at ?j ?z)
                    )
      :effect (and (at ?o ?z)
                   (libre ?j)
                   (not (cogido ?o ?j))
              )
   )

   (:action entregar
      :parameters (?z - zona ?o - objeto ?j - jugador ?p - personaje)
      :precondition (and (cogido ?o ?j)
                         (at ?j ?z)
                         (at ?p ?z)
                    )
      :effect (and (entregado ?o ?p)
                   (libre ?j)
                   (not (cogido ?o ?j))
              )
   )
)