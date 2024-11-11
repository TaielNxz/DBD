/*
  Ejercicio 10

  Vehiculo = (patente, modelo, marca, peso, km)
  Camion = (patente(fk), largo, max_toneladas, cant_ruedas, tiene_acoplado)
  Auto = (patente(fk), es_electrico, tipo_motor)
  Service = (fecha, patente(fk), km_service, descripcion, monto)
  Parte = (cod_parte, nombre, precio_parte)
  Service_Parte = ( [fecha, patente](fk), cod_parte(fk), precio )

*/

/*
  1. Listar todos los datos de aquellos camiones que tengan entre 4 y 8 ruedas, y que hayan
  realizado algún service en los últimos 365 días. Ordenar por marca, modelo y patente.
*/
SELECT c.patente, c.largo, c.max_toneladas, c.cant_ruedas, c.tiene_acoplado
FROM Camion c 
WHERE c.cant_ruedas BETWEEN 4 AND 8
  AND c.patente in (
    SELECT s.patente 
    FROM Service
    WHERE s.fecha >= CURDATE() - INTERVAL 365 DAY
  )
ORDER BY c.marca, c.modelo, c.patente;

-- ALTERNATIVAS:
WHERE s.fecha >= NOW() - INTERVAL 1 YEAR;

WHERE s.fecha >= DATE_SUB(CURDATE(), INTERVAL 365 DAY);

WHERE TIMESTAMPDIFF(DAY, s.fecha, CURDATE()) <= 365;


/*
  2. Listar los autos que hayan realizado el service “cambio de aceite” antes de los 13.000 km o
  hayan realizado el service “inspección general” que incluya la parte “filtro de combustible”.
*/
SELECT a.patente, a.es_electrico, a.tipo_motor
FROM Auto a
INNER JOIN Service s ON ( a.patente = s.patente )
WHERE (s.descripcion = 'Cambio de aceite' AND s.km_service < 13000)
   OR a.patente IN (
    SELECT s2.patente
    FROM Service s2
    INNER JOIN Service_Parte sp ON ( s2.fecha = sp.fecha AND s2.patente = sp.patente )
    INNER JOIN Parte p ON ( sp.cod_parte = p.cod_parte )
    WHERE s2.descripcion = 'inspección general' 
      AND p.nombre = 'filtro de combustible'
  );


/*
  3. Listar nombre y precio de todas las partes que aparezcan en más de 30 services que hayan
  salido (partes) más de $4.000.
*/
SELECT p.nombre, p.precio_parte
FROM Parte p
INNER JOIN Service_Parte sp ON ( p.cod_parte = sp.cod_parte )
WHERE sp.precio > 4000
GROUP BY p.nombre, p.precio_parte
HAVING COUNT(sp.cod_parte) > 30;


/*
  4. Dar de baja todos los camiones con más de 250.000 km.
*/
DELETE FROM Service 
WHERE patente IN (
  SELECT patente 
  FROM Vehiculo
  WHERE km > 250000
);

DELETE FROM Camion 
WHERE patente IN ( 
  SELECT patente 
  FROM Vehiculo
  WHERE km > 250000 
);

DELETE FROM Vehiculo 
WHERE km > 250000;


/*
  5. Listar el nombre y precio de aquellas partes que figuren en todos los service realizados en el año
  actual.
*/
SELECT p.nombre, p.precio_parte
FROM Parte p
WHERE NOT EXISTS (
    SELECT 1
    FROM Service s
    WHERE YEAR(s.fecha) = YEAR(CURDATE())
      AND NOT EXISTS (
          SELECT 1
          FROM Service_Parte sp
          WHERE sp.cod_parte = p.cod_parte
            AND sp.patente = s.patente
            AND sp.fecha = s.fecha
      )
);

SELECT p.nombre, p.precio_parte
FROM Parte p
INNER JOIN Service_Parte sp ON ( p.cod_parte = sp.cod_parte )
INNER JOIN Service s ON ( sp.patente = s.patente AND sp.fecha = s.fecha )
WHERE YEAR(s.fecha) = YEAR(CURDATE())
GROUP BY p.nombre, p.precio_parte
HAVING COUNT(DISTINCT s.fecha || s.patente) = 
(
  SELECT COUNT(DISTINCT s.fecha || s.patente)
  FROM Service s
  WHERE YEAR(s.fecha) = YEAR(CURDATE())
)


/*
  6. Listar todos los autos que sean eléctricos. Mostrar información de patente, modelo, marca y
  peso.
*/
SELECT a.patente, v.modelo, v.marca, v.peso
FROM Auto a
INNER JOIN Vehiculo v ON ( a.patente = v.patente )
WHERE a.es_electrico = true;


/*
  7. Dar de alta una parte, cuyo nombre sea “Aleron” y precio $5000.
*/
INSERT INTO Parte (nombre, precio_parte)
VALUES ('Aleron', 5000);


/*
  8. Dar de baja todos los services que se realizaron al auto con patente ‘AWA564’.
*/
DELETE FROM Service_Parte
WHERE patente = 'AWA564';

DELETE FROM Service
WHERE patente = 'AWA564';


/*
  9. Listar todos los vehículos que hayan tenido services durante el 2024
*/
SELECT *
FROM Vehiculo v
INNER JOIN Service s ON ( v.patente = s.patente )
WHERE s.fecha BETWEEN '2024-01-01' AND '2024-12-31';