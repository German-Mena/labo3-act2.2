use BluePrint

GO

--1)Por cada cliente listar razón social, cuit y nombre del tipo de cliente.

--2)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos clientes que posean ciudad y país.


select 
	CL.RazonSocial, CL.Cuit, C.nombre as Ciudad, P.nombre as Pais
from Clientes as CL
	Inner Join Ciudades as C ON C.ID = CL.IDCiudad
	inner join Paises as P ON C.IDPais = P.ID


--3)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellos clientes 
--  que no tengan ciudad relacionada.

select 
	CL.RazonSocial, CL.CUIT, C.Nombre as Ciudad, P.Nombre as Pais
from Clientes as CL
	left join Ciudades as C ON C.ID = CL.IDCiudad
	left join Paises as P ON P.ID = C.IDPais


--4)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellas ciudades
--  y países que no tengan clientes relacionados.

select
	CL.RazonSocial, CL.CUIT, C.nombre as Ciudad, P.Nombre as Pais
from Clientes as CL
	right join Ciudades as C ON C.ID = CL.IDCiudad
	right join Paises as P ON P.ID = C.IDPais


--5)Listar los nombres de las ciudades que no tengan clientes asociados. Listar también el nombre del país al que pertenece la ciudad.

select
	C.nombre as Ciudad, P.Nombre as Pais
from Clientes as CL
	right join Ciudades as C ON C.ID = CL.IDCiudad
	right join Paises as P ON P.ID = C.IDPais
where CL.IDCiudad is null


--6)Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, el nombre del tipo de cliente y el nombre
--  de la ciudad (si la tiene registrada) de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.

select 
	PR.Nombre as Proyecto, 
	PR.costoEstimado as 'Costo Estimado',
	CL.razonSocial as 'Razon Social', 
	TC.nombre as 'Tipo de Cliente',
	C.Nombre as Ciudad
from Proyectos as PR
	inner join Clientes as CL ON CL.ID = PR.IDCliente
	inner join TiposCliente as TC ON TC.ID = CL.IDTipo
	inner join Ciudades as C ON C.ID = CL.IDCiudad
where TC.Nombre in ('Extranjero','Unicornio')


--7)Listar los nombre de los proyectos de aquellos clientes que sean de los países 'Argentina' o 'Italia'.

select
	PR.nombre as Proyecto,
	P.nombre as Pais
from Proyectos as PR
	inner join Clientes as CL on CL.ID = PR.IDCliente
	inner join Ciudades as C on C.ID = CL.IDCiudad
	inner join Paises as P on P.ID = C.IDPais
where P.Nombre in ('Argentina','Italia')

	
--8)Listar para cada módulo el nombre del módulo, el costo estimado del módulo, el nombre del proyecto, la descripción del 
--  proyecto y el costo estimado del proyecto de todos aquellos proyectos que hayan finalizado.

select
	M.nombre as Modulo,
	M.CostoEstimado as 'Costo estimado del modulo',
	PR.Nombre as Proyecto,
	PR.Descripcion,
	PR.CostoEstimado as 'Costo estimado del proyecto'
from Modulos as M
	left join Proyectos as PR on PR.ID = M.IDProyecto
--where PR.Estado = 1
where PR.FechaFin < GETDATE()


--9)Listar los nombres de los módulos y el nombre del proyecto de aquellos módulos cuyo tiempo estimado de realización sea de más de 100 horas.

select
	M.nombre as Modulo,
	PR.nombre as Proyecto
from Modulos as M
	inner join Proyectos as PR on PR.ID = M.IDProyecto
where M.TiempoEstimado > 100


--10)Listar nombres de módulos, nombre del proyecto, descripción y tiempo estimado de aquellos módulos cuya fecha estimada de fin 
--   sea mayor a la fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.

select
	M.nombre as Modulo,
	M.Descripcion,
	PR.nombre as Proyecto,
	M.TiempoEstimado
from Modulos as M
	inner join Proyectos as PR on PR.ID = M.IDProyecto
where M.FechaEstimadaFin > M.FechaFin AND PR.CostoEstimado > 100000


--11)Listar nombre de proyectos, sin repetir, que registren módulos que hayan finalizado antes que el tiempo estimado.

select distinct 
	PR.Nombre as Proyecto
from Proyectos as PR
	inner join Modulos as M on M.IDProyecto = PR.ID
where M.FechaFin < M.FechaEstimadaFin


--12)Listar nombre de ciudades, sin repetir, que no registren clientes pero sí colaboradores.

select distinct
	C.nombre as Ciudad
from Ciudades as C
	left join Clientes as CL on CL.IDCiudad = C.ID
	inner join Colaboradores as CO on CO.IDCiudad = C.ID
where Cl.IDCiudad is null and CO.IDCiudad is not null


--13)Listar el nombre del proyecto y nombre de módulos de aquellos módulos que contengan la palabra 'login' en su nombre o descripción.
	
select 
	PR.nombre as Proyecto,
	M.nombre as Modulo,
	M.Descripcion
from Modulos as M
	inner join Proyectos as PR on PR.ID = M.IDProyecto
where M.Nombre in ('login') OR M.Descripcion in ('login') 


--14)Listar el nombre del proyecto y el nombre y apellido de todos los colaboradores que hayan realizado algún tipo de tarea cuyo nombre 
--   contenga 'Programación' o 'Testing'. Ordenarlo por nombre de proyecto de manera ascendente.

