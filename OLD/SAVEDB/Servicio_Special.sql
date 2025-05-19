select s.Nombre, ts.*
from servicio s
         join tiposervicio ts on s.TipoServicioID = ts.ID
where ts.EsEstudio = 1;

select s.Nombre, ts.Nombre
from servicio s
         join tiposervicio ts on s.TipoServicioID = ts.ID
where ts.nombre like N'%Cirugía%'

select s.ID
from servicio s
         join tiposervicio ts on s.TipoServicioID = ts.ID
where ts.nombre like N'%Cirugía%'

-- select s.Nombre, ts.Nombre
select s.ID
from servicio s
         join tiposervicio ts on s.TipoServicioID = ts.ID
where ts.nombre not like N'%Cirugía%'
and not ts.nombre like N'%Estudio%'

select distinct ts.Nombre from tiposervicio ts

select *
from TipoServicio;