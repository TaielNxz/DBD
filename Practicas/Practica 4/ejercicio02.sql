/* 
  Ejercicio 2
  Localidad = (codigoPostal, nombreL, descripcion, #habitantes)
  Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
  Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
  Poda = (codPoda, fecha, DNI(fk), nroArbol(fk))
*/

/* 
  1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
  el podador ‘Jose Garcia’.
*/
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL AS localidad
FROM Arbol a
INNER JOIN Localidad l ON ( a.codigoPostal = l.codigoPostal )
INNER JOIN Poda pd ON ( a.nroArbol = pd.nroArbol )
INNER JOIN Podador pdr ON ( pd.DNI = pdr.DNI )
WHERE (pdr.nombre = 'Juan' AND pdr.apellido = 'Perez')
   OR (pdr.nombre = 'Jose' AND pdr.apellido = 'Garcia');                     


/*
  2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
  podadores que tengan podas realizadas durante 2023.
*/
SELECT p.DNI, p.nombre, p.apellido, p.fnac AS nacimiento, l.nombreL AS localidad
FROM Podador p
INNER JOIN Localidad l (ON p.codigoPostalVive = l.codigoPostal)
WHERE p.DNI IN (
  SELECT po.DNI
  FROM Poda po
  WHERE po.fecha BETWEEN '2023-01-01' AND '2023-12-31'
);


/*
  3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.
*/
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL AS localidad
FROM Arbol a
INNER JOIN Localidad l ON ( a.codigoPostal = l.codigoPostal )
WHERE a.nroArbol NOT IN (
  SELECT p.nroArbol
  FROM Poda p
);

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL AS localidad
FROM Arbol a
INNER JOIN Localidad l ON ( a.codigoPostal = l.codigoPostal )
WHERE NOT EXISTS (
  SELECT *
  FROM Poda p
  WHERE p.nroArbol = a.nroArbol
);


/*
  4. Reportar especie, años, calle, nro y localidad de árboles que fueron podados durante 2022 y no
  fueron podados durante 2023.
*/
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL AS localidad
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE a.nroArbol IN (
  SELECT p2022.nroArbol
  FROM Poda p2022
  WHERE p2022.fecha BETWEEN '2022-01-01' AND '2022-12-31'
) 
AND a.nroArbol NOT IN {
  SELECT p2023.nroArbol
  FROM Poda p2023
  WHERE p2023.fecha BETWEEN '2023-01-01' AND '2023-12-31'
}


/*
  5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
  podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
  2024. Ordenar por apellido y nombre.
*/
SELECT p.DNI, p.nombre, p.apellido, p.fnac AS nacimiento, l.nombreL AS localidad
FROM Podador p
INNER JOIN Localidad l ON p.codigoPostalVive = l.codigoPostal
WHERE p.apellido LIKE '%ata'
AND p.DNI IN (
  SELECT p2024.DNI
  FROM Poda p2024
  WHERE p2024.fecha BETWEEN '2024-01-01' AND '2024-12-31'
)
ORDER BY p.apellido, p.nombre;


/*
  6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
  árboles de especie ‘Coníferas’.
*/
SELECT p.DNI, p.apellido, p.nombre, p.telefono, p.fnac AS nacimiento
FROM Podador p
WHERE p.DNI IN (
  SELECT po.DNI
  FROM Poda po
  JOIN Arbol a ON ( po.nroArbol = a.nroArbol )
  WHERE a.especie = 'Coníferas'
)
AND p.DNI NOT IN (
  SELECT po.DNI
  FROM Poda po
  JOIN Arbol a ON po.nroArbol = a.nroArbol
  WHERE a.especie <> 'Coníferas'
);


/*
  7. Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
  localidad de ‘Salta’.
*/
SELECT a1.especie
FROM Arbol a1
JOIN Localidad l1 ON ( a1.codigoPostal = l1.codigoPostal )
WHERE l1.nombreL = 'La Plata'
AND a1.especie IN (
  SELECT a1.especie
  FROM Arbol a2
  JOIN Localidad l2 ON ( a2.codigoPostal = l2.codigoPostal )
  WHERE l2.nombreL = 'Salta'
);


/*
  8. Eliminar el podador con DNI 22234566.
*/
DELETE 
FROM Poda 
WHERE dni = 22234566;

DELETE 
FROM Podador 
WHERE dni = 22234566;


/*
  9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100
  árboles.
*/
SELECT l.nombreL, l.descripcion, l.#habitantes
FROM Localidad l
LEFT JOIN Arbol a ON ( a.codigoPostal = l.codigoPostal )  --> LEFT JOIN para agarrar tambien las Localidades sin Arboles
GROUP BY l.nombreL, l.descripcion, l.#habitantes
HAVING COUNT(a.nroArbol) < 100;