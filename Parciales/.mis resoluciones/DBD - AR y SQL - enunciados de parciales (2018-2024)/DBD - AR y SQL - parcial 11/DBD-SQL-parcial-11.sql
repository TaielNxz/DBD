/*
  11) Cursada 2024 - 2da fecha - 03/12/2024 

  Personas = ( dni, nombre, apellido, genero, telefono, email ) 
  Medicos = ( matricula, dni(FK), fechalngreso ) 
  Pacientes = ( dni(FK), fecha Nacimiento, antecedentes ) 
  Especialidades = ( idEspecialidad, nombreE, descripcion ) 
  MedicosEspecialidades = ( matricula(FK), idEspecialidad(FK) ) 
  Atenciones = ( nroAtencion, matricula (FK), dni (FK), fecha, hora, motivo, diagnostico?, tratamiento? ) // dni se refiere al DNI del paciente atendido 

  Resolver 1-2-3 con AR, y resolver 1-2-3-4-5 con SQL. 
*/

/*
  1. Listar matrícula, dni, nombre, apellido, teléfono y email de los médicos cuyo apellido sea "Garcia". 
*/
SELECT M.matricula, P.dni, P.nombre, P.apellido, P.telefono, P.email
FROM Medicos M
INNER JOIN Personas P ON ( M.dni = P.dni )
WHERE ( P.apellido = 'Garcia' );


/*
  2. Listar dni, nombre y apellido de aquellos pacientes que no recibieron atenciones durante 2024. 
*/
SELECT P.dni, P.nombre, P.apellido
FROM Pacientes PC
INNER JOIN Personas P ON ( PC.dni = P.dni )
LEFT JOIN Atenciones A ON ( PC.dni = A.dni )
WHERE A.fecha BETWEEN '2024-01-01' AND '2024-12-31'


/*
  3. Listar dni, nombre y apellido de los pacientes atendidos por todos los médicos especializados en "Cardiología". 
*/
SELECT P.dni, P.nombre, P.apellido
FROM Pacientes PC
INNER JOIN Personas P ON ( PC.dni = P.dni )
WHERE NOT EXIST (
    SELECT *
    FROM Medicos M
    INNER JOIN MedicosEspecialidades ME ON ( M.matricula = ME.matricula )
    WHERE ( E.nombreE = 'Cardiología' )
    AND NOT EXIST (
        SELECT *
        FROM Atenciones A
        WHERE ( A.matricula = M.matricula ) AND (A.dni = P.dni)
    )
)


/*
  4. Listar para cada especialidad nombre y cantidad de médicos que se especializan en ella. Tenga en cuenta que 
  puede haber especialidades que no tienen médicos especialistas. 
*/
SELECT E.nombreE, COUNT(ME.matricula) AS cantidad_medicos
FROM Especialidades E
LEFT JOIN MedicosEspecialidades ME ON ( E.idEspecialidad = ME.idEspecialidad )
GROUP BY E.idEspecialidad, E.nombreE;


/*
  5. Listar matrícula, dni, nombre y apellido del médico (o de los médicos) con más atenciones realizadas. 
*/
SELECT M.matricula, P.dni, P.nombre, P.apellido
FROM Medicos M
INNER JOIN Personas P ON ( M.dni = P.dni )
INNER JOIN Atenciones A ON ( M.matricula = A.matricula )
GROUP BY M.matricula, P.dni, P.nombre, P.apellido
HAVING COUNT(A.nroAtencion) = (
    SELECT MAX(cantidad_atenciones)
    FROM (
        SELECT COUNT(A.nroAtencion) AS cantidad_atenciones
        FROM Atenciones A
        GROUP BY A.matricula
    )
);