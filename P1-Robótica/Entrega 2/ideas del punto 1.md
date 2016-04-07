A la función getOneDeltaRepulsivo le hemos añadido las fórmulas de la página 22 de la sesión 3, tomando 100 como un valor lo suficientemente grande (teniendo en cuenta que el máximo de la fuerza atractiva es alfa*s). En función a ella, hemos completado setTotalRepulsivo de forma que calcule la suma de las fuerzas repulsivas de los obstáculos detectados. Una vez implementado el campo de repulsivo, lo usamos en el objeto planner del servidor.

Para que el campo de visión sea el deseado, hemos cambiado MIN_SCAN_ANGLE_RAD y MAX_SCAN_ANGLE_RAD a -135.0/180*M_PI y a +135.0/180*M_PI respectivamente. Así se barre en total un ángulo de 270º (centrado en el frente).

Para evitar que el robot se suicide cuando está intentando evitar un obstáculo pero el módulo de la fuerza es demasiado grande (disparando la velocidad), detectamos cuando la velocidad angular es mayor de lo normal y frenamos temporalmente la lineal para que le dé tiempo a hacer el giro.

Para resolver el problema de que la velocidad tienda a 0 cuando se acerca al objetivo, ponemos un tope a la reducción de la fuerza atractiva en función de la distancia que consideraba inicialmente la fórmula.

El resto de problemas lo resuelve lo de Iván.

Esto son sólo las ideas para que no tengas que mirártelo todo. Ya lo pones bonico y lo organizas como veas.

Por cierto, ponle que hemos ajustado los parámetros para que vaya suave; que eso siempre queda bien y vale como justificación de algunas cosas.
