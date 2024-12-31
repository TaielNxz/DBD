/*
  1) sin fecha 

  Producto = ( codP, marca, detalle, precio, disponible ) 
  Tipo_Promocion = ( codP, detalle ) 
  Promocion = ( (codP)FK, desde, (hasta)?, cant_min, (cant_max)?, descuento, (producto)FK ) 
  Ticket = ( nro, fecha ) 
  Venta = ( ((ticket)FK, (producto)FK), cantidad, precio_unitario, (descuento)? )

  Realizar 1-2-3-4 en AR y 3-4-5-6-7 en SQL 
*/


/*
  3. Listar marca, detalle y precio de productos disponibles que no se hayan vendido en la fecha de hoy. En SQL 
  ordenar por fecha de venta y marca.
*/
SELECT P.marca, P.detalle, P.precio
FROM Producto P
WHERE P.disponible = TRUE
  AND P.codP NOT IN (
      SELECT V.producto
      FROM Venta V
      INNER JOIN Ticket T ON ( V.ticket = T.nro )
      WHERE T.fecha = '2024-12-29' /* <<-- pongan la fecha de hoy */
  )
ORDER BY T.fecha, P.marca;


/*
  4. Listar los datos de productos que aún no han tenido ventas. En SQL ordenar por marca y precio. 
*/
SELECT P.codP, P.marca, P.detalle, P.precio, P.disponible
FROM Producto P
WHERE P.codP NOT IN (
  SELECT DISTINCT V.producto
  FROM Venta V
)
ORDER BY P.marca, P.precio;


/*
  5. Listar el importe total (sin considerar descuentos), el importe a cobrar (total menos descuentos) y la cantidad de 
  ítems correspondientes al ticket 123456789.  
*/
SELECT T.nro AS nro_ticket, SUM(V.cantidad * V.precio_unitario) AS importe_total,
                            SUM((V.cantidad * V.precio_unitario) - SUM(V.descuento)) AS importe_a_cobrar,
                            SUM(V.cantidad) AS cantidad_items
FROM Venta V
INNER JOIN Ticket T ON ( V.ticket = T.nro )
WHERE T.nro = 123456789
GROUP BY T.nro;


/*
  6. Listar para cada ticket, su número, fecha e importe total correspondientes a ventas del mes y que superen los 
  $10.000. Ordenar descendentemente por fecha.  
*/
SELECT T.nro, T.fecha, SUM(V.cantidad * V.precio_unitario) AS importe_total
FROM Venta V
INNER JOIN Ticket T ON ( V.ticket = T.nro )
WHERE T.fecha BETWEEN '2024-12-01' AND '2024-12-29'
  AND SUM(V.cantidad * V.precio_unitario) > 10000
GROUP BY T.nro, T.fecha
ORDER BY T.fecha DESC;


/*
  7. Listar marca y detalle de productos y su cantidad total de unidades vendidas para la fecha de hoy.
*/
SELECT P.marca, P.detalle, SUM(V.cantidad) AS cantidad_vendida
FROM Producto P
INNER JOIN Venta V ON ( P.codP = V.producto )
INNER JOIN Ticket T ON ( V.ticket = T.nro )
WHERE T.fecha = '2024-12-29' /* <<-- pongan la fecha de hoy */
GROUP BY P.marca, P.detalle
ORDER BY P.marca, P.detalle;