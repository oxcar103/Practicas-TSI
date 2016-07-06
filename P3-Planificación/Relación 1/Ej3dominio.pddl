(define (domain BelkanWorld)

  (:requirements :typing)
  (:types jugador
	personaje
	objeto
	zona)

  (:predicates
    (at ?j - jugador ?z - zona)
    (at ?p - personaje ?z - zona)
    (at ?o - objeto ?z - zona)
    (conectada ?z1 - zona ?z2 - zona)
    (mochilalibre ?j - jugador)
    (manolibre ?j - jugador)
    (cogido ?o - objeto ?j - jugador)
    (enmochila ?o - objeto ?j - jugador)
    (entregado ?o - objeto ?p - personaje)
    (esbikini ?o - objeto)
    (eszapatilla ?o - objeto)
    (esbosque ?z - zona)
    (esagua ?z - zona)
    (esprecipicio ?z - zona)
    (esarena ?z - zona)
    (espiedra ?z - zona)
  )

  (:functions
    (energia ?j - jugador))

  (:action ir
    :parameters (?j - jugador ?origen ?destino - zona)
    :precondition (and
		     (at ?j ?origen)
		     (> (energia ?j) 0)
		     (or
		        (conectada ?origen ?destino)
		        (conectada ?destino ?origen)
		     )
		     (not (esbosque ?destino))
		     (not (esagua ?destion))
		     (not (esprecipicio ?destino))
		  )
    :effect (and
              (at ?j ?destino)
              (not (at ?j ?origen))
              (decrease (energia ?j) 1)
	      (when (espiedra ?destino) (decrease (energia ?j) 1))
            )
  )

  (:action ir
    :parameters (?j - jugador ?origen ?destino - zona ?o -objeto)
    :precondition (and
		     (at ?j ?origen)
		     (> (energia ?j) 0)
		     (or
		        (conectada ?origen ?destino)
		        (conectada ?destino ?origen)
		     )
		     (esbosque ?destino)
		     (eszapatilla ?o)
                     (or
			(cogido ?o ?j)
			(enmochila?o ?j))
		  )
    :effect (and
              (at ?j ?destino)
              (not (at ?j ?origen))
              (decrease (energia ?j) 1))
  )

  (:action ir
    :parameters (?j - jugador ?origen ?destino - zona ?o - objeto)
    :precondition (and
		     (at ?j ?origen)
		     (> (energia ?j) 0)
		     (or
		        (conectada ?origen ?destino)
		        (conectada ?destino ?origen)
		     )
		     (esagua ?destino)
		     (esbikini ?o)
                     (or
			(cogido ?o ?j)
			(enmochila?o ?j))
		  )
    :effect (and
              (at ?j ?destino)
              (not (at ?j ?origen))
              (decrease (energia ?j) 1))
  )


  (:action coger
    :parameters ( ?z - zona ?o - objeto ?j - jugador)
    :precondition (and
	            (at ?o ?z)
		    (manolibre ?j)
	            (at ?j ?z)
	          )
    :effect (and
              (not (manolibre ?j))
	      (cogido ?o ?j )
	      (not (at ?o ?z))
	    )
  )

  (:action cogermochila
    :parameters ( ?o - objeto ?j - jugador)
    :precondition (and
	            (manolibre ?j)
	            (enmochila ?o ?j)
	          )
    :effect (and
              (not (manolibre ?j))
	      (mochilalibre ?j)
	      (cogido ?o ?j )
	      (not (enmochila ?o ?j))
	    )
  )

  (:action dejar
    :parameters ( ?z - zona ?o - objeto ?j - jugador)
    :precondition (and
		    (cogido ?o ?j)
	            (at ?j ?z))
    :effect (and
	      (at ?o ?z)
              (manolibre ?j)
    	      (not (cogido ?o ?j)))
  )

  (:action dejarmochila
    :parameters ( ?o - objeto ?j - jugador)
    :precondition (and
		    (cogido ?o ?j)
                    (mochilalibre ?j)
	            )
    :effect (and
              (manolibre ?j)
	      (not (mochilalibre ?j))
	      (not (cogido ?o ?j)))
              (enmochila ?o ?j)	      
  )

  (:action entregar
    :parameters ( ?z - zona ?o - objeto ?j - jugador ?p - personaje)
    :precondition (and
		    (cogido ?o ?j)
	            (at ?j ?z)
		    (at ?p ?z))
    :effect (and
	      (entregado ?o ?p)
              (manolibre ?j)
    	      (not (cogido ?o ?j)))
  )
)