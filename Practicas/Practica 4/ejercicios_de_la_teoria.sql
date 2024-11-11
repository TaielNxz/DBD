/*
  * Dadas las siguientes tablas:
    * Cliente ( id_cliente, nombre_cliente, renta_anual, tipo_cliente)
    * Embarque ( embarque_#, id_cliente, peso, camión_#, destino, fecha )
    * Camión ( camión_#, nombre_chofer )
    * Ciudad ( nombre_ciudad, población )
*/

/* 1. Cuál es el nombre del cliente 433? */
SELECT nombre
FROM Cliente
WHERE id_cliente = "433"

/* 2. Cuál es la ciudad destino del embarque 3244? */
SELECT destino
FROM Embarque
WHERE embarque_# = 3244

/* 3. Cuales son los números de los camiones que han llevado paquetes (embarques) por encima de 100 kg? */
SELECT camión_#
FROM Embarque
WHERE peso > 100

/* 4. Presente todos los datos de los embarques de más de 20 kg? */
SELECT *
FROM Embarque
WHERE peso > 20

/* 5. Cree una lista por orden alfabético de los clientes con renta anual de más de 10 millones? */
SELECT nombre
FROM Cliente
WHERE renta_anual > 10000000
GROUP BY nombre

/* 6. Cual es el Id del cliente José García? */
SELECT id_cliente
FROM Cliente
WHERE nombre = "José García"

/* 7. Mostrar los nombres de los clientes que han enviado embarques a las ciudades cuyo nombre empieza con C. */
SELECT c.nombre
FROM Cliente c 
INNER JOIN Embarque e ON (c.id_cliente = e.id_cliente)
WHERE e.destino LIKE "C%"

/* 8. Mostrar los nombres de los clientes que han enviado embarques a las ciudades cuyo nombre termina con City. */
SELECT c.nombre
FROM Cliente c 
INNER JOIN Embarque e ON (c.id_cliente = e.id_cliente)
WHERE e.destino LIKE "&City" 

/* 9. Mostrar los nombres de los clientes que tienen una D como tercera letra del nombre. */
SELECT nombre
FROM Cliente
WHERE nombre LIKE "__D%"

/* 10. Mostrar los nombres de los clientes que sean minoristas. */
SELECT nombre
FROM Cliente
WHERE tipo_cliente = "minorista"

/* 11. Cómo se llaman los clientes que han enviado paquetes a Bariloche? */ 
SELECT c.nombre
FROM Cliente c
INNER JOIN Embarque e ON (c.id_cliente = e.id_cliente)
WHERE b.destino = "Bariloche"

/* 12. A cuales destinos han hecho envíos las compañías con renta anual menor que 1 millón? */
SELECT e.destino
FROM Embarque e
INNER JOIN Cliente c ON (e.id_cliente = c.id_cliente)
WHERE (c.renta_anual > 1000000) AND (tipo_cliente = "compañías")

/* 13. Cuales son los nombres y las poblaciones de las ciudades que han recibido embarques que pesen más de 100 kg? */ 
SELECT DISTINCT C.nombre_ciudad, C.población
FROM Ciudad c
INNER JOIN Embarque e ON (e.destino = c.nombre_ciudad)
WHERE e.peso > 100

/* 14. Cuales son los clientes que tienen más de 5 millones de renta anual y que han enviado embarques de menos de 1 kg? */
SELECT DISTINCT C.nombre_ciudad, C.población
FROM Ciudad c
INNER JOIN Embarque e ON (e.destino = c.nombre_ciudad)
WHERE e.peso > 100

/* 15. Quienes son los clientes que tienen más de 5 millones de renta anual y que han enviado embarques de menos de 1kg. 
O han enviado embarques a Villa La Angostura? */
SELECT c.nombre_cliente
FROM Cliente c
INNER JOIN Embarque e ON (e.id_cliente = c.id_cliente)
WHERE (c.renta_anual > 5000000 AND e.peso < 1) OR e.destino = "Villa La Angostura"

