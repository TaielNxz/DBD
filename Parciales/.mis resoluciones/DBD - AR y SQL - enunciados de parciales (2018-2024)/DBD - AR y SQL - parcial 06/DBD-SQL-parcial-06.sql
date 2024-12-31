/*
  6) Redictado 2022 - 1ra fecha - 02/06/2022 

  Especialista = ( Matricula, nombre, apellido, domicilio ) 
  ObraSocial = ( nombre, descripción ) 
  Paciente = ( DNI, nombre, apellido, domicilio, telefono ) 
  Turno = ( Matricula (FK), DNI (FK), fecha, motivo, nombre (FK)?, observaciones? ) // El nombre es el de la Obra Social. 

  Realizar 1-2-3-4 en AR y 2-3-4-5-6 en SQL 
*/


/*
  2. Listar los datos de los pacientes que se atendieron con todos los especialistas.
*/
SELECT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P
WHERE NOT EXISTS (
    SELECT *
    FROM Especialista E
    WHERE NOT EXISTS (
        SELECT *
        FROM Turno T
        WHERE (T.DNI = P.DNI) AND (T.Matricula = E.Matricula)
    )
);


/*
  3. Listar las pacientes que se atendieron en el año 2021 pero no se atendieron en el año 2019. 
*/
SELECT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P
WHERE EXISTS (
    SELECT *
    FROM Turno T
    WHERE T.DNI = P.DNI 
      AND T.fecha BETWEEN '2021-01-01' AND '2021-12-31';
)
AND NOT EXISTS (
    SELECT *
    FROM Turno T
    WHERE T.DNI = P.DNI 
      AND T.fecha BETWEEN '2019-01-01' AND '2019-12-31';
);


/*
  4. Listar los pacientes que se atendieron por la obra social "OSDE" y también "IOMA". 
*/
SELECT DISTINCT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P
INNER JOIN Turno T ON ( P.DNI = T.DNI )
INNER JOIN ObraSocial O ON ( T.nombre = O.nombre )
WHERE O.nombre IN ('OSDE', 'IOMA')
GROUP BY P.DNI
HAVING COUNT(DISTINCT O.nombre) = 2;


/*
  5. Listar para cada especialista la cantidad de turnos en el 2022. 
*/
SELECT E.Matricula, E.nombre, E.apellido, COUNT(T.Matricula) AS cantidad_turnos
FROM Especialista E
LEFT JOIN Turno T ON ( E.Matricula = T.Matricula )
WHERE T.fecha BETWEEN '2022-01-01' AND '2022-12-31';
GROUP BY E.Matricula;


/*
  6. Listar los pacientes que se hayan atendido más de 5 veces en el año 2020.
*/
SELECT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P
INNER JOIN Turno T ON ( P.DNI = T.DNI )
WHERE T.fecha BETWEEN '2020-01-01' AND '2020-12-31';
GROUP BY P.DNI
HAVING COUNT(T.DNI) > 5;