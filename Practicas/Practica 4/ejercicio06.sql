/*
  Ejercicio 6

  Técnico = (codTec, nombre, especialidad) // técnicos
  Repuesto = (codRep, nombre, stock, precio) // repuestos
  RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en reparaciones.
  Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.
*/

/*
  1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.
*/
SELECT rto.nombre, rto.stock, rto.precio
FROM Repuesto rto
ORDER BY rto.precio


/*
  2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
  se usaron en reparaciones del técnico ‘José Gonzalez’.
*/
SELECT rto.nombre, rto.stock, rto.precio
FROM Repuesto rto
INNER JOIN RepuestoReparacion rr ON (rr.codRep = rto.codRep)
INNER JOIN Reparación rep ON (rep.nroReparac = rr.nroReparac)
WHERE rep.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  AND rto.codRep NOT IN (
    SELECT rr2.codRep
    FROM RepuestoReparacion rr2
    INNER JOIN Reparación rep2 ON (rep2.nroReparac = rr2.nroReparac)
    INNER JOIN Técnico tec ON (tec.codTec = rep2.codTec)
    WHERE tec.nombre = 'José Gonzalez'
  );


/*
  3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
  por nombre ascendentemente.
*/
SELECT tec.nombre, tec.especialidad
FROM Técnico tec
WHERE NOT EXISTS (
  SELECT *
  FROM Reparación rep
  WHERE rep.codTec = tec.codTec
)
ORDER BY tec.nombre;


/*
  4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones
  durante 2022.
*/
SELECT tec.nombre, tec.especialidad
FROM Técnico tec
INNER JOIN Reparación rep ON (rep.codTec = tec.codTec)
WHERE rep.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  AND NOT EXISTS (
    SELECT *
    FROM Reparación rep
    WHERE rep.codTec = tec.codTec 
      AND rep.fecha < '2023-01-01' OR rep.fecha > '2023-12-31'
  )
GROUP BY tec.codTec, tec.nombre, tec.especialidad; -- agrupamos por 'codTec' porque pueden haber nombres y especialidades repetidos

/* aternativa copada */
SELECT tec.nombre, tec.especialidad
FROM Técnico tec
INNER JOIN Reparación rep ON (rep.codTec = tec.codTec)
GROUP BY tec.codTec, tec.nombre, tec.especialidad
HAVING MIN(rep.fecha) >= '2022-01-01'
   AND MAX(rep.fecha) <= '2022-12-31';


/*
  5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un
  repuesto no participó en alguna reparación igual debe aparecer en dicho listado.
*/
SELECT rto.nombre, rto.stock, COUNT(DISTINCT rep.codTec) as cantidad_tecnicos
FROM Repuesto rto
LEFT JOIN RepuestoReparacion rr ON (rr.codRep = rto.codRep)
LEFT JOIN Reparación rep ON (rep.nroReparac = rr.nroReparac)
GROUP BY rto.nombre, rto.stock;
 

/*
  6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el
  técnico con menor cantidad de reparaciones.
*/
SELECT tec.nombre, tec.especialidad, COUNT(rep.nroReparac) AS cantidad_reparaciones
FROM Técnico tec
INNER JOIN Reparación rep ON (rep.codTec = tec.codTec)
GROUP BY tec.codTec, tec.nombre, tec.especialidad
HAVING COUNT(rep.nroReparac) >= ALL (
  SELECT COUNT(rep2.nroReparac)
  FROM Técnico tec2
  INNER JOIN Reparación rep2 ON (rep2.codTec = tec2.codTec)
  GROUP BY tec2.codTec
)
OR COUNT(rep.nroReparac) <= ALL (
  SELECT COUNT(rep2.nroReparac)
  FROM Técnico tec2
  INNER JOIN Reparación rep2 ON (rep2.codTec = tec2.codTec)
  GROUP BY tec2.codTec
)


/*
  7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
  no haya estado en reparaciones con un precio total superior a $10000.
*/
SELECT rto.nombre, rto.stock, rto.precio
FROM Repuesto rto
WHERE rto.stock > 0
  AND NOT EXISTS (
    SELECT *
    FROM RepuestoReparacion rr
    INNER JOIN Reparación rep ON (rep.nroReparac = rr.nroReparac)
    WHERE rr.codRep = rto.codRep
      AND rep.precio_total > 10000
  );


/*
  8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
  con precio en el momento de la reparación mayor a $10000 y menor a $15000.
*/
SELECT rep.nroReparac, rep.fecha, rep.precio_total
FROM Reparación rep
INNER JOIN RepuestoReparacion rr ON (rr.nroReparac = rep.nroReparac)
WHERE EXISTS (
  SELECT *
  FROM RepuestoReparacion rr2
  WHERE rr2.codRep = rr.codRep
    AND rr2.precio BETWEEN 10000 AND 15000
);


/*
  9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos.
*/
SELECT rto.nombre, rto.stock, rto.precio
FROM Repuesto rto
INNER JOIN RepuestoReparacion rr ON (rr.codRep = rto.codRep)
INNER JOIN Reparación rep ON (rep.nroReparac = rr.nroReparac)
GROUP BY rto.codRep, rto.nombre, rto.stock, rto.precio
HAVING COUNT(DISTINCT rep.codTec) = (SELECT COUNT(*) FROM Técnico)


/*
  10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10
  repuestos distintos.
*/
SELECT rep.fecha, t.nombre AS tecnico, rep.precio_total
FROM Reparación rep
INNER JOIN Técnico t ON (t.codTec = rep.codTec)
INNER JOIN RepuestoReparacion rr ON (rr.nroReparac = rto.nroReparac)
GROUP BY rep.nroReparac, rep.fecha, t.nombre, rep.precio_total
HAVING COUNT(DISTINCT rr.codRep) >= 10;