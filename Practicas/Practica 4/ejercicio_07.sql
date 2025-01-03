/*
  Ejercicio 7

  Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
  Ciudad = (codigoCiudad, nombre)
  Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
  Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
  ClubJugador = (codigoClub (FK), DNI (FK), desde, hasta)
*/

/*
  1. Reportar nombre y año de fundación de aquellos clubes de la ciudad de La Plata que no poseen
  estadio.
*/
SELECT cl.nombre, cl.anioFundacion
FROM Club cl
INNER JOIN Ciudad c ON (c.codigoCiudad = cl.codigoCiudad)
LEFT JOIN Estadio e ON (e.codigoClub = e.codigoClub)
WHERE c.nombre = 'La Plata' AND codigoEstadio IS NULL;


/*
  2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso.
*/
SELECT cl.nombre
FROM Club cl
WHERE cl.codigoClub NOT IN (
  SELECT cj.codigoClub
  FROM ClubJugador cj
  INNER JOIN Jugador j ON (j.DNI = cj.DNI)
  INNER JOIN Ciudad c ON (c.codigoCiudad = j.codigoCiudad)
  WHERE c.nombre = 'Berisso'
);


/*
  3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia
  y Esgrima La Plata.
*/
SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j
WHERE j.DNI IN (
  SELECT cj.DNI
  FROM ClubJugador cj
  INNER JOIN Club cl ON ( cl.codigoClub = cj.codigoClub )
  WHERE cl.nombre = 'Gimnasia y Esgrima La Plata'
);


/*
  4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y hayan
  jugado o juegan en algún club de la ciudad de Córdoba.
*/
SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j
WHERE j.edad > 29 
  AND j.DNI IN (
    SELECT cj.DNI
    FROM ClubJugador cj
    INNER JOIN Club cl ON ( cl.codigoClub = cj.codigoClub )
    INNER JOIN Ciudad ciu ON ( ciu.codigoCiudad = cl.codigoCiudad )
    WHERE ciu.nombre = 'Córdoba'
);


SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j
INNER JOIN ClubJugador cj ON ( cj.DNI = j.DNI )
INNER JOIN Club cl ON ( cl.codigoClub = cj.codigoClub )
INNER JOIN Ciudad ciu ON ( ciu.codigoCiudad = cl.codigoCiudad )
WHERE j.edad > 29 
  AND ciu.nombre = 'Córdoba'


/*
  5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
  actualmente en cada uno.
*/
SELECT cl.nombre, AVG(j.edad) AS edad_en_promedio
FROM Club cl
INNER JOIN ClubJugador cj ON ( cj.codigoClub = cl.codigoClub )
INNER JOIN Jugador j ON ( cj.DNI = j.DNI )
WHERE cj.hasta IS NULL  --> asumo que el campo es NULL si el jugador sigue activo
GROUP BY cl.nombre;


/*
  6. Listar para cada jugador nombre, apellido, edad y cantidad de clubes diferentes en los que jugó.
  (incluido el actual)
*/
SELECT j.DNI, j.nombre, j.apellido, COUNT(DISTINCT c.codigoClub) AS cantidad_clubes
FROM Jugador j
INNER JOIN ClubJugador cj ON ( cj.DNI = j.DNI )
INNER JOIN Club cl ON ( cl.codigoClub = cj.codigoClub )
GROUP BY j.DNI, j.nombre, j.apellido;


/*
  7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del
  Plata.
*/
SELECT cl.nombre
FROM Club cl
WHERE cl.codigoClub NOT IN (
    SELECT cj.codigoClub
    FROM ClubJugador cj
    INNER JOIN Jugador j ON ( cj.DNI = j.DNI )
    INNER JOIN Ciudad ciu ON ( j.codigoCiudad = ciu.codigoCiudad )
    WHERE ciu.nombre = 'Mar del Plata'
)


/*
  8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la
  ciudad de Córdoba.
*/
SELECT j.nombre, j.apellido
FROM Jugador j
INNER JOIN ClubJugador cj ON ( cj.DNI = j.DNI )
INNER JOIN Club cl ON cl.codigoClub = cj.codigoClub
INNER JOIN Ciudad ciu ON cl.codigoCiudad = ciu.codigoCiudad
WHERE ciu.nombre = 'Córdoba'
GROUP BY j.DNI, j.nombre, j.apellido
HAVING COUNT(DISTINCT cl.codigoClub) = (
  SELECT COUNT(*)
  FROM Club c
  INNER JOIN Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
  WHERE ci.nombre = 'Córdoba'
)


/*
  9. Agregar el club “Estrella de Berisso”, con código 1234, que se fundó en 1921 y que pertenece a
  la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club.
*/
INSERT INTO Club
SET VALUES ( 1234, 'Estrella de Berisso', 1921, 
  (
    SELECT c.codigoCiudad
    FROM Ciudad c
    WHERE c.nombre = 'Berisso'
  )
)