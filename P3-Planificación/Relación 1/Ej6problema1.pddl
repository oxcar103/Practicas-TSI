(define (problem BW-6_1)
   (:domain BelkamWorld)

   (:objects
      Oxcar103 - jugador
      Princesa - personaje
      Principe - personaje
      Bruja - personaje
      Profesor - personaje
      LeonardoDiCaprio - personaje
      Oscar - objeto
      Manzana - objeto
      Rosa - objeto
      Algoritmo - objeto
      Oro - objeto
      Zapatilla - objeto
      Bikini - objeto
      z0 - zona
      z1 - zona
      z2 - zona
      z3 - zona
      z4 - zona
      z5 - zona
      z6 - zona
      z7 - zona
      z8 - zona
      z9 - zona
      z10 - zona
      z11 - zona
      z12 - zona
      z13 - zona
      z14 - zona
      z15 - zona
      z16 - zona
      z17 - zona
      z18 - zona
      z19 - zona
      z20 - zona
      z21 - zona
      z22 - zona
      z23 - zona
      z24 - zona
   )

   (:init
      (manolibre Oxcar103)
      (= (usomochila Oxcar103) 0)
      (= (capacidadmochila Oxcar103) 3)
      (= (energia Oxcar103) 103)
      (at Oxcar103 z4)
      (at Princesa z15)
      (at Principe z23)
      (at Bruja z2)
      (at Profesor z7)
      (at LeonardoDiCaprio z10)
      (at Oscar z2)
      (at Oscar z14)
      (at Manzana z5)
      (at Manzana z8)
      (at Manzana z20)
      (at Rosa z17)
      (at Algoritmo z4)
      (at Algoritmo z6)
      (at Oro z24)
      (at Oro z12)
      (at Oro z5)
      (at Oro z1)
      (at Oro z0)
      (at Zapatilla z5)
      (at Zapatilla z24)
      (at Bikini z13)
      (conectada z0 z5)
      (conectada z1 z2)
      (conectada z1 z7)
      (conectada z2 z3)
      (conectada z4 z5)
      (conectada z5 z6)
      (conectada z5 z8)
      (conectada z6 z9)
      (conectada z7 z11)
      (conectada z8 z9)
      (conectada z8 z14)
      (conectada z9 z10)
      (conectada z9 z15)
      (conectada z10 z11)
      (conectada z11 z12)
      (conectada z11 z16)
      (conectada z12 z22)
      (conectada z13 z14)
      (conectada z13 z18)
      (conectada z14 z15)
      (conectada z16 z21)
      (conectada z17 z18)
      (conectada z18 z19)
      (conectada z18 z23)
      (conectada z20 z21)
      (conectada z21 z22)
      (conectada z21 z24)
      (eszapatilla Zapatilla)
      (esbikini Bikini)
      (esarena z0)
      (esbosque z1)
      (espiedra z2)
      (esbosque z3)
      (esarena z4)
      (esarena z5)
      (esagua z6)
      (espiedra z7)
      (esbosque z8)
      (espiedra z9)
      (esagua z10)
      (esarena z11)
      (esarena z12)
      (esbosque z13)
      (esarena z14)
      (esagua z15)
      (esarena z16)
      (esprecipicio z17)
      (espiedra z18)
      (esarena z19)
      (esprecipicio z20)
      (esarena z21)
      (esbosque z22)
      (esagua z23)
      (esprecipicio z24)
      (= (puntos) 0)
      (= (puntosentrega Oscar LeonardoDiCaprio) 10)
      (= (puntosentrega Oscar Princesa) 5)
      (= (puntosentrega Oscar Bruja) 4)
      (= (puntosentrega Oscar Profesor) 3)
      (= (puntosentrega Oscar Príncipe) 1)
      (= (puntosentrega Rosa LeonardoDiCaprio) 1)
      (= (puntosentrega Rosa Princesa) 10)
      (= (puntosentrega Rosa Bruja) 5)
      (= (puntosentrega Rosa Profesor) 4)
      (= (puntosentrega Rosa Príncipe) 3)
      (= (puntosentrega Manzana LeonardoDiCaprio) 3)
      (= (puntosentrega Manzana Princesa) 1)
      (= (puntosentrega Manzana Bruja) 10)
      (= (puntosentrega Manzana Profesor) 5)
      (= (puntosentrega Manzana Príncipe) 4)
      (= (puntosentrega Algoritmo LeonardoDiCaprio) 4)
      (= (puntosentrega Algoritmo Princesa) 3)
      (= (puntosentrega Algoritmo Bruja) 1)
      (= (puntosentrega Algoritmo Profesor) 10)
      (= (puntosentrega Algoritmo Príncipe) 5)
      (= (puntosentrega Oro LeonardoDiCaprio) 5)
      (= (puntosentrega Oro Princesa) 4)
      (= (puntosentrega Oro Bruja) 3)
      (= (puntosentrega Oro Profesor) 1)
      (= (puntosentrega Oro Príncipe) 10)
   )

   (:goal (:metric maximize (puntos))
   )
)