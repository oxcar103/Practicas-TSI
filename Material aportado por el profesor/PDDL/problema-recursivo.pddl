(define (problem pelis0) (:domain pelis)
(:customization
(= :time-format "%d/%m/%Y %H:%M:%S")
(= :time-horizon-relative 2500)
(= :time-start "05/06/2007 08:00:00")
(= :time-unit :hours))

(:objects 
    merchi virgi juanito juan manoli - person

)
(:init
   (edad juanito 1)
   (edad merchi 9)
   (edad virgi 12)
   (edad juan 45)
   (edad manoli 43)
   (en-cola juanito)
   (en-cola merchi)
   (en-cola virgi)
   (en-cola manoli)
   (en-cola juan)
 )


(:tasks-goal
   :tasks(
   (infiere))))