/*
  5) Cursada 2020 - 2da fecha 

  Club = ( IdClub, nomClub, ciudad ) 
  Complejo = ( IdComplejo, nomComplejo, IdClub(fk) ) 
  Cancha = ( IdCancha, nomCancha, IdComplejo (fk), valorCancha) 
  Cliente = ( IdCliente, nomCliente, fechaNacimiento, direccion ) 
  Alquiler = ( IdAlquiler, fechaAlquiler, IdCliente(fk), IdCancha(fk), montoalquiler )

  Realizar 4-5-6 en AR y 1-2-3 en SQL 
*/


/*
  1. Listar nombre, fecha nacimiento y dirección de clientes que hayan alquilado durante 2019. 
*/
SELECT C.nomCliente, C.fechaNacimiento, C.direccion
FROM Cliente C
INNER JOIN Alquiler A ON ( C.IdCliente = A.IdCliente )
WHERE A.fechaAlquiler BETWEEN '2019-01-01' AND '2019-12-31';


/*
  2. Listar para cada cancha del complejo "Complejo 1", la cantidad de alquileres que se realizaron durante el 2020. 
  Informar nombre de la cancha y cantidad de alquileres.
*/
SELECT CA.nomCancha, COUNT(A.IdAlquiler) AS cantidad_alquileres
FROM Cancha CA
INNER JOIN Alquiler A ON ( CA.IdCancha = A.IdCancha )
INNER JOIN Complejo CO ON ( CA.IdComplejo = CO.IdComplejo )
WHERE CO.nomComplejo = 'Complejo 1'
  AND A.fechaAlquiler BETWEEN '2020-01-01' AND '2020-12-31';
GROUP BY CA.nomCancha;


/*
  3. Listar los complejos donde hayan alquilado canchas con monto del alquiler mayor a 1500 pesos. Informar nombre 
  del complejo, ordenar el resultado ascendentemente.
*/
SELECT DISTINCT CO.nomComplejo
FROM Complejo CO
INNER JOIN Cancha CA ON ( CO.IdComplejo = CA.IdComplejo )
INNER JOIN Alquiler A ON ( CA.IdCancha = A.IdCancha )
WHERE A.montoalquiler > 1500
ORDER BY CO.nomComplejo ASC;