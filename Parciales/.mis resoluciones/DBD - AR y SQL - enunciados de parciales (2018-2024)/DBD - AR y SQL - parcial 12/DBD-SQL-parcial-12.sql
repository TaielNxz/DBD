/*
  12) Cursada 2024 - 3da fecha - 17/12/2024 

  Empleados = ( id_empleado, nombre, apellido, legajo, id_depertamento(fk) ) 
  Departamentos = ( id_depertamento, nombre_departamento ) 
  Proyectos = ( id_proyecto, nombre_proyecto, id_depertamento(fk)? ) 
  Asignaciones = ( id_empleado(fk), id_proyecto(fk), fecha_asignacion ) 

  Resolver 1-2-3 con AR, y resolver 1-2-3-4-5 con SQL. 
*/

/*
  1. Obtener todos los empleados con su respectivo departamento, mostrar el nombre y apellido y el nombre del 
  departamento en el que trabaja.
*/
SELECT E.nombre, E.apellido, D.nombre_departamento
FROM Empleados E
INNER JOIN Departamentos D ON (E.id_depertamento = D.id_depertamento);


/*
  2. Listar los proyectos asignados al empleado con legajo 3456/6. 
*/
SELECT P.nombre_proyecto
FROM Asignaciones A
INNER JOIN Empleados E ON ( A.id_empleado = E.id_empleado )
INNER JOIN Proyectos P ON ( A.id_proyecto = P.id_proyecto )
WHERE ( E.legajo = '3456/6' );


/*
  3. Obtener los empleados que no están asignados a ningún proyecto. Mostrar nombre, apellido y legajo. 
*/
SELECT E.nombre, E.apellido, E.legajo
FROM Empleados E
LEFT JOIN Asignaciones A ON (E.id_empleado = A.id_empleado)
WHERE A.id_proyecto IS NULL;


/*
  4. Contar cuántos empleados hay en cada departamento, mostrando la información del nombre del departamento y 
  cantidad de empleados.
*/
SELECT D.nombre_departamento, COUNT(E.id_empleado) AS cantidad_empleados
FROM Departamentos D
LEFT JOIN Empleados E ON (D.id_depertamento = E.id_depertamento)
GROUP BY D.id_depertamento, D.nombre_departamento;


/*
  5. Listar todos los departamentos que no tienen proyectos asociados, mostrar el nombre del departamento. 
*/
SELECT D.nombre_departamento
FROM Departamentos D
LEFT JOIN Proyectos P ON (D.id_depertamento = P.id_depertamento)
WHERE P.id_proyecto IS NULL;