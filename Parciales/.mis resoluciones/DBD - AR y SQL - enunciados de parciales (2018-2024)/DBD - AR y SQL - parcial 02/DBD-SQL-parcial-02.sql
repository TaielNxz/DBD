/*
  2) Redictado 2018 - 1er recuperatorio - 05/07/2018

  AGENCIA = ( RAZONSOCIAL, dirección, teléfono, e-mail ) 
  CIUDAD = ( CODIGOPOSTAL, nombreCiudad, anioCreación ) 
  CLIENTE = ( DNI, nombre, apellido, teléfono, dirección, cpLocalidad (FK) ) 
  VIAJE = ( FECHA, HORA, DNI(FK), cpOrigen (FK), cpDestino(FK), razonSocial(FK), descripción )

  Realizar 1-2-3-4-5 en AR y 1-2-3-4-5-6-7 en SQL 
*/


/*
  1. Listar apellido y nombre de clientes que viajaron con ciudad destino 'San Miguel del Monte' pero no viajaron con 
  ciudad destino 'Las Flores'. En SQL ordenar por apellido y nombre 
*/
SELECT C.apellido, C.nombre
FROM CLIENTE C
WHERE EXISTS (
    SELECT *
    FROM VIAJE V
    INNER JOIN CIUDAD CD ON ( V.cpDestino = CD.CODIGOPOSTAL )
    WHERE ( V.DNI = C.DNI AND CD.nombreCiudad = 'San Miguel del Monte' )
)
AND NOT EXISTS (
    SELECT *
    FROM VIAJE V
    INNER JOIN CIUDAD CD ON ( V.cpDestino = CD.CODIGOPOSTAL )
    WHERE ( V.DNI = C.DNI AND CD.nombreCiudad = 'Las Flores' )
)
ORDER BY C.apellido, C.nombre;


/*
  2. Listar DNI, apellido y nombre de los clientes que realizaron viajes durante 2017 o que hayan viajado por la agencia 
  ubicada en la dirección 50 y 120. En SQL ordenar por apellido y nombre 
*/
SELECT C.DNI, C.apellido, C.nombre
FROM CLIENTE C
INNER JOIN VIAJE V ON ( C.DNI = V.DNI )
INNER JOIN AGENCIA A ON ( V.razonSocial = A.RAZONSOCIAL )
WHERE V.FECHA BETWEEN '2017-01-01' AND '2017-12-31' 
   OR A.dirección = '50 y 120'
ORDER BY C.apellido, C.nombre;


/*
  3. Eliminar la agencia con nombre "Los Tilos".
*/
DELETE FROM AGENCIA
WHERE ( RAZONSOCIAL = 'Los Tilos' );


/*
  4. Lista apellido, nombre, teléfono y ciudad de clientes que hayan viajado a "Mar del Plata" y a "Carlos Paz".
*/
SELECT DISTINCT C.apellido, C.nombre, C.telefono, CI.nombreCiudad
FROM CLIENTE C
INNER JOIN VIAJE V ON ( C.DNI = V.DNI )
INNER JOIN CIUDAD CI ON ( V.cpDestino = CI.CODIGOPOSTAL )
WHERE CI.nombreCiudad = 'Mar del Plata'
AND C.DNI IN (
    SELECT V2.DNI
    FROM VIAJE V2
    INNER JOIN CIUDAD CI2 ON ( V2.cpDestino = CI2.CODIGOPOSTAL )
    WHERE CI2.nombreCiudad = 'Carlos Paz'
);


/*
  5. Listar las ciudades que no poseen viajes (tanto origen como destino) durante el año 2017. En SQL ordenar por 
  nombre de ciudad.
*/
SELECT CI.nombreCiudad
FROM CIUDAD CI
LEFT JOIN VIAJE V1 ON ( CI.CODIGOPOSTAL = V1.cpOrigen AND YEAR(V1.FECHA) = 2017 )
LEFT JOIN VIAJE V2 ON ( CI.CODIGOPOSTAL = V2.cpDestino AND YEAR(V2.FECHA) = 2017 )
WHERE ( V1.cpOrigen IS NULL AND V2.cpDestino IS NULL )
ORDER BY CI.nombreCiudad;


/*
  6. Reportar nombre, apellido, dirección y teléfono de clientes con más de 10 viajes. Ordenar por apellido y nombre.
*/
SELECT C.nombre, C.apellido, C.dirección, C.telefono
FROM CLIENTE C
INNER JOIN VIAJE V ON ( C.DNI = V.DNI )
GROUP BY C.DNI, C.nombre, C.apellido, C.dirección, C.telefono
HAVING COUNT(V.FECHA) > 10
ORDER BY C.apellido, C.nombre;


/*
  7. Listar razón social, dirección y teléfono de las agencias que registren viajes (tener en cuenta solo los destinos) a 
  todas las ciudades.
*/
SELECT A.RAZONSOCIAL, A.dirección, A.teléfono
FROM AGENCIA A
WHERE NOT EXISTS (
    SELECT *
    FROM CIUDAD CI
    WHERE NOT EXISTS (
        SELECT *
        FROM VIAJE V
        WHERE ( V.razonSocial = A.RAZONSOCIAL AND V.cpDestino = CI.CODIGOPOSTAL )
    )
);