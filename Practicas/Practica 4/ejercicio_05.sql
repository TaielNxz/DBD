/*
  Ejercicio 5

  AGENCIA = (RAZON_SOCIAL, dirección, telef, mail)
  CIUDAD = (CODIGOPOSTAL, nombreCiudad, añoCreación)
  CLIENTE = (DNI, nombre, apellido, teléfono, dirección)
  VIAJE = (FECHA, HORA, DNI (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
  
  cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje
*/

/*
  1. Listar raón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
  Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por
  teléfono.
*/
SELECT a.RAZON_SOCIAL, a.dirección, a.telef
FROM AGENCIA a
INNER JOIN VIAJE v ON (v.razon_social = a.RAZON_SOCIAL)
INNER JOIN CIUDAD c ON (c.CODIGOPOSTAL = v.cpOrigen)
INNER JOIN CLIENTE cli ON (cli.DNI = v.DNI)
WHERE c.nombreCiudad = 'La Plata'
  AND cli.apellido = 'Roma'
ORDER BY a.RAZON_SOCIAL, a.telef;


/*
  2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes
  realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.
*/
SELECT v.FECHA, v.HORA, c.DNI, c.nombre, c.apellido, c.teléfono, c.dirección, v.cpOrigen, v.cpDestino
FROM VIAJE v
INNER JOIN CLIENTE c ON (c.DNI = v.DNI)
WHERE v.FECHA BETWEEN '2019-01-01' AND '2019-12-31'
  AND v.descripcion LIKE '%demorado%';


/*
  3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
  mail que termine con ‘@jmail.com’.
*/
SELECT a.RAZON_SOCIAL, a.dirección, a.telef, a.mail
FROM AGENCIA a
WHERE a.mail LIKE '%@jmail.com'
   OR a.razon_social IN (
    SELECT v.razon_social
    FROM VIAJE v
    WHERE v.FECHA BETWEEN '2019-01-01' AND '2019-12-31'
   );


/*
  4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
  Brandsen’
*/
SELECT cli.DNI, cli.nombre, cli.apellido, cli.teléfono, cli.dirección
FROM CLIENTE cli
WHERE cli.DNI IN (
  SELECT v.DNI
  FROM VIAJE v
  INNER JOIN CIUDAD ciu ON v.CODIGOPOSTAL = ciu.cpDestino
  WHERE ciu.nombreCiudad = 'Coronel Brandsen'
)


/*
  5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’.
*/
SELECT COUNT(*)
FROM VIAJE v
INNER JOIN AGENCIA a ON v.RAZON_SOCIAL = a.razon_social
INNER JOIN CIUDAD ciu ON v.CODIGOPOSTAL = ciu.cpDestino
WHERE a.RAZON_SOCIAL = 'TAXI Y'
  AND ciu.nombreCiudad = 'Villa Elisa';


/*
  6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias.
*/
SELECT c.nombre, c.apellido, c.dirección, c.teléfono
FROM CLIENTE c
INNER JOIN VIAJE v ON c.DNI = v.DNI
GROUP BY c.DNI, c.nombre, c.apellido, c.dirección, c.teléfono
HAVING COUNT(DISTINCT v.razon_social) = (SELECT COUNT(*) FROM AGENCIA);


/*
  7. Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’.
*/
UPDATE CLIENTE
SET teléfono = '221-4400897'
WHERE DNI = 38495444;


/*
  8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
  realizados.
*/
SELECT a.RAZON_SOCIAL, a.dirección, a.telef
FROM AGENCIA a
INNER JOIN VIAJE v ON v.razon_social = a.RAZON_SOCIAL
GROUP BY a.RAZON_SOCIAL, a.dirección, a.telef
HAVING COUNT(*) >= ALL (
  SELECT COUNT(*)
  FROM VIAJE
  GROUP BY razon_social
);


/*
  9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes.
*/
SELECT cli.DNI, cli.nombre, cli.apellido, cli.teléfono, cli.dirección
FROM CLIENTE cli
INNER JOIN VIAJE v ON v.DNI = cli.DNI
GROUP BY cli.DNI, cli.nombre, cli.apellido, cli.teléfono, cli.dirección
HAVING COUNT(*) >= 10;


/*
  10. Borrar al cliente con DNI 40325692.
*/
DELETE FROM CLIENTE
WHERE DNI = 40325692;