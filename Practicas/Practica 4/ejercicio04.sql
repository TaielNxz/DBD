/* 
  Ejercicio 4
  PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
  ALUMNO = (DNI(fk), Legajo, Año_Ingreso)
  PROFESOR = (DNI (fk), Matricula, Nro_Expediente)
  TITULO = (Cod_Titulo, Nombre, Descripción)
  TITULO_PROFESOR = (Cod_Titulo (fk), DNI (fk), Fecha)
  CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
  ALUMNO_CURSO = (DNI (fk), Cod_Curso (fk), Año, Desempeño, Calificación)
  PROFESOR-CURSO = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta)
*/

/* 
  1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a
  2014. 
*/
SELECT a.DNI, a.legajo, p.apellido, p.nombre
FROM ALUMNO a
INNER JOIN PERSONA p ON (a.DNI = p.DNI)
WHERE a.Año_Ingreso < 2014


/* 
  2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
  100 horas de duración. Ordenar por DNI.
*/
SELECT p.DNI, p.Matricula, p.apellido, p.nombre
FROM PROFESOR p
INNER JOIN Persona per ON (p.DNI = per.DNI)
INNER JOIN PROFESOR_CURSO pc ON (p.DNI = per.DNI)
INNER JOIN CURSO c ON (pc.Cod_Curso = c.Cod_Curso)
WHERE c.duración > 100
GROUP BY DNp.I


/* 
  3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
  curso con nombre “Diseño de Bases de Datos” en 2023.
*/
SELECT p.DNI, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM PERSONA p
INNER JOIN ALUMNO a ON (p.DNI = a.DNI)
WHERE a.DNI IN (
  SELECT ac.DNI
  FROM ALUMNO_CURSO
  INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
  WHERE c.Nombre = 'Diseño de Bases de Datos' AND ac.Año = 2023
);


/* 
  4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
  calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
  estar ordenado por Apellido y nombre.
*/
SELECT p.DNI, p.Apellido, p.Nombre, ac.Calificación
FROM PERSONA p
INNER JOIN ALUMNO_CURSO ac ON (p.DNI = ac.DNI)
INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE ac.Calificación > 8 
AND c.Cod_Curso IN (
  SELECT pc.Cod_Curso
  FROM PROFESOR_CURSO pc
  INNER JOIN PERSONA p_prof ON (pC.DNI = p_prof.DNI)
  WHERE p_prof.Nombre = 'Juan Garcia'
)
ORDER BY p.Apellido, p.Nombre,


/* 
  5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
  Dicho listado deberá estar ordenado por Apellido y Nombre.
*/
SELECT p.DNI, p.Apellido, p.Nombre, prof.Matricula
FROM PERSONA p
INNER JOIN PROFESOR prof ON (p.DNI = prof.DNI)
INNER JOIN TITULO_PROFESOR t_prof ON (prof.DNI = t_prof.DNI)
GROUP BY p.DNI, p.Apellido, p.Nombre, p_prof.Matricula
HAVING COUNT(t_prof.Cod_Titulo) > 3
ORDER BY p.Apellido, p.Nombre


/* 
  6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
  La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta.
*/
SELECT p.DNI, p.Apellido, p.Nombre, 
       SUM(c.duración) AS Cantidad_Horas, 
       SUM(c.duración) / COUNT(c.Cod_Curso) AS Promedio_Horas
FROM PERSONA p
INNER JOIN PROFESOR prof ON (p.DNI = p_prof.DNI)
INNER JOIN PROFESOR_CURSO prof_c ON (prof.DNI = prof_c.DNI)
INNER JOIN CURSO c ON (prof_c.Cod_Curso = c.Cod_Curso)
GROUP BY p.DNI, p.Apellido, p.Nombre


/* 
  7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea
  menos alumnos inscriptos durante 2024.
*/
SELECT c.Nombre, c.Descripción
FROM CURSO c
INNER JOIN ALUMNO_CURSO ac ON (c.Cod_Curso = ac.Cod_Curso)
WHERE ac.Año = 2024
GROUP BY c.Nombre, c.Descripción
HAVING COUNT(c.DNI) = (
  SELECT MAX(COUNT(ac_max.DNI))
  FROM ALUMNO_CURSO ac_max
  WHERE ac_max.Año = 2024
  GROUP BY ac_max.Cod_Curso
)
OR COUNT(ac.DNI) = (
  SELECT MIN(COUNT(ac_min.DNI))
  FROM ALUMNO_CURSO ac_min
  WHERE  ac_min.Año = 2024
  GROUP BY ac_min.Cod_Curso
);


SELECT c.Nombre, c.Descripcion
FROM CURSO c
INNER JOIN ALUMNO_CURSO ac ON (c.Cod_Curso = ac.Cod_Curso)
WHERE ac.Año = 2024
GROUP BY c.Nombre, c.Descripcion
HAVING COUNT(*) >= ALL (
  SELECT COUNT(ac_max.DNI)
  FROM ALUMNO_CURSO ac_max
  WHERE ac_max.Año = 2024
  GROUP BY ac_max.Cod_Curso
)
OR COUNT(*) <= ALL (
  SELECT COUNT(ac_min.DNI)
  FROM ALUMNO_CURSO ac_min
  WHERE ac_min.Año = 2024
  GROUP BY ac_min.Cod_Curso
);


/* 
  8. Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre
  conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023.
*/
SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM PERSONA p
INNER JOIN ALUMNO a ON (p.DNI = a.DNI)
INNER JOIN ALUMNO_CURSO ac ON (a.DNI = ac.DNI)
INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE (c.Nombre LIKE '%BD%') 
  AND (ac.Año = 2022) 
  AND p.DNI NOT IN (
    SELECT p.DNI
    FROM ALUMNO_CURSO ac_2023
    WHERE ac_2023.Año = '2023'
  );


/* 
  9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25.
*/
INSERT INTO PERSONA (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) 
VALUES ('43103099', 'Nunes', 'Taiel', '2001-02-04', 'soltero', 'masculino')

INSERT INTO PROFESOR (DNI, Matricula, Nro_Expediente) 
VALUES ('43103099', '111', '111')

INSERT INTO TITULO_PROFESOR (Cod_Titulo, DNI, Fecha)
VALUES ('13', '43103099', '2024-11-5')


/* 
  10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.
*/
UPDATE ALUMNO a
SET a.Estado_Civil = 'Divorciado'
WHERE a.Legajo = '2020/09';


/* 
  11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el
  conjunto de relaciones en un estado inconsistente.
*/
DELETE FROM ALUMNO_CURSO
WHERE DNI = 30568989;

DELETE FROM ALUMNO
WHERE DNI = 30568989;

DELETE FROM PERSONA
WHERE DNI = 30568989;