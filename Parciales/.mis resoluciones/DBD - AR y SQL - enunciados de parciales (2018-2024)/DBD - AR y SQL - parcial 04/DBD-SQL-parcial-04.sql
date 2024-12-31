/*
  4) Redictado 2020 

  Club = ( IdClub, nombreClub, ciudad ) 
  Complejo = ( IdComplejo, nombreComplejo, IdClub(fk) ) 
  Cancha = ( IdCancha, nombreCancha, IdComplejo(fk) ) 
  Entrenador = ( IdEntrenador, nombre Entrenador, fechaNacimiento, dirección ) 
  Entrenamiento = ( IdEntrenamiento, fecha, IdEntrenador (fk), IdCancha(fk) )

  Realizar 4-5-6 en AR y 1-2-3 en SQL  
*/


/*
  1. Listar nombre, fecha nacimiento y dirección de entrenadores que hayan tenido entrenamientos durante 2020. 
*/
SELECT E.nombreEntrenador, E.fechaNacimiento, E.dirección
FROM Entrenador E
INNER JOIN Entrenamiento EN ON ( E.IdEntrenador = EN.IdEntrenador )
WHERE EN.fecha BETWEEN '2020-01-01' AND '2020-12-31';


/*
  2. Listar para cada cancha del complejo "Complejo 1", la cantidad de entrenamientos que se realizaron durante el 
  2019. Informar nombre de la cancha y cantidad de entrenamientos.
*/
SELECT C.nombreCancha, COUNT(EN.IdEntrenamiento) AS cantidad_entrenamientos
FROM Cancha C
INNER JOIN Entrenamiento EN ON ( C.IdCancha = EN.IdCancha )
INNER JOIN Complejo CO ON ( C.IdComplejo = CO.IdComplejo )
WHERE CO.nombreComplejo = 'Complejo 1'
  AND BETWEEN '2019-01-01' AND '2019-12-31';
GROUP BY C.nombreCancha;


/*
  3. Listar los complejos donde haya realizado entrenamientos el entrenador "Jorge Gonzalez". Informar nombre de 
  complejo, ordenar el resultado de manera ascendente. 
*/
SELECT DISTINCT CO.nombreComplejo
FROM Complejo CO
INNER JOIN Cancha C ON ( CO.IdComplejo = C.IdComplejo )
INNER JOIN Entrenamiento EN ON ( C.IdCancha = EN.IdCancha )
INNER JOIN Entrenador E ON ( EN.IdEntrenador = E.IdEntrenador )
WHERE E.nombreEntrenador = 'Jorge Gonzalez'
ORDER BY CO.nombreComplejo ASC;