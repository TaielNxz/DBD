/*
  7) Redictado 2022 - 3ra fecha

  Cliente = ( nroCite, cuit, nomClte, email ) 
  Producto = ( codProd, nomProd, descrip, stock, precio ) 
  Pedido = ( nroPed, fechaPed, (nroCite)fk, dirEntrega ) 
  PedProd = ( (nroPed)fk ,(codProd)fk, cantPed, precioU ) 
  Entrega = ( nroRemito , fecha Ent, (nroPed)fk ) 
  EntProd = ( (nroRemito)fk, (codProd)fk, cantEnt ) 

  Nota: 
  Un pedido puede tener más de una entrega. 
  Una entrega puede no incluir a un producto del pedido correspondiente, y una entrega de producto para un pedido puede 
  ser por una cantidad menor a la pedida. 

  Realizar 1-2-3-4 en AR y 2-3-4-5-6 en SQL 
*/


/*
  2. Listar CUIT, nombre y email de clientes que en los últimos doce meses hayan pedido todos los productos.
*/
SELECT C.cuit, C.nomClte, C.email
FROM Cliente C
WHERE NOT EXISTS (
    SELECT *
    FROM Producto P
    WHERE NOT EXISTS (
        SELECT *
        FROM Pedido Ped
        INNER JOIN PedProd PP ON ( Ped.nroPed = PP.nroPed )
        WHERE ( Ped.nroCite = C.nroCite ) 
          AND ( PP.codProd = P.codProd ) 
          AND ( Ped.fechaPed BETWEEN '2024-12-29' AND '2023-12-29' ) /* <<-- pongan la fecha de hoy */
    )
);


/*
  3. Listar para los pedidos de los últimos treinta días, el número y fecha del pedido, el código y cantidad pedida de 
  cada producto y el número de remito, fecha de entrega y cantidad entregada del producto para cantidades 
  entregadas menores a las pedidas. En SQL ordenar por número de pedido, código de producto y fecha de entrega. 
*/
SELECT Ped.nroPed, Ped.fechaPed, PP.codProd, PP.cantPed, E.nroRemito, E.fechaEnt, EE.cantEnt
FROM Pedido Ped
INNER JOIN PedProd PP ON ( Ped.nroPed = PP.nroPed )
INNER JOIN Entrega E ON ( Ped.nroPed = E.nroPed )
INNER JOIN EntProd EE ON ( E.nroRemito = EE.nroRemito ) AND ( PP.codProd = EE.codProd )
WHERE Ped.fechaEnt BETWEEN '2024-12-29' AND '2024-11-29'  /* <<-- pongan la fecha de hoy */
  AND EE.cantEnt < PP.cantPed
ORDER BY Ped.nroPed, PP.codProd, E.fechaEnt;


/*
  4. Listar para los pedidos de los últimos treinta días, el número y fecha del pedido, el CUIT, nombre y dirección de 
  entrega del cliente, y el código y cantidad pedida de producto, para productos que no hayan sido enviados. En SQL 
  ordenar por número de pedido. 
*/
SELECT Ped.nroPed, Ped.fechaPed, C.cuit, C.nomClte, Ped.dirEntrega, PP.codProd, PP.cantPed
FROM Pedido Ped
INNER JOIN PedProd PP ON ( Ped.nroPed = PP.nroPed )
INNER JOIN Cliente C ON ( Ped.nroCite = C.nroCite )
WHERE Ped.fechaPed BETWEEN '2024-12-29' AND '2024-11-29'  /* <<-- pongan la fecha de hoy */
AND NOT EXISTS (
    SELECT *
    FROM Entrega E
    INNER JOIN EntProd EE ON ( E.nroRemito = EE.nroRemito )
    WHERE ( E.nroPed = Ped.nroPed ) AND ( EE.codProd = PP.codProd )
)
ORDER BY Ped.nroPed;


/*
  5. Listar número y fecha de pedido, y código de producto, cantidad pedida y cantidad enviada del producto de 
  pedidos de los últimos treinta días con cantidad enviada menor a la pedida (incluyendo productos pedidos de los 
  que no se envió ninguna unidad). En SQL ordenar por número de pedido y código de producto. 
*/
SELECT Ped.nroPed, Ped.fechaPed, PP.codProd, PP.cantPed, COALESCE(EE.cantEnt, 0) AS cantEnt
FROM Pedido Ped
INNER JOIN PedProd PP ON ( Ped.nroPed = PP.nroPed )
LEFT JOIN Entrega E ON ( Ped.nroPed = E.nroPed )
LEFT JOIN EntProd EE ON ( E.nroRemito = EE.nroRemito ) AND ( PP.codProd = EE.codProd )
WHERE Ped.fechaPed BETWEEN '2024-12-29' AND '2024-11-29'  /* <<-- pongan la fecha de hoy */
AND ( EE.cantEnt < PP.cantPed OR EE.cantEnt IS NULL )
ORDER BY Ped.nroPed, PP.codProd;


/*
  6. Listar número de cliente, número y fecha de pedido, cantidad de productos pedidos y monto total 
  correspondiente a los productos entregados, correspondientes a pedidos de los últimos treinta días. En SQL 
  ordenar por monto total en forma descendente.
*/
SELECT Ped.nroCite, Ped.nroPed, Ped.fechaPed, SUM(PP.cantPed) AS cantidad_total, SUM(EE.cantEnt * PP.precioU) AS monto_total
FROM Pedido Ped
INNER JOIN PedProd PP ON ( Ped.nroPed = PP.nroPed )
INNER JOIN Entrega E ON ( Ped.nroPed = E.nroPed )
INNER JOIN EntProd EE ON ( E.nroRemito = EE.nroRemito ) AND ( PP.codProd = EE.codProd )
WHERE Ped.fechaPed BETWEEN '2024-12-29' AND '2024-11-29'  /* <<-- pongan la fecha de hoy */
GROUP BY Ped.nroCite, Ped.nroPed, Ped.fechaPed
ORDER BY monto_total DESC;