/* 16. Quienes son los choferes que han conducido embarques de clientes que tienen renta anual mayor de 20 millones a 
ciudades con más de 1 millón de habitantes? */
SELECT ca.nombre_cliente
FROM Cliente c
INNER JOIN Embarque e ON (e.id_cliente = c.id_cliente)
INNER JOIN Camión ca ON (ca.camión_# = e.camión_#)
INNER JOIN Ciudad ci ON (ci.nombre_ciudad = e.destino)
WHERE c.renta_anual > 20000000 AND ci.nombre_ciudad > 1000000

/* 17. Indique los choferes que han transportado embarques a cada una de las ciudades. */
SELECT ca.nombre_chofer
FROM Camión ca
WHERE NOT EXIST ( SELECT *
                  FROM ciudad c
                  WHERE NOT EXIST ( SELECT *
                                    FROM embarques e
                                    WHERE e.destino = c.nombre_ciudad AND e.camion_# = c.id_cliente
                  )  
)

/* 18. Indique las ciudades que han recibido embarques de clientes que tienen más de 15 millones de renta anual. */
SELECT e.destino
FROM Embarque
INNER JOIN Cliente cli ON ( e.id_cliente = cli.id_cliente )
WHERE cli.renta_anual > 15000000 


/* 19. Indique el nombre y la renta anual de los clientes que han enviado embarques que pesan más de 100 kg. */
SELECT nombre_cliente, renta_anual
FROM Cliente cli
INNER JOIN Embarque e ON ( cli.id_cliente = e.id_cliente )
WHERE e.peso > 100

/* 20. Indique los clientes que han tenido embarques transportados en cada camión. */
SELECT cli.nombre_cliente
FROM Cliente cli
WHERE WHERE NOT ( SELECT *
                  FROM Camión ca
                  WHERE NOT EXIST ( SELECT *
                                    FROM Embarque e
                                    WHERE e.camion_# = ca.camion_#
)

/* 21. Cual es el peso promedio de los embarques? */
SELECT embarque_# AVG(peso)
FROM Embarque

/* 22. Cual es el peso promedio de los embarques que van a Neuquén? */
SELECT embarque_# AVG(peso)
FROM Embarque
WHERE destino = "Newquén"

/* 23. Presente una lista de los clientes para los que todos sus embarques han pesado más de 25 kg. */
SELECT nombre_cliente
FROM Cliente
WHERE id_cliente IN ( SELECT id_cliente
                      FROM Embarque
                      WHERE peso > 25
)

/* 24. Cuales ciudades de la BD tienen la menor y la mayor población? */
SELECT nombre_ciudad
FROM Ciudad
WHERE población = ( SELECT MIN(población)
                    FROM Ciudad
)

SELECT nombre_ciudad
FROM Ciudad
WHERE población = ( SELECT MAX(población)
                    FROM Ciudad
)

/* 25. Agregue el camión 95 con el chofer García a la BD */
INSERT INTO Camion("Garcia")

/* 26. Borre de la BD todas las ciudades con población de menos de 5000 habitantes. Debe sacar, además los embarques que haya en dicha ciudad. */
DELETE FROM Embarques
WHERE destino IN ( SELECT nombre_ciudad 
                   FROM Ciudad
                   WHERE población < 5000
)

DELETE FROM Ciudad
WHERE población < 5000

/* 27. Borre de la BD todas las ciudades con población de menos de 5000 habitantes que no posean embarques enviados. */
DELETE FROM Ciudad
WHERE (población < 5000) AND ( SELECT *
                               FROM Ciudad ci
                               WHERE NOT EXIST ( SELECT *
                                                 FROM Embarque e
                                                 WHERE e.destino = ci.nombre_ciudad
                              )
)

/* 28. Convierta el peso de cada envío a libras, para ello se sabe que una libra son 2.2 kg. (aproximadamente). */
UPDATE Embarque
SET peso = peso / 2.2

/* 29. Indique las ciudades que han recibido embarques de todos los clientes */
SELECT ci.nombre_ciudad
FROM Ciudad ci
WHERE NOT EXIST ( SELECT *
                  FROM Cliente cli
                  WHERE NOT EXIST ( SELECT *
                                    FROM Embarque e
                                    WHERE e.id_cliente = cli.id_cliente
                  )
)

/* 30. Cuantos embarques han sido enviados pro el cliente 433? */
SELECT COUNT(*)
FROM Embarque
WHERE id_cliente = 433

/* 31. Para cada cliente ¿cuál es el peso medio de los paquetes enviados por él? */
SELECT id_cliente AVG(peso)
FROM Embarque
GROUP BY id_cliente

/* 32. Para cada ciudad ¿cuál es el peso máximo de un paquete que haya sido enviado a dicha ciudad? */
SELECT destino, MAX(peso)
FROM Embarque
GROUP BY destino

/* 33. Para cada ciudad con población por encima de un millón de habitantes ¿cuál es el peso menor de un paquete enviado a dicha ciudad? */
SELECT e.destino, MIN(e.peso)
FROM Embarque e
INNER JOIN Ciudad ci ON ( ci.nombre_ciudad = e.destino )
WHERE ci.población > 1000000
GROUP BY destino

/* 34. Para cada ciudad que haya recibido al menos diez paquetes, ¿cuál es el peso medio de los paquetes enviados a dicha ciudad? */
SELECT destino, AVG(peso)
FROM Embarque
GROUP BY destino
HAVING COUNT(*) > 10