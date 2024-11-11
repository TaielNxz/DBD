/*
  Ejercicio 12

  Barberia = (codBarberia, razon_social, direccion, telefono)
  Cliente = (nroCliente, DNI, nombYAp, direccionC, fechaNacimiento, celular)
  Barbero = (codEmpleado, DNIB, nombYApB, direccionB, telefonoContacto, mail)
  Atencion = (codEmpleado(fk), fecha, hora, codBarberia(fk), nroCliente(fk), descTratamiento, valor)

*/

/*
  1. Listar DNI, nombre y apellido, dirección, fecha de nacimiento y celular de clientes que no tengan
  atenciones durante 2024.
*/
SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c
WHERE c.nroCliente NOT IN (
  SELECT a.nroCliente
  FROM Atencion a
  WHERE a.fecha BETWEEN '2024-01-01' AND '2024-12-31';
)

-- alternativa copada
SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c
LEFT JOIN Atencion a ON ( c.nroCliente = a.nroCliente )
                    AND ( a.fecha BETWEEN '2024-01-01' AND '2024-12-31' )
WHERE a.nroCliente IS NULL;


/*
  2. Listar para cada barbero cantidad de atenciones que realizaron durante 2023. Listar DNI,
  nombre y apellido, dirección, teléfono de contacto, mail y cantidad de atenciones.
*/
SELECT b.DNIB, b.nombYApB, b.direccionB, b.telefonoContacto, b.mail, COUNT(*) AS cantidad_atenciones
FROM Barbero b
INNER JOIN Atencion a ON ( b.codEmpleado = a.codEmpleado ) 
WHERE a.fecha BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY b.DNIB, b.nombYApB, b.direccionB, b.telefonoContacto, b.mail


/*
  3. Listar razón social, dirección y teléfono de barberías que tengan atenciones para el cliente con
  DNI 22283566. Ordenar por razón social y dirección ascendente.
*/
SELECT b.razon_social, b.direccion, b.telefono
FROM Barberia b
INNER JOIN Atencion a ON ( b.codBarberia = a.codBarberia ) 
INNER JOIN Cliente c ON ( a.nroCliente = c.nroCliente ) 
WHERE c.DNI = 22283566
ORDER BY b.razon_social ASC, b.direccion ASC;


/*
  4. Listar DNI, nombre y apellido, dirección, teléfono de contacto y mail de barberos que tengan
  atenciones con valor superior a $5000.
*/
SELECT b.DNIB, b.nombYApB, b.direccionB, b.telefonoContacto, b.mail
FROM Barbero b
INNER JOIN Atencion a ON ( b.codEmpleado = a.codEmpleado ) 
WHERE a.valor > 5000


/*
  5. Listar DNI, nombYAp, direccionC, fechaNacimiento y celular de clientes que tengan atenciones
  en la barbería con razón social: ‘Corta barba’ y también se hayan atendido en la barbería con
  razón social: ‘Barberia Barbara’.
*/
SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c
INNER JOIN Atencion a1 ON ( c.nroCliente = a1.nroCliente )
INNER JOIN Barberia b1 ON ( a.codBarberia = b1.codBarberia )
INNER JOIN Atencion a2 ON ( c.nroCliente = a2.nroCliente )
INNER JOIN Barberia b2 ON ( a.codBarberia = b2.codBarberia )
WHERE b1.razon_social = ('Corta Barba')
  AND b2.razon_social = ('Barberia Barbara');


SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c
INNER JOIN Atencion a ON ( c.nroCliente = a.nroCliente )
INNER JOIN Barberia b ON ( a.codBarberia = b.codBarberia )
WHERE b.razon_social = ('Corta Barba')
INTERSECT (
  SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
  FROM Cliente c
  INNER JOIN Atencion a ON ( c.nroCliente = a.nroCliente )
  INNER JOIN Barberia b ON ( a.codBarberia = b.codBarberia )
  WHERE b.razon_social = ('Barberia Barbara');
)


SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c
INNER JOIN Atencion a ON c.nroCliente = a.nroCliente
INNER JOIN Barberia b ON a.codBarberia = b.codBarberia
WHERE b.razon_social IN ('Corta Barba', 'Barberia Barbara')
GROUP BY c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
HAVING COUNT(DISTINCT b.razon_social) = 2;


/*
  6. Eliminar el cliente con DNI 22222222.
*/
DELETE FROM Cliente
WHERE DNI = 22222222;