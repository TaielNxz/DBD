/*
  9) Cursada 2022 - 2da fecha - 29/11/2022 

  TipoObra = ( idTipo, descripcionTipo ) 
  Obra = ( nroObra, idTipo(fk), fechaCrea, nombre, calle, nro, codigo Postal (fk)) // Obras arquitectónica 
  Artista = ( idArtista, DNI, pasaporte, nombre, apellido, telefono, fnac, codigoPostalVive(fk) ) 
  Artista_Obra = ( nroObra(fk), idArtista(fk), fechal, fechaF, descripcionl ) // Intervenciones de artistas en las obras, un mismo 
  artista puede intervenir varias veces la misma obra 
  Localidad = ( codigo Postal, nombreL, descripcion, #habitantes ) 

  Realizar 6-7-8 en AR y 1-2-3-4-5 en SQL 
*/


/*
  1. Listar tipo de obra, fecha creación, nombre, y ubicación (calle, nro, localidad) de obras intervenidas por los artistas 
  'Jose Ayala' con DNI 2222222 y por el artista 'Juan Artigas' pasaporte 'AR123456'. 
*/
SELECT T.descripcionTipo, O.fechaCrea, O.nombre, O.calle, O.nro, L.nombreL AS localidad
FROM Obra O
INNER JOIN TipoObra T ON ( O.idTipo = T.idTipo )
INNER JOIN Localidad L ON ( O.codigoPostal = L.codigoPostal )
INNER JOIN Artista_Obra AO ON ( O.nroObra = AO.nroObra )
INNER JOIN Artista A ON ( AO.idArtista = A.idArtista )
WHERE ( A.nombre = 'Jose' AND A.apellido = 'Ayala' AND A.DNI = 2222222 )
   OR ( A.nombre = 'Juan' AND A.apellido = 'Artigas' AND A.pasaporte = 'AR123456' )
  

/*
  2. Reportar DNI, pasaporte, nombre, apellido, fnac, teléfono y localidad donde viven artistas que tengan más de 2 
  intervenciones con fecha de inicio en 2022. Ordenar por apellido y nombre. 
*/
SELECT A.DNI, A.pasaporte, A.nombre, A.apellido, A.fnac, A.telefono, L.nombreL AS localidad
FROM Artista A
INNER JOIN Localidad L ON ( A.codigoPostalVive = L.codigoPostal )
INNER JOIN Artista_Obra AO ON ( A.idArtista = AO.idArtista )
WHERE AO.fechal BETWEEN '2022-01-01' AND '2022-12-31';
GROUP BY A.DNI, A.pasaporte, A.nombre, A.apellido, A.fnac, A.telefono, L.nombreL
HAVING COUNT(AO.nroObra) > 2
ORDER BY A.apellido, A.nombre;


/*
  3. Listar tipo de obra, fecha creación, nombre, y ubicación (calle, nro, localidad) de obras que no fueron intervenidas 
  nunca. //obras nuevas que fueron traídas y colocadas directamente. 
*/
SELECT T.descripcionTipo, O.fechaCrea, O.nombre, O.calle, O.nro, L.nombreL AS localidad
FROM Obra O
INNER JOIN TipoObra T ON ( O.idTipo = T.idTipo )
INNER JOIN Localidad L ON ( O.codigoPostal = L.codigoPostal )
LEFT JOIN Artista_Obra AO ON ( O.nroObra = AO.nroObra )
WHERE AO.nroObra IS NULL;


/*
  4. Reportar DNI, pasaporte, nombre, apellido, fnac, teléfono y localidad de artistas que solo intervinieron obras con 
  fecha de creación inferior a 1890. 
*/
SELECT A.DNI, A.pasaporte, A.nombre, A.apellido, A.fnac, A.telefono, L.nombreL AS localidad
FROM Artista A
INNER JOIN Localidad L ON ( A.codigoPostalVive = L.codigoPostal )
INNER JOIN Artista_Obra AO ON ( A.idArtista = AO.idArtista )
INNER JOIN Obra O ON ( AO.nroObra = O.nroObra )
GROUP BY A.DNI, A.pasaporte, A.nombre, A.apellido, A.fnac, A.telefono, L.nombreL
HAVING MAX(O.fechaCrea) < '1890-01-01';


/*
  5. Listar tipo de obra, fecha de creación y nombre de obras intervenidas por todos los artistas.
*/
SELECT T.descripcionTipo, O.fechaCrea, O.nombre
FROM Obra O
INNER JOIN TipoObra T ON ( O.idTipo = T.idTipo )
WHERE NOT EXISTS (
    SELECT 1
    FROM Artista A
    WHERE NOT EXISTS (
        SELECT 1
        FROM Artista_Obra AO
        WHERE ( AO.nroObra = O.nroObra AND AO.idArtista = A.idArtista )
    )
);