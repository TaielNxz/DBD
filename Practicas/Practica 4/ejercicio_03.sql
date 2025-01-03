/* 
  Ejercicio 3
  Banda = (codigoB, nombreBanda, genero_musical, año_creacion)
  Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
  Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
  Recital = (fecha, hora, nroEscenario (fk), codigoB (fk))
*/

/* 
  1. Listar DNI, nombre, apellido, dirección y email de integrantes nacidos entre 1980 y 1990 y que
  hayan realizado algún recital durante 2023.  
*/
SELECT i.DNI, i.nombre, i.apellido, i.dirección, i.email
FROM Integrante
WHERE i.fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31'
AND i.codigoB IN (
  SELECT codigoB
  FROM Recital r
  WHERE r.fecha BETWEEN '2023-01-01' AND '2023-12-31'
)


/* 
  2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales 
  durante 2023, pero no hayan tocado durante 2022 . 
*/
SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b
INNER JOIN Recital r2023 ON (r2023.codigoB = b.codigoB)
WHERE r2023.fecha BETWEEN '2023-01-01' AND '2023-12-31'
AND b.codigoB NOT IN (
  SELECT r2022.codigoB
  FROM Recital r2022
  WHERE r2022.fecha BETWEEN '2022-01-01' AND '2022-12-31'
);


/* 
  3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
  ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente. 
*/
SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicación
FROM Recital r
INNER JOIN Banda b ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE r.fecha = '04/12/2023'


/* 
  4. Listar DNI, nombre, apellido, email de integrantes que hayan tocado en el escenario con nombre
  ‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’. 
*/
SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
WHERE i.codigoB IN (
  SELECT r1.codigoB
  FROM Recital r1
  INNER JOIN Escenario e1 ON (r1.nroEscenario = e1.nroEscenario)
  WHERE e1.nombre_escenario = 'Gustavo Cerati'
)
AND i.codigoB IN (
  SELECT r2.codigoB
  FROM Recital r2
  INNER JOIN Escenario e2 ON (r2.nroEscenario = e2.nroEscenario)
  WHERE e2.nombre_escenario = 'Carlos Gardel'
);


/* 
  5. Reportar nombre, género musical y año de creación de bandas que tengan más de 8 integrantes. 
*/
SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b
INNER JOIN Integrante i ON (i.codigoB = b.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.año_creacion
HAVING COUNT(i.DNI) > 8


/* 
  6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
  con el género musical rock and roll. Ordenar por nombre de escenario 
*/
SELECT r.nombre_escenario, r.ubicación, r.descripción
FROM Escenario e
WHERE NOT EXISTS (
  SELECT *
  FROM Recital r
  JOIN Banda b ON (r.codigoB = b.codigoB)
  WHERE (r.nroEscenario = e.nroEscenario)
  AND (b.genero_musical <> 'rock and roll')
)
ORDER BY e.nombre_escenario;


/* 
  7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
  escenarios cubiertos durante 2023.// cubierto es true, false según corresponda 
*/
SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.cubierto = true
AND r.fecha BETWEEN '2023-01-01' AND '2023-12-31';


/* 
  8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024. 
*/
SELECT e.nombre_escenario, COUNT(*), AS cantidad_recitales
FROM Escenario e
INNER JOIN Recital r ON (r.nroEscenario = e.nroEscenario)
WHERE r.fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY e.nombre_escenario;

SELECT e.nombre_escenario, COUNT(DISTINCT r.fecha, r.hora) AS cantidad_recitales
FROM Escenario e
JOIN Recital r ON e.nroEscenario = r.nroEscenario
WHERE r.fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY e.nombre_escenario;


/*
  9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’. 
*/
UPDATE Banda
SET nombreBanda = 'Memphis la Blusera'
WHERE nombreBanda = 'Mempis la Blusera';
