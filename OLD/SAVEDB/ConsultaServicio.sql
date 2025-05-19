--  Initial prompting
select * from Dueño;
select * from Mascota;

select r.EspecieID, e.Nombre
from Raza r
         join Especie e on r.EspecieID = e.ID;

select m.RazaID, r.Nombre
from Mascota m
         join Raza r on m.RazaID = r.ID;

--  Original attributes
--  select m.DueñoID, m.ID, d.Nombre, m.Nombre, e.Nombre, r.Nombre, m.FechaDeNacimiento, m.Sexo, m.Esterilizado, m.Activo
-- 1. PRINCIPAL MENU
select  m.Nombre, d.Nombre, r.Nombre, e.Nombre, m.FechaDeNacimiento, m.Sexo, m.Esterilizado, m.Activo
from Mascota m
         join Dueño d on m.DueñoID = d.ID
         join Raza r on m.RazaID = r.ID
         join Especie e on r.EspecieID = e.ID;

--  SPECIFIC SCREEN FOR A REGISTRY
--  2 Servicios aplicados a la mascota (ya incluido con consultas y consultaservicio)
select  m.Nombre, d.Nombre, r.Nombre, e.Nombre, m.FechaDeNacimiento, m.Sexo, m.Esterilizado, m.Activo
from Mascota m
         join Dueño d on m.DueñoID = d.ID
         join Raza r on m.RazaID = r.ID
         join Especie e on r.EspecieID = e.ID
where m.ID = ${petIDToSearchON};

go
--  2.2 Registros médicos de una mascota
select *
from ConsultaServicio cs
         join Servicio s on cs.ServicioID = s.ID
         join TipoServicio ts on s.TipoServicioID = ts.ID
         join Consulta c on cs.ConsultaID = c.ID
         join Mascota m on c.MascotaID = m.ID
         join Empleado e on c.EmpleadoID = e.ID
where m.ID = ${petIDToSearchON};
-- same as before but now with specific props to show on frontend
select m.ID as 'Pet ID', m.Nombre as 'Pet name', cs.FechaRealizacion, s.Nombre, c.Motivo, c.Diagnostico, ts.Nombre
from ConsultaServicio cs
         join Servicio s on cs.ServicioID = s.ID
         join TipoServicio ts on s.TipoServicioID = ts.ID
         join Consulta c on cs.ConsultaID = c.ID
         join Mascota m on c.MascotaID = m.ID
where m.ID = ${petIDToSearchON};
--  Improved, now with service type filter (by name)
select m.ID as 'Pet ID', m.Nombre as 'Pet name', cs.FechaRealizacion, s.Nombre, c.Motivo, c.Diagnostico, ts.Nombre
from ConsultaServicio cs
         join Servicio s on cs.ServicioID = s.ID
         join TipoServicio ts on s.TipoServicioID = ts.ID
         join Consulta c on cs.ConsultaID = c.ID
         join Mascota m on c.MascotaID = m.ID
where m.ID = ${petIDToSearchON} and ts.Nombre like concat('%', ${serviceNameToSearchOn}, '%');
select ts.Nombre from TipoServicio ts;

select * from dbo.TipoServicio

-- 1 5 y 8 ID mascots only have an ID!
select count(*) as 'Consultas totales',  m.Nombre as 'Mascota', m.ID as 'Mascota ID'
from ConsultaServicio cs
         join Servicio s on cs.ServicioID = s.ID
         join TipoServicio ts on s.TipoServicioID = ts.ID
         join Consulta c on cs.ConsultaID = c.ID
         join Mascota m on c.MascotaID = m.ID
group by m.Nombre, m.ID;
go

-- 3.0 Vacunas aplicadas a la mascota

-- Only 6,7,10,14,18,22,26,30,34,38 and 42 has registries with 1 or 2 vaccines applied on each
-- but 1 5 y 8 ID mascots only have with services!,
-- TODO: Add some registries to mascot ID in (1,5,8) with 1 or 2 (or more ig) vaccines applied! (using the following tables)
select count(*) as 'Total Vaccines applied', mva.MascotaID, m.Nombre
from dbo.MascotaVacunaAplicacion mva
         join Mascota m on mva.MascotaID = m.ID
group by mva.MascotaID, m.Nombre;

select mvp.FechaAplicacion, p.Nombre, ma.Nombre
from MascotaVacunaAplicacion mvp
         join Mascota m on mvp.MascotaID = m.ID
         join Vacuna v on mvp.VacunaID = v.ID
         join Producto p on v.ProductoID = p.ID
         join Marca ma on p.MarcaID = ma.ID
where m.ID = ${petIDToSearchON};

-- 4.0 Alergias encontradas en la mascota (de acuerdo a la mascota en sí misma, no por la raza)
go

select count(*) as 'Total allergies on pet', m.Nombre
from MascotaAlergia ma
         join Mascota m on ma.MascotaID = m.ID
group by ma.MascotaID,m.Nombre;

go

-- Mascot ids in (1,2,3,4,5,6,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64) IDS actually have allergies (all of them only have 1 allergy)
select *
from MascotaAlergia ma
         join Mascota m on ma.MascotaID = m.ID
         join Alergia a on ma.AlergiaID = a.ID
where m.ID = ${petIDToLookFor};

go
-- Breeds with ids (1,3,6,7,8,9,14,19,21) with 1 to 2 allergies included on each
select count(*), r.Nombre
from RazaAlergia ra
         join Raza r on ra.RazaID = r.ID
         join Alergia a on ra.AlergiaID = a.ID
group by ra.RazaID, r.Nombre
order by ra.RazaID;

select *
from RazaAlergia ra
         join Raza r on ra.RazaID = r.ID
         join Alergia a on ra.AlergiaID = a.ID
where ra.RazaID = ${breedIDToLookFor};

-- USE THIS ONE
select a.Nombre, a.Descripcion
from RazaAlergia ra
         join Raza r on ra.RazaID = r.ID
         join Alergia a on ra.AlergiaID = a.ID
where ra.RazaID = ${breedIDToLookFor};




go

select s.Nombre, ts.Nombre
from Servicio s
         join TipoServicio ts on s.TipoServicioID = ts.ID;

select s.ID, s.Nombre, ts.Nombre
from Servicio s
         join TipoServicio ts on s.TipoServicioID = ts.ID
order by ts.Nombre;

select count(*) as 'Total Services Registered per type', ts.Nombre
from Servicio s
         join TipoServicio ts on s.TipoServicioID = ts.ID
group by ts.Nombre;



select * from Mascota;

