/*
  Ejercicio 13

  Club = (IdClub, nombreClub, ciudad)
  Complejo = (IdComplejo, nombreComplejo, IdClub(fk))
  Cancha = (IdCancha, nombreCancha, IdComplejo(fk))
  Entrenador = (IdEntrenador, nombreEntrenador, fechaNacimiento, direccion)
  Entrenamiento = (IdEntrenamiento, fecha, IdEntrenador(fk), IdCancha(fk))
*/

/*
  1. Listar nombre, fecha de nacimiento y dirección de entrenadores que hayan tenido
  entrenamientos durante 2023.
*/
SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e
INNER JOIN Entrenamiento etm ON ( e.IdEntrenador = etm.IdEntrenador )
WHERE etm.fecha BETWEEN '2023-01-01' AND '2023-12-31';


/*
  2. Listar para cada cancha del complejo “Complejo 1”, la cantidad de entrenamientos que se
  realizaron durante el 2022. Informar nombre de la cancha y cantidad de entrenamientos.
*/
SELECT COUNT(*)
FROM Cancha ch
INNER JOIN Complejo cj ON ( ch.IdComplejo = cj.IdComplejo )
INNER JOIN Entrenamiento etm ON ( ch.IdCancha = etm.IdCancha )
WHERE cj.nombre = 'Complejo 1'
  AND etm.fecha BETWEEN '2023-01-01' AND '2023-12-31';


/*
  3. Listar los complejos donde haya realizado entrenamientos el entrenador “Jorge Gonzalez”.
  Informar nombre de complejo, ordenar el resultado de manera ascendente.
*/
SELECT COUNT(*)
FROM Cancha ch
INNER JOIN Complejo cj ON ( ch.IdComplejo = cj.IdComplejo )
INNER JOIN Entrenamiento etm ON ( ch.IdCancha = etm.IdCancha )
WHERE cj.nombre = 'Complejo 1'
  AND etm.fecha BETWEEN '2023-01-01' AND '2023-12-31';


/*
  4. Listar nombre, fecha de nacimiento y dirección de entrenadores que hayan entrenado en los
  clubes con nombre “Everton” y “Estrella de Berisso”.
*/
SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e
INNER JOIN Entrenamiento etm ON ( e.IdEntrenador = etm.IdEntrenador )
INNER JOIN Cancha ch ON ( etm.IdCancha = ch.IdCancha )
INNER JOIN Complejo cj ON ( ch.IdComplejo = cj.IdComplejo )
INNER JOIN Club cb ON ( cj.IdClub = cb.IdClub )
WHERE cb.nombre IN ('Everton', 'Estrella de Berisso');
GROUP BY  e.nombreEntrenador, e.fechaNacimiento, e.direccion
HAVING COUNT(DISTINCT cb.nombre) = 2;


SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e
INNER JOIN Entrenamiento etm ON ( e.IdEntrenador = etm.IdEntrenador )
INNER JOIN Cancha ch ON ( etm.IdCancha = ch.IdCancha )
INNER JOIN Complejo cj ON ( ch.IdComplejo = cj.IdComplejo )
INNER JOIN Club cb ON ( cj.IdClub = cb.IdClub )
WHERE cb.nombre IN 'Everton'
INTERSECT (
  SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
  FROM Entrenador e
  INNER JOIN Entrenamiento etm ON ( e.IdEntrenador = etm.IdEntrenador )
  INNER JOIN Cancha ch ON ( etm.IdCancha = ch.IdCancha )
  INNER JOIN Complejo cj ON ( ch.IdCancha = cj.IdCancha )
  INNER JOIN Club cb ON ( cj.IdClub = cb.IdClub )
  WHERE cb.nombre IN 'Estrella de Berisso'
)


/*
  5. Listar todos los clubes en los que entrena el entrenador “Marcos Perez”. Informar nombre del
  club y ciudad.
*/
SELECT cb.nombreClub, cb.ciudad
FROM Club cb
INNER JOIN Complejo cj ON ( cb.IdClub = cj.IdClub )
INNER JOIN Cancha ch ON ( cj.IdComplejo = ch.IdComplejo )
INNER JOIN Entrenamiento etm ON ( ch.IdCancha = etm.IdCancha )
INNER JOIN Entrenador e ON ( ech.IdEntrenador = e.IdEntrenador )
WHERE e.nombre = 'Marcos Perez'


/*
  6. Eliminar los entrenamientos del entrenador ‘Juan Perez’
*/
DELETE FROM Entrenamiento
WHERE IdEntrenador = (
  SELECT IdEntrenador
  FROM Entrenador
  WHERE nombreEntrenador = 'Juan Perez'
);