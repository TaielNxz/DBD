/*
  Ejercicio 11

  Box = (nroBox, m2, ubicación, capacidad, ocupacion)
  Mascota = (codMascota,nombre, edad, raza, peso, telefonoContacto)
  Veterinario = (matricula, CUIT, nombYAp, direccion, telefono)
  Supervision = (codMascota(fk), nroBox(fk), fechaEntra, fechaSale?, matricula(fk), descripcionEstadia) 
  
  - ocupación es un numérico indicando cantidad de mascotas en el box actualmente, capacidad es una descripción.
  - fechaSale tiene valor null si la mascota está actualmente en el box

*/

/*
  1. Listar para cada veterinario cantidad de supervisiones realizadas con fecha de salida (fechaSale)
  durante enero de 2024. Indicar matrícula, CUIT, nombre y apellido, dirección, teléfono y cantidad
  de supervisiones.
*/
SELECT v.matrícula, v.CUIT, v.nombYAp, v.direccion, v.telefono, COUNT(*) AS cantidad_supervisiones
FROM Veterinario v
INNER JOIN Supervision s ON ( v.matricula = s.matricula )
WHERE fechaSale BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY v.matrícula, v.CUIT, v.nombYAp, v.direccion, v.telefono;


/*
  2. Listar CUIT, matrícula, nombre, apellido, dirección y teléfono de veterinarios que no tengan
  mascotas bajo supervisión actualmente.
*/
SELECT v.matricula, v.CUIT, v.nombYAp, v.direccion, v.telefono
FROM Veterinario v
WHERE v.matricula NOT IN (
    SELECT s.matricula
    FROM Supervision s
    WHERE s.fechaSale IS NULL
)

-- alternativa copada pero mas fea
SELECT v.CUIT, v.matrícula, v.nombYAp, v.direccion, v.telefono,
FROM Veterinario v
LEFT JOIN Supervision s ON ( v.matricula = s.matricula )
WHERE s.fechaSale IS NULL 
   OR s.fechaSale < CURDATE();


/*
  3. Listar nombre, edad, raza, peso y teléfono de contacto de mascotas que fueron atendidas por el
  veterinario ‘Oscar Lopez’. Ordenar por nombre y raza de manera ascendente.
*/
SELECT m.nombre, m.edad, m.raza, m.peso, m.telefonoContacto
FROM Mascota m
WHERE m.codMascota IN (
  SELECT s.codMascota
  FROM Supervision s
  INNER JOIN Veterinario v ON ( s.matricula = v.matricula )
  WHERE v.nombre = 'Oscar Lopez'
)
ORDER BY m.nombre ASC, m.raza ASC;  --> por defecrto es Ascendente pero bueno, lo dejo de recordatorio


SELECT m.nombre, m.edad, m.raza, m.peso, m.telefonoContacto
FROM Mascota m
INNER JOIN Supervision s ON ( m.codMascota = s.codMascota )
INNER JOIN Veterinario v ON ( s.matricula = v.matricula )
WHERE v.nombre = 'Oscar Lopez'
ORDER BY m.nombre ASC, m.raza ASC;


/*
  4. Modificar el nombre y apellido al veterinario con matricula ‘MP 10000’, deberá llamarse: ‘Pablo
  Lopez’.
*/
UPDATE Veterinario
SET nombYAp = 'Pablo Lopez'
WHERE matricula = 'MP 10000';


/*
  5. Listar nombre, edad, raza y peso de mascotas que tengan supervisiones con el veterinario con
  matricula ‘MP 1000’ y con el veterinario con matricula ‘MN 4545’.
*/
SELECT m.nombre, m.edad, m.raza, m.peso
FROM Mascota m
INNER JOIN Supervision s ON m.codMascota = s.codMascota
WHERE s.matricula = 'MP 1000'
  AND m.codMascota IN (
    SELECT s.codMascota
    FROM Supervision s
    WHERE s.matricula = 'MN 4545'
  );


SELECT m.nombre, m.edad, m.raza, m.peso
FROM Mascota m
INNER JOIN Supervision s ON ( m.codMascota = s.codMascota )
WHERE s.matricula = 'MP 1000'
INTERSECT (
  SELECT m.nombre, m.edad, m.raza, m.peso
  FROM Supervision s
  WHERE S.matricula = 'MN 4545'
)

-- alternativa copada
SELECT m.nombre, m.edad, m.raza, m.peso
FROM Mascota m
INNER JOIN Supervision s ON ( m.codMascota = s.codMascota )
WHERE s.matricula IN ('MP 1000', 'MN 4545')
GROUP BY m.codMascota, m.nombre, m.edad, m.raza, m.peso
HAVING COUNT(DISTINCT v.matricula) = 2;


/*
  6. Listar número de box, m2, ubicación, capacidad y nombre de mascota para supervisiones con
  fecha de entrada durante 2024.
*/
SELECT b.nroBox, b.m2, b.ubicación, b.capacidad, m.nombre
FROM Box b
INNER JOIN Supervision s ON ( b.nroBox = s.nroBox )
INNER JOIN Mascota m ON ( s.codMascota = m.codMascota )
WHERE s.fechaEntra BETWEEN '2024-01-01' AND '2024-12-31';