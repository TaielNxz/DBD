/*
  3) Cursada 2018 - 1ra fecha - 13/11/2018 

  Club = ( codigoClub, nombre, anioFundacion, codigoCiudad (FK) ) 
  Ciudad = ( codigoCiudad, nombre ) 
  Estadio = ( codigoEstadio, codigoClub(FK), nombre, direccion ) 
  Jugador = ( dni, nombre, apellido, edad, codigoCiudad (FK) ) 
  ClubJugador = ( codigoClub, dni, desde, hasta ) 

  Realizar 6-7-8-9 en AR y 1-2-3-4-5-6 en SQL 
*/


/*
  1. Reportar nombre y anioFundacion de aquellos clubes de la ciudad de La Plata que no poseen estadio.
*/
SELECT C.nombre, C.anioFundacion
FROM Club C
LEFT JOIN Estadio E ON ( C.codigoClub = E.codigoClub )
INNER JOIN Ciudad CI ON ( C.codigoCiudad = CI.codigoCiudad )
WHERE CI.nombre = 'La Plata' 
  AND E.codigoEstadio IS NULL;


/*
  2. Mostrar dni, nombre y apellido de aquellos jugadores que tengan más de 29 años y hayan jugado o juegan en al 
  menos un club de la ciudad de Córdoba.  
*/
SELECT DISTINCT J.dni, J.nombre, J.apellido
FROM Jugador J
INNER JOIN ClubJugador CJ ON ( J.dni = CJ.dni )
INNER JOIN Club C ON ( CJ.codigoClub = C.codigoClub )
INNER JOIN Ciudad Ci ON ( C.codigoCiudad = Ci.codigoCiudad )
WHERE J.edad > 29
  AND Ci.nombre = 'Córdoba';


/*
  3. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan actualmente en cada 
  uno. 
*/
SELECT C.nombre AS nombre_club, AVG(J.edad) AS edad_promedio
FROM Club C
INNER JOIN ClubJugador CJ ON ( C.codigoClub = CJ.codigoClub )
INNER JOIN Jugador J ON ( CJ.dni = J.dni )
WHERE CJ.hasta IS NULL
GROUP BY C.nombre;


/*
  4. Listar para cada jugador: nombre, apellido, edad y cantidad de clubes diferentes en los que jugó. (incluido el 
  actual) 
*/
SELECT J.nombre, J.apellido, J.edad, COUNT(DISTINCT CJ.codigoClub) AS cantidad_clubes
FROM Jugador J
INNER JOIN ClubJugador CJ ON ( J.dni = CJ.dni )
GROUP BY J.dni, J.nombre, J.apellido, J.edad;


/*
  5. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del Plata.
*/
SELECT C.nombre
FROM Club C
WHERE C.codigoClub NOT IN (
    SELECT DISTINCT CJ.codigoClub
    FROM ClubJugador CJ
    INNER JOIN Jugador J ON ( CJ.dni = J.dni )
    INNER JOIN Ciudad Ci ON ( J.codigoCiudad = Ci.codigoCiudad )
    WHERE Ci.nombre = 'Mar del Plata'
);


/*
  6. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes. 
*/
SELECT J.nombre, J.apellido
FROM Jugador J
WHERE NOT EXISTS (
    SELECT C.codigoClub
    FROM Club C
    WHERE C.codigoClub NOT IN (
        SELECT CJ.codigoClub
        FROM ClubJugador CJ
        WHERE CJ.dni = J.dni
    )
);