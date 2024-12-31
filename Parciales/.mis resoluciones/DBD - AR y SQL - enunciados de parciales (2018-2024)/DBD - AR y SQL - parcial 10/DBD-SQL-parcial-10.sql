/*
  10) Cursada 2024 - 1ra fecha - 12/11/2024 

  Cliente = ( idCliente, nombre, apellido, DNI, telefono, direccion ) 
  Venta = ( nroVenta, total, fecha, hora, idCliente (fk) ) 
  DetalleVenta = ( nroVenta (fk), idLibro (fk), cantidad, precioUnitario ) 
  Libro = ( idLibro, titulo, autor, precio, stock ) 

  Resolver 1-2-3 con AR, y resolver 1-2-3-4-5 con SQL. 
*/

/*
  1. Listar todos los libros cuyo precio es mayor a $2300. 
*/
SELECT L.titulo, L.autor, L.precio
FROM Libro L
WHERE ( L.precio > 2300 );


/*
  2. Listar todas las ventas realizadas en agosto del 2023.
*/
SELECT V.nroVenta, V.total, V.fecha, V.hora, C.DNI
FROM Venta V
WHERE fecha BETWEEN '2023-01-01' AND '2023-12-31'


/*
  3. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente durante el año 
  2022. 
*/
SELECT DISTINCT C.nombre, C.apellido, C.DNI, C.telefono, C.direccion
FROM Cliente C
WHERE NOT EXISTS (
    SELECT 1
    FROM Venta V
    WHERE ( C.idCliente = V.idCliente AND YEAR(V.fecha) <> 2022 )
)
AND EXISTS (
    SELECT 1
    FROM Venta V
    WHERE ( C.idCliente = V.idCliente AND YEAR(V.fecha) = 2022 )
);


/*
  4. Listar para cada libro el título, autor, precio y la cantidad total de veces que fue vendido. Tener en cuenta que 
  puede haber libros que no se vendieron. 
*/
SELECT L.titulo, L.autor, L.precio, SUM(DV.cantidad) AS cantidad_vendida
FROM Libro L
LEFT JOIN DetalleVenta DV ON ( L.idLibro = DV.idLibro )
GROUP BY L.idLibro, L.titulo, L.autor, L.precio;


/*
  5. Listar nroVenta, total, fecha, hora y DNI del cliente, de aquellas ventas donde se haya vendido al menos un libro 
  con precio mayor a 1000. 
*/
SELECT V.nroVenta, V.total, V.fecha, V.hora, C.DNI
FROM Venta V
INNER JOIN Cliente C ON ( V.idCliente = C.idCliente )
INNER JOIN DetalleVenta DV ON ( V.nroVenta = DV.nroVenta )
INNER JOIN Libro L ON ( DV.idLibro = L.idLibro )
WHERE ( L.precio > 1000 );