select
	PR.nombre as Proyecto, CO.nombre as Nombre, CO.apellido as Apellido, TT.Nombre as 'Tipo de Tarea'
from Proyectos as PR
	inner join Modulos as M on M.IDProyecto = PR.ID
	inner join Tareas as T on T.IDModulo = M.ID
	inner join TiposTarea as TT on TT.ID = T.IDTipo
	inner join Colaboraciones as CB on CB.IDTarea = T.ID
	inner join Colaboradores as CO on CO.ID = CB.IDColaborador
where TT.Nombre like '%Programación%' OR TT.Nombre like '%Testing%' 
order by PR.Nombre ASC

-- Resolucion alternativa

select distinct
	PR.nombre as Proyecto, CONCAT(CO.Nombre,' ', CO.Apellido) as Colaborador, TT.Nombre as 'Tipo de Tarea'
from Colaboradores as CO
	inner join Colaboraciones as CB on CB.IDColaborador = CO.ID
	inner join Tareas as T on T.ID = CB.IDTarea
	inner join TiposTarea as TT on TT.ID = T.IDTipo
	inner join Modulos as M on M.ID = T.IDModulo
	inner join Proyectos as PR on PR.ID = M.IDProyecto
where TT.Nombre like '%Programación%' OR TT.Nombre like '%Testing%' 
order by PR.Nombre ASC


--15)Listar nombre y apellido del colaborador, nombre del módulo, nombre del tipo de tarea, precio hora de la colaboración 
--   y precio hora base de aquellos colaboradores que hayan cobrado su valor hora de colaboración más del 50% del valor hora base.

select 
	CONCAT(CO.Nombre, ' ',CO.Apellido) as Colaborador, 
	M.nombre as Modulo,
	TT.nombre as 'Tipo de Tarea',
	CB.PrecioHora as 'Precio hora de Colaboracion',
	TT.PrecioHoraBase as 'Precio hora base de Tarea'
from Colaboradores as CO
	inner join Colaboraciones as CB on CB.IDColaborador = CO.ID
	inner join Tareas as T on T.ID = CB.IDTarea
	inner join TiposTarea as TT on TT.ID = T.IDTipo
	inner join Modulos as M on M.ID = T.IDModulo
where CB.PrecioHora > TT.PrecioHoraBase * 1.5


--16)Listar nombres y apellidos de las tres colaboraciones de colaboradores externos que más hayan demorado en realizar 
--   alguna tarea cuyo nombre de tipo de tarea contenga 'Testing'.

select TOP(3)
	CONCAT(CO.nombre,' ',CO.apellido) as Colaborador
from Colaboradores as CO
	inner join Colaboraciones as CB on CB.IDColaborador = CO.ID
	inner join Tareas as T on T.ID = CB.IDTarea
	inner join TiposTarea as TT on TT.ID = T.IDTipo
where 
	CO.Tipo in ('E') and 
	TT.Nombre like '%Testing%' and
	T.Estado in (1) and
	CB.Estado in (1) and
	T.FechaFin < GETDATE()
order by CB.Tiempo desc


--17)Listar apellido, nombre y mail de los colaboradores argentinos que sean internos y cuyo mail no contenga '.com'.

select 
	CONCAT (CO.nombre,' ', CO.apellido) as Colaborador,
	CO.Email
From Colaboradores as CO
	inner join Ciudades as C on C.ID = CO.IDCiudad
	inner join Paises as P on P.ID = C.IDPais
where P.Nombre in ('Argentina') and CO.Tipo in ('I') and CO.EMail not like '%.com%'


--18)Listar nombre del proyecto, nombre del módulo y tipo de tarea de aquellas tareas realizadas por colaboradores externos.

select distinct
	PR.nombre as Proyecto,
	M.nombre as Modulo,
	TT.nombre as 'Tipo de tarea'
from Tareas as T
	inner join TiposTarea as TT on TT.ID = T.IDTipo
	inner join Colaboraciones as CB on CB.IDTarea = T.ID
	inner join Colaboradores as CO on CO.ID = CB.IDColaborador
	inner join Modulos as M on M.ID = T.IDModulo
	inner join Proyectos as PR on PR.ID = M.IDProyecto
where CO.Tipo in ('E') 
	

--19)Listar nombre de proyectos que no hayan registrado tareas.

select
	PR.nombre as Proyecto
from Proyectos as PR
	left join Modulos as M on M.IDProyecto = PR.ID
	left join Tareas as T on T.IDModulo = M.ID
where T.ID is null


--20)Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que hayan trabajado en algún proyecto 
--   que aún no haya finalizado.

select distinct
	CONCAT(CO.Nombre,' ',CO.Apellido) as Colaborador
from Proyectos as PR
	inner join Modulos as M on M.IDProyecto = PR.ID
	inner join Tareas as T on T.IDModulo = M.ID
	inner join Colaboraciones as CB on CB.IDTarea = T.ID
	inner join Colaboradores as CO on CO.ID = CB.IDColaborador
where 
	CB.Estado in (1) and 
	T.Estado in (1) and
	M.Estado in (1) and
	PR.Estado in (1) and
	PR.FechaFin is not null and PR.FechaFin > GETDATE() 

