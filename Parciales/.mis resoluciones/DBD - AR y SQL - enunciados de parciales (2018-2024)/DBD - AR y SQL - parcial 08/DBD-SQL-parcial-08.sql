/*
  8) Cursada 2022 - 1ra fecha - 08/11/2022

  SOCIO = ( nro_socio, DNI, Apellido, Nombre, Fecha_Nacimiento, Fecha_Ingreso ) 
  LIBRO = ( ISBN, Titulo, Cod_Genero, Descripcion ) 
  COPIA = ( ISBN(PK), Nro_Ejemplar , Estado ) 
  EDITORIAL = ( Cod_Editorial, Denominacion, Telefono, Calle, Numero, Piso, Dpto ) 
  LIBRO-EDITORIAL = ( ISBN(FK). Cod Editorial(PK), Año_Edicion ) 
  GENERO = ( Cod_Genero, Nombre_genero ) 
  PRESTAMO = ( Nro_Prestamo, nro_Socio(FK), ISBN (FK), Nro_Ejemplar(FK), Fecha_Prestamo, Fecha_Devolucion) // ISBN(FK) y Nro_Ejemplar son foraneas de copia 

  Realizar 6-7-8 en AR y 1-2-3-4-5 en SQL 
*/

/*
  1. Listar el titulo, género (el Nombre del Género) y descripción de aquellos libros editados por la editorial "Nueva 
  Editorial". Dicho listado deberá estar ordenado por título. 
*/
SELECT L.Titulo, G.Nombre_genero, L.Descripcion
FROM LIBRO L
INNER JOIN GENERO G ON ( L.Cod_Genero = G.Cod_Genero )
INNER JOIN LIBRO_EDITORIAL LE ON ( L.ISBN = LE.ISBN )
INNER JOIN EDITORIAL E ON ( LE.Cod_Editorial = E.Cod_Editorial )
WHERE E.Denominacion = 'Nueva Editorial'
ORDER BY L.Titulo;


/*
  2. Listar el apellido y nombre de aquellos socios cuya fecha de ingreso esté entre el 01/9/2022 y el 30/09/2022. 
  Dicho listado deberá estar ordenado por apellido y nombre. 
*/
SELECT S.Apellido, S.Nombre
FROM SOCIO S
WHERE S.Fecha_Ingreso BETWEEN '2022-09-01' AND '2022-09-30'
ORDER BY S.Apellido, S.Nombre;


/*
  3. Listar el nombre, apellido, fecha de Nacimiento y cantidad de préstamos de aquellos socios que hayan solicitado 
  más de 5 préstamos. Dicho listado deberá estar ordenado por Apellido. 
*/
SELECT S.Nombre, S.Apellido, S.Fecha_Nacimiento, COUNT(P.Nro_Prestamo) AS Cantidad_Prestamos
FROM SOCIO S
INNER JOIN PRESTAMO P ON ( S.nro_socio = P.nro_socio )
GROUP BY S.nro_socio, S.Nombre, S.Apellido, S.Fecha_Nacimiento
HAVING COUNT(P.Nro_Prestamo) > 5
ORDER BY S.Apellido;


/*
  4. Listar el DNI, apellido y nombre de aquellos socios que no tengan préstamos de libros editados por la editorial 
  "Gran Editorial". Dicho listado deberá estar ordenado por Apellido y Nombre. 
*/
SELECT DISTINCT S.DNI, S.Apellido, S.Nombre
FROM SOCIO S
WHERE NOT EXISTS (
    SELECT *
    FROM PRESTAMO P
    INNER JOIN LIBRO_EDITORIAL LE ON ( P.ISBN = LE.ISBN )
    INNER JOIN EDITORIAL E ON ( LE.Cod_Editorial = E.Cod_Editorial )
    WHERE P.nro_socio = S.nro_socio 
      AND E.Denominacion = 'Gran Editorial'
)
ORDER BY S.Apellido, S.Nombre;


/*
  5. Mostrar que cantidad de socios tienen actualmente libros prestados cuyo estado sea "Bueno".
*/
SELECT COUNT(DISTINCT P.nro_socio) AS Cantidad_Socios
FROM PRESTAMO P
INNER JOIN COPIA C ON ( P.ISBN = C.ISBN AND P.Nro_Ejemplar = C.Nro_Ejemplar )
WHERE C.Estado = 'Bueno' AND P.Fecha_Devolucion IS NULL;