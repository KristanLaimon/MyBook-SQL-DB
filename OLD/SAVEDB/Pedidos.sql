select *
from Pedido;

select *
from dbo.PedidoProductoDetalle;

select *
from Medicamento;

select *
from Producto;

select *
from TipoProducto;

-- Debugging level 2
select p.ID,tp.Nombre, p.Nombre, m.Nombre
from dbo.Producto p
join TipoProducto tp on p.TipoProductoID = tp.ID
join Marca m on p.MarcaID = m.ID
where tp.Nombre = 'Vacuna'

-- is 4
select tp.ID
from TipoProducto tp
where tp.Nombre = 'Vacuna';

select p.ID as 'Product ID', v.ID as 'Vaccine ID', p.Nombre
from Vacuna v
join Producto p on v.ProductoID = p.ID
where p.TipoProductoID = 4;

select p.Nombre, m.Nombre, v.*
from Vacuna v
join Producto p on v.ProductoID = p.ID
join Marca m on p.MarcaID = m.ID;


-- debuggin' level god

select * from PedidoProductoDetalle;

select count(*) from Pedido;
select count(*) from PedidoProductoDetalle;

-- I have my Pedido with ID 1
select pr.Nombre, p.*
from Pedido p
join Proveedor pr on p.ProveedorID = pr.ID
where p.ID = 1;




-- First table (Generic product)
select tp.Nombre, ppd.*, p.*
from PedidoProductoDetalle ppd
         join dbo.Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
where ppd.PedidoID = 1
and tp.Nombre != 'Medicamento'
and tp.Nombre != 'Vacuna';

-- Generic
select tp.Nombre, p.Nombre
from PedidoProductoDetalle ppd
         join dbo.Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
        join Medicamento m on p.ID = m.ProductoID
where ppd.PedidoID = 2;

select p.ID as 'ProductID', m.ID as 'MedicineID'
from PedidoProductoDetalle ppd
         join dbo.Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
         join Medicamento m on p.ID = m.ProductoID
where ppd.PedidoID = 1
and tp.ID = 1;

-- /=====================================
-- Get all the products in 'Pedido' of type '#' (Second and third table)
select m.*
from PedidoProductoDetalle ppd
         join dbo.Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
         join Medicamento m on p.ID = m.ProductoID
where ppd.PedidoID = 1
and tp.Nombre = 'Medicamento';


select n.*
from PedidoProductoDetalle ppd
         join dbo.Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
         join Vacuna n on p.ID = n.ProductoID
where ppd.PedidoID = 1
and tp.Nombre = 'Vacuna';

-- All Types:
-- Medicamento              ID 1
-- Alimento para mascotas   ID 2
-- Juguetes para mascotas   ID 3
-- Vacuna                   ID 4

-- I'll use an enum for this
-- Note: they have an actual "Activo" prop in the table



select *
from Medicamento;

-- PERFECT DEBUGGING
select *
from PedidoProductoDetalle ppd
where ppd.PedidoID = 3;

select * from pedido;

select p.ID as 'Product ID',tp.Nombre, p.Nombre, p.Descripcion, pe.Descripcion
from PedidoProductoDetalle ppd
         join Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
         join Pedido pe on ppd.PedidoID = pe.ID
where ppd.PedidoID = 57

select pro.Nombre, pe.Estado, pe.Descripcion, pe.FechaEntrega, pro.Activo
from PedidoProductoDetalle ppd
         join Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
         join Pedido pe on ppd.PedidoID = pe.ID

         join Proveedor pro on pe.ProveedorID = pro.ID
group by ppd.PedidoID, pro.Nombre, pe.Estado, pe.Descripcion, pe.FechaEntrega, pro.Activo

-- END PERFECT DEBUGGING

-- almost perfect

select *
from PedidoProductoDetalle ppd
join Pedido p on ppd.PedidoID = p.ID

-- Entregado
-- No entregado

select *
from Pedido p
where p.ID = 3;

select PedidoID
from PedidoProductoDetalle ppd
join Producto p on ppd.ProductoID = p.ID
join TipoProducto tp on p.TipoProductoID = tp.ID
where tp.ID = 4;
--

-- 53 54 55 with vacunas
select tp.Nombre, p.*
from Producto p
join TipoProducto tp on p.TipoProductoID = tp.ID
where tp.Nombre = 'Vacuna';
--
-- select *
-- from Medicamento m
-- where m.ProductoID in (1,2,3);
--



select p.ID as 'ProductID', v.ID as 'VaccineID'
from PedidoProductoDetalle ppd
         join dbo.Producto p on ppd.ProductoID = p.ID
         join TipoProducto tp on p.TipoProductoID = tp.ID
         join Vacuna v on p.ID = v.ProductoID
where ppd.PedidoID = 1
and tp.ID = 4;




