/*
  Ejercicio 8

  Equipo = (codigoE, nombreE, descripcionE)
  Integrante = (DNI, nombre, apellido, ciudad, email, telefono, codigoE(fk))
  Laguna = (nroLaguna, nombreL, ubicación,extension, descripción)
  TorneoPesca = (codTorneo, fecha,hora, nroLaguna(fk), descripcion)
  Inscripcion = (codTorneo(fk), codigoE(fk), asistio, gano) // asistio y gano son true o false según
  corresponda
*/

/*
  1. Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad ‘La Plata’ y estén
  inscriptos en torneos disputados en 2023.
*/
SELECT intg.DNI, intg.nombre, intg.apellido, intg.email
FROM Integrante intg
INNER JOIN Inscripcion insc ON ( intg.c = insc.codigoE )
INNER JOIN TorneoPesca tp ON ( insc.codTorneo = tp.codTorneo )
WHERE intg.ciudad = 'La Plata'
  AND tp.fecha BETWEEN '2023-01-01' AND '2023-12-31';


SELECT intg.DNI, intg.nombre, intg.apellido, intg.email
FROM Integrante intg
WHERE intg.ciudad = 'La Plata'
  AND intg.codigoE IN (
    SELECT i.codigoE
    FROM Inscripcion i
    INNER JOIN TorneoPesca tp ON ( i.codTorneo = tp.codTorneo )
    WHERE tp.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  )


/*
  2. Reportar nombre y descripción de equipos que solo se hayan inscripto en torneos de 2020.
*/
SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Inscripcion insc ON ( e.codigoE = insc.codigoE )
INNER JOIN TorneoPesca tp ON ( tp.codTorneo = insc.codTorneo )
WHERE tp.fecha BETWEEN '2020-01-01' AND '2020-12-31'
EXCEPT (
    SELECT e.nombreE, e.descripcionE
    FROM Equipo e
    INNER JOIN Inscripcion insc ON ( e.codigoE = insc.codigoE )
    INNER JOIN TorneoPesca tp ON ( tp.codTorneo = insc.codTorneo )
    WHERE tp.fecha < '2020-01-01' 
       OR tp.fecha > '2020-12-31'
  )


/*
  3. Listar DNI, nombre, apellido, email y ciudad de integrantes que asistieron a torneos en la laguna con
  nombre ‘La Salada, Coronel Granada’ y su equipo no tenga inscripciones a torneos disputados en
  2023.
*/
SELECT intg.DNI, intg.nombre, intg.apellido, intg.email, intg.ciudad
FROM Integrante intg
INNER JOIN Inscripcion insc ON ( intg.codigoE = insc.codigoE )
INNER JOIN TorneoPesca tp ON ( insc.codTorneo = tp.codTorneo )
INNER JOIN Laguna l ON ( l.nroLaguna = tp.nroLaguna )
WHERE l.nombre = 'La Salada, Coronel Granada'
  AND intg.codigoE NOT IN (
    SELECT intg2.codigoE
    FROM Integrante intg2
    INNER JOIN Inscripcion insc2 ON ( intg2.codigoE = insc2.codigoE )
    INNER JOIN TorneoPesca tp2 ON ( insc2.codTorneo = tp2.codTorneo )
    WHERE tp2.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  );


/*
  4. Reportar nombre y descripción de equipos que tengan al menos 5 integrantes. Ordenar por nombre.
*/
SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Integrante intg ON ( e.codigoE = intg.codigoE )
GROUP BY e.codigoE, e.nombreE, e.descripcionE
HAVING COUNT(intg.DNI) >= 5
ORDER BY e.nombreE;


/*
  5. Reportar nombre y descripción de equipos que tengan inscripciones en todas las lagunas.
*/
SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Inscripcion insc ON ( e.codigoE = insc.codigoE )
INNER JOIN TorneoPesca tp ON ( insc.codTorneo = tp.codTorneo )
GROUP BY e.codigoE, e.nombreE, e.descripcionE
HAVING COUNT(DISTINCT tp.nroLaguna) = (SELECT COUNT(*) FROM Laguna);


/*
  6. Eliminar el equipo con código 10000.
*/
DELETE FROM Equipo
WHERE codigoE = 10000;


/*
  7. Listar nombre, ubicación, extensión y descripción de lagunas que no tuvieron torneos.
*/
SELECT l.nombreL, l.ubicación, l.extension, l.descripcion
FROM Laguna l 
WHERE l.nroLaguna NOT IN (
  SELECT tp.nroLaguna
  FROM TorneoPesca tp
)

SELECT l.nombreL, l.ubicación, l.extension, l.descripción
FROM Laguna l
LEFT JOIN TorneoPesca tp ON ( l.nroLaguna = tp.nroLaguna )
WHERE tp.codTorneo IS NULL;


/*
  8. Reportar nombre y descripción de equipos que tengan inscripciones a torneos a disputarse durante
  2024, pero no tienen inscripciones a torneos de 2023.
*/
SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Inscripcion insc ON ( e.codigoE = insc.codigoE )
INNER JOIN TorneoPesca tp ON ( tp.codTorneo = insc.codTorneo )
WHERE insc.fecha BETWEEN '2023-01-01' AND '2023-12-31'


/*
  9. Listar DNI, nombre, apellido, ciudad y email de integrantes que ganaron algún torneo que se disputó
  en la laguna con nombre: ‘Laguna de Chascomús’.
*/
SELECT intg.DNI, intg.nombre, intg.apellido, intg.ciudad, intg.email
FROM Integrante intg
INNER JOIN Inscripcion insc ON ( intg.codigoE = insc.codigoE )
INNER JOIN TorneoPesca tp ON ( insc.codTorneo = tp.codTorneo )
INNER JOIN Laguna l ON ( tp.nroLaguna = l.nroLaguna )
WHERE l.nombre = 'Laguna de Chascomús'
  AND insc.gano = TRUE;