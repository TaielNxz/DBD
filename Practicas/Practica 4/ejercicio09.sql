/*
  Ejercicio 9

  Proyecto = (codProyecto, nombrP, descripcion, fechaInicioP, fechaFinP, fechaFinEstimada, DNIResponsable(FK), equipoBackend(FK), equipoFrontend(FK))
  Equipo = (codEquipo, nombreE, descTecnologias, DNILider(FK))    // DNILider corresponde a un empleado
  Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
  Empleado_Equipo = ( codEquipo(FK) , DNI(FK), fechaInicio, fechaFin, descripcionRol)

  DNIResponsable corresponde a un empleado
  equipoBackend y equipoFrontend corresponden a equipos
*/

/*
  1. Listar nombre, descripción, fecha de inicio y fecha de fin de proyectos ya finalizados que no
  fueron terminados antes de la fecha de fin estimada.
*/
SELECT p.nombrP, p.descripcion, p.fechaInicioP, p.fechaFinP
FROM Proyecto p
WHERE p.fechaFinP IS NOT NULL
  AND p.fechaFinP > p.fechaFinEstimada;


/*
  2. Listar DNI, nombre, apellido, teléfono, dirección y fecha de ingreso de empleados que no son, ni
  fueron responsables de proyectos. Ordenar por apellido y nombre.
*/
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
FROM Empleado e
WHERE e.DNI NOT IN (
  SELECT p.DNIResponsable 
  FROM Proyecto p
  )
ORDER BY e.apellido, e.nombre;


/*
  3. Listar DNI, nombre, apellido, teléfono y dirección de líderes de equipo que tenga más de un
  equipo a cargo.
*/
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN Equipo eq ON ( e.DNI = eq.DNILider )
GROUP BY e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
HAVING COUNT(eq.codEquipo) > 1;


/*
  4. Listar DNI, nombre, apellido, teléfono y dirección de todos los empleados que trabajan en el
  proyecto con nombre ‘Proyecto X’. No es necesario informar responsable y líderes.
*/

-- solucion 1
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN Empleado_Equipo em_eq ON ( e.DNI = em_eq.DNI )
INNER JOIN Proyecto p1 ON ( em_eq.codEquipo = p.equipoBackend OR em_eq.codEquipo = p.equipoFrontend )
WHERE p.nombrP = 'Proyecto X'

-- alternativa
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN Empleado_Equipo em_eq ON ( e.DNI = em_eq.DNI )
INNER JOIN Proyecto p ON ( em_eq.codEquipo IN (p.equipoBackend, p.equipoFrontend) )
WHERE p.nombrP = 'Proyecto X';


/*
  5. Listar nombre de equipo y datos personales de líderes de equipos que no tengan empleados
  asignados y trabajen con tecnología ‘Java’.
*/
SELECT eq.nombreE, e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
FROM Equipo eq
INNER JOIN Empleado e ON ( eq.DNILider = e.DNI )
WHERE eq.descTecnologias = 'Java'
  AND eq.codEquipo NOT IN (
    SELECT em_eq.codEquipo
    FROM Empleado_Equipo em_eq
  );


/*
  6. Modificar nombre, apellido y dirección del empleado con DNI 40568965 con los datos que desee.
*/
UPDATE Empleado
SET nombre = 'TAIEL',
    apellido = 'NUNES',
    direccion = 'Juan C Justo 149'
WHERE DNI = 40568965;


/*
  7. Listar DNI, nombre, apellido, teléfono y dirección de empleados que son responsables de
  proyectos pero no han sido líderes de equipo.
*/
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN Proyecto p ON ( e.DNI = p.DNIResponsable )
WHERE e.DNI NOT IN (
  SELECT eq.DNILider
  FROM Equipo eq
);


/*
  8. Listar nombre de equipo y descripción de tecnologías de equipos que hayan sido asignados
  como equipos frontend y backend.
*/
SELECT eq.nombreE, eq.descTecnologias
FROM Equipo eq
WHERE eq.codEquipo IN (
  SELECT p.equipoBackend
  FROM Proyecto P
)
AND eq.codEquipo IN (
  SELECT p.equipoFrontend
  FROM Proyecto P
)

SELECT eq.nombreE, eq.descTecnologias
FROM Equipo eq
INNER JOIN Proyecto p1 ON eq.codEquipo = p.equipoBackend
                       OR eq.codEquipo = p.equipoFrontend


/*
  9. Listar nombre, descripción, fecha de inicio, nombre y apellido de responsables de proyectos que
  se estiman finalizar durante 2025.
*/
SELECT p.nombrP, p.descripcion, p.fechaInicioP, e.nombre, e.apellido
FROM Proyecto p
INNER JOIN Empleado e ON ( p.DNI = p.DNIResponsable )
WHERE p.fechaFinEstimada BETWEEN '2025-01-01' AND '2025-12-31';