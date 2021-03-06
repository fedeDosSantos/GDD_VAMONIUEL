USE [GD1C2019]
GO

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'VAMONIUEL')
BEGIN
EXEC ('CREATE SCHEMA [VAMONIUEL] AUTHORIZATION [gdCruceros2019]')
END


------------------------------------ importante!! es para que me tome  yyyy mm dd en lugar de mm dd yyyy ------------------------------------
		SET DATEFORMAT ymd; 
------------------------------------ importante!! es para que me tome  yyyy mm dd en lugar de mm dd yyyy ------------------------------------

CREATE TABLE VAMONIUEL.[Rol](
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Nombre] [nvarchar](50) NOT NULL UNIQUE,
	[Habilitado] [bit] default 1
);	


CREATE TABLE VAMONIUEL.[Funcion](
	[ID] [int] NOT NULL PRIMARY KEY ,
	[nombre] [nvarchar](50) NOT NULL,
);

CREATE TABLE VAMONIUEL.[Rol_X_Funcion](
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[ID_Rol] [int] not null,
	[ID_Funcion] [int] not null,
	CONSTRAINT FK_RolXFuncion_Rol FOREIGN KEY (ID_Rol) REFERENCES VAMONIUEL.[Rol](ID),
	CONSTRAINT FK_RolXFuncion_Funcion FOREIGN KEY (ID_Funcion) REFERENCES VAMONIUEL.[Funcion](ID)
);

CREATE TABLE VAMONIUEL.[Usuario](
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Usuario] [nvarchar](50) NOT NULL UNIQUE,
	[Contrasenia] [binary](32) NOT NULL,
	[cant_accesos_fallidos] int default 0,
	[habilitado] [bit] default 1,
	[contrasena_autogenerada] [bit] default 0,
);


CREATE TABLE VAMONIUEL.[Rol_X_Usuario](
  	ID_ROL int,
  	ID_Usuario int,
	PRIMARY KEY(ID_ROL, ID_USUARIO),
  	CONSTRAINT FK_Rol_X_Usuario FOREIGN KEY (ID_Rol) REFERENCES VAMONIUEL.Rol(ID),
	CONSTRAINT FK_Usuario_X_Rol FOREIGN KEY(ID_Usuario) REFERENCES VAMONIUEL.Usuario(ID)
);

CREATE TABLE [VAMONIUEL].[CLIENTE]	
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[CLI_NOMBRE] [nvarchar](255) NULL,
	[CLI_APELLIDO] [nvarchar](255) NULL,
	[CLI_DNI] [decimal](18, 0) NULL,
	[CLI_DIRECCION] [nvarchar](255) NULL,
	[CLI_TELEFONO] [int] NULL,
	[CLI_MAIL] [nvarchar](255) NULL,
	[CLI_FECHA_NAC] [datetime2](3) NULL,
	id_usuario int  null,
	CONSTRAINT FK_Cliente_usuario FOREIGN KEY (id_usuario) REFERENCES VAMONIUEL.Usuario(ID)
);

CREATE TABLE [VAMONIUEL].[CRUCERO]
(	
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[CRU_FABRICANTE] [nvarchar](255) NULL,
	[CRUCERO_MODELO] [nvarchar](50) NULL,
	[CRUCERO_IDENTIFICADOR] [nvarchar](50) NULL,
	habilitado bit not null
);


CREATE TABLE [VAMONIUEL].Estado_del_Crucero
(	
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	Fecha_fuera_de_servicio datetime,
	Fecha_reinicio_de_servicio datetime,
	Fecha_baja_definitiva datetime,
	ID_Crucero int not null,
	CONSTRAINT FK_Estado_del_Crucero FOREIGN KEY (ID_Crucero) REFERENCES VAMONIUEL.Crucero(ID)		
);

CREATE TABLE [VAMONIUEL].[RECORRIDO]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[RECORRIDO_CODIGO] [decimal](18, 0) NULL,
	[PUERTO_DESDE] [nvarchar](255) NULL,
	[PUERTO_HASTA] [nvarchar](255) NULL,
	[Habilitado] [bit] default 1
);
CREATE TABLE [VAMONIUEL].[VIAJE]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	Origen [nvarchar](255)  null,
	Destino [nvarchar](255)  null,
	FechaInicio [datetime2](3)  null,
	FechaFin [datetime2](3)  null,
	[CRUCERO_IDENTIFICADOR] [nvarchar](50) NULL, -- Es como el id de crucero xq no se repite y no deberia
	ID_Crucero	 int  null,
	ID_Recorrido int  null,
	CONSTRAINT FK_Viaje_Recorrido FOREIGN KEY (ID_Recorrido) REFERENCES VAMONIUEL.[Recorrido](ID),		
	CONSTRAINT FK_Viaje_Crucero FOREIGN KEY (ID_Crucero) REFERENCES VAMONIUEL.[Crucero](ID)			
);



CREATE TABLE [VAMONIUEL].Tramo
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[PUERTO_DESDE] [nvarchar](255) NULL,
	[PUERTO_HASTA] [nvarchar](255) NULL,
	[RECORRIDO_PRECIO_BASE] [decimal](18, 2) NULL,
)

CREATE TABLE [VAMONIUEL].[ViajeXRecorrido]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	ID_Viaje int not null,
	ID_Recorrido int not null,
	orden int  not null,
	CONSTRAINT FK_ViajeXRecorrido_Viaje FOREIGN KEY (ID_Viaje) REFERENCES VAMONIUEL.[Viaje](ID),			
	CONSTRAINT FK_ViajeXRecorrido_Recorrido FOREIGN KEY (ID_Recorrido) REFERENCES VAMONIUEL.[RECORRIDO](ID)			
);


CREATE TABLE [VAMONIUEL].[Puerto]
(	
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Nombre] [nvarchar](255) NULL,
	[Habilitado] bit DEFAULT 1
);

CREATE TABLE [VAMONIUEL].[TramoXPuerto]
(	
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	id_tramo int not null,
	id_puerto int not null,
	CONSTRAINT FK_tramoXPuerto_tramo FOREIGN KEY (id_tramo) REFERENCES VAMONIUEL.Tramo(ID),			
	CONSTRAINT FK_tramoXPuerto_puerto FOREIGN KEY (id_puerto) REFERENCES VAMONIUEL.Puerto(ID)	
)


CREATE TABLE [VAMONIUEL].[RecorridoXViaje]
(
	ID INT NOT NULL,
	ID_Recorrido int not null,
	ID_Puerto int not null,
	CONSTRAINT FK_RecorridoXViaje_Recorrido FOREIGN KEY (ID_Recorrido) REFERENCES VAMONIUEL.[Recorrido](ID),			
	CONSTRAINT FK_RecorridoXViaje_Puerto FOREIGN KEY (ID_Puerto) REFERENCES VAMONIUEL.[Puerto](ID)	
);

CREATE TABLE [VAMONIUEL].[TramoXRecorrido]
(	
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	id_recorrido int not null,
	id_tramo int not null,
	CONSTRAINT FK_tramoXRecorrido_tramo FOREIGN KEY (id_tramo) REFERENCES VAMONIUEL.Tramo(ID),			
	CONSTRAINT FK_tramoXRecorrido_recorrido FOREIGN KEY (id_recorrido) REFERENCES VAMONIUEL.Recorrido(ID)	
)

CREATE TABLE [VAMONIUEL].[CABINA]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[CABINA_NRO] [decimal](18, 0) NULL,
	[CABINA_PISO] [decimal](18, 0) NULL,
	[CABINA_TIPO] [nvarchar](255) NULL,
	[CABINA_TIPO_PORC_RECARGO] [decimal](18, 2) NULL,	
	ID_Crucero int  null,
	CONSTRAINT FK_Cabina_Crucero FOREIGN KEY (ID_Crucero) REFERENCES VAMONIUEL.[Crucero](ID)		
);

CREATE TABLE [VAMONIUEL].[CabinaXViaje]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	ocupada bit null,
	ID_Cabina int  null,
	ID_Viaje int  null,
	CONSTRAINT FK_CabinaXViaje_Cabina FOREIGN KEY (ID_Cabina) REFERENCES VAMONIUEL.Cabina(ID),
	CONSTRAINT FK_CabinaXViaje_Viaje FOREIGN KEY (ID_Viaje) REFERENCES VAMONIUEL.Viaje(ID)
);


CREATE TABLE [VAMONIUEL].[PASAJE]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[PASAJE_CODIGO] [decimal](18, 0) NULL,
	[PASAJE_PRECIO] [decimal](18, 2) NULL,
	[PASAJE_FECHA_COMPRA] [datetime2](3) NULL,
	[FECHA_SALIDA] [datetime2](3) NULL,
	[FECHA_LLEGADA] [datetime2](3) NULL,
	[FECHA_LLEGADA_ESTIMADA] [datetime2](3) NULL,
	ID_Cliente int not null,
	ID_Viaje int not null,
	ID_CabinaXViaje int  null,
	CONSTRAINT FK_Pasaje_Cliente FOREIGN KEY (ID_Cliente) REFERENCES VAMONIUEL.[Cliente](ID),			
	CONSTRAINT FK_Pasaje_Viaje FOREIGN KEY (ID_Viaje) REFERENCES VAMONIUEL.[Viaje](ID),
	CONSTRAINT FK_Pasaje_CabinaXViaje FOREIGN KEY (ID_CabinaXViaje) REFERENCES VAMONIUEL.CabinaXViaje(ID)	
);


CREATE TABLE [VAMONIUEL].[RESERVA]
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	[RESERVA_CODIGO] [decimal](18, 0) NULL,
	[RESERVA_FECHA] [datetime2](3) NULL,
	Habilitado bit null,
	ID_Pasaje int  null,
	CONSTRAINT FK_Reserva_Pasaje FOREIGN KEY (ID_Pasaje) REFERENCES VAMONIUEL.[Pasaje](ID)	
);

CREATE TABLE [VAMONIUEL].PAGO
(
	[ID] [int] NOT NULL PRIMARY KEY IDENTITY(1,1),
	fecha_pago DATETIME NULL,
	medio_de_pago nvarchar(200) null,
	ID_Pasaje int  null,
	CONSTRAINT FK_Pago_Pasaje FOREIGN KEY (ID_Pasaje) REFERENCES VAMONIUEL.[Pasaje](ID)	
);


--------------------------------------------------------------------------- INSERTS DE VALORES GENERICOS ------------------------------------------------------------------------------------------------
--CON ESTO INSERTAMOS UN SET DE USUARIOS ADMINISTRADORES
INSERT INTO VAMONIUEL.[Usuario]([Usuario],[Contrasenia],habilitado) 
VALUES ('admin1',HASHBYTES('SHA2_256', N'w23e'),1), 
	   ('admin2',HASHBYTES('SHA2_256', N'w23e'),1),
	   ('admin3',HASHBYTES('SHA2_256', N'w23e'),1),
	   ('admin4',HASHBYTES('SHA2_256', N'w23e'),1),
	   ('admin5',HASHBYTES('SHA2_256', N'w23e'),1)
	   

INSERT INTO VAMONIUEL.[Rol] ([Nombre])
VALUES ('Administrativo'),('Cliente')


INSERT INTO [VAMONIUEL].[Rol_X_Usuario]([ID_ROL],[ID_Usuario])
VALUES (1,1),(1,2),(1,3),(1,4),(1,5)
--,(2,1) ESTO ESTA COMENTADO XQ EN ESTE TP QUEREMOS QUE HAYA SOLO 1 ROL, EL DE ADMIN!!!

--Esto hay que actualizarlo segun este TP
INSERT INTO [VAMONIUEL].[Funcion] 
VALUES (1, 'ABM Crucero'), (2, 'ABM Recorrido'), (3, 'ABM Rol'),
(4,'Compra y/o reserva de viaje'),(5, 'Generar viaje'),
(6, 'Pago Reserva'),(7, 'Listado estadistico')


INSERT INTO VAMONIUEL.[Rol_X_Funcion]   ([ID_ROL],ID_Funcion)
VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7)

-------------------------------------------------------- TRIGGERS -------------------------------------------------------------------------------
GO
CREATE TRIGGER VAMONIUEL.genera_cabinas_viaje ON VAMONIUEL.VIAJE AFTER INSERT
AS
BEGIN
	INSERT INTO VAMONIUEL.CabinaXViaje (ocupada, ID_Cabina,ID_Viaje)
		select 0, c.ID, v.ID
		from inserted v join VAMONIUEL.CABINA c on (v.ID_Crucero = c.ID_Crucero)
end

go
CREATE TRIGGER tr_creacion_tramoxpuerto ON VAMONIUEL.TRAMO
AFTER INSERT
AS 
BEGIN	
	--VARIABLES RELACIONADAS AL TRAMO
	
DECLARE @PUERTO_DESDE nvarchar(255)
DECLARE @PUERTO_HASTA nvarchar(255)
DECLARE @RECORRIDO_PRECIO_BASE decimal(18,2)
	--VARIABLES RELACIONADAS AL TRAMOXPUERTO
	DECLARE @ID_Tramo int
	DECLARE @ID_PUERTO_DESDE int
	DECLARE @ID_PUERTO_HASTA int

	--VARIABLES RELACIONADAS AL PUERTO

	--OBTENGO LOS DATOS ASOCIADOS A CADA INSERCION DE TRAMO
	DECLARE obtenerDatos CURSOR FOR

  SELECT I.ID, P1.ID, P2.ID
	FROM VAMONIUEL.Tramo I
	LEFT JOIN VAMONIUEL.Puerto P1 ON I.PUERTO_DESDE= P1.Nombre --Origen
	LEFT JOIN VAMONIUEL.Puerto P2 ON I.PUERTO_HASTA = P2.Nombre --Destino

	OPEN obtenerDatos
	FETCH NEXT FROM obtenerDatos INTO @ID_Tramo, @ID_PUERTO_DESDE, @ID_PUERTO_HASTA

	WHILE @@FETCH_STATUS=0
	BEGIN
		--HAGO 2 INSERTS EN LA TABLA TRAMOXPUERTO,
		--UNO PARA INDICAR EL ORIGEN Y OTRA PARA DESTINO
		BEGIN
		INSERT INTO [VAMONIUEL].[TramoXPuerto] ([id_tramo],[id_puerto])
		VALUES   (@ID_Tramo, @ID_PUERTO_DESDE)
	
		INSERT INTO [VAMONIUEL].[TramoXPuerto] ([id_tramo],[id_puerto])
		VALUES   (@ID_Tramo,  @ID_PUERTO_HASTA)

		END
	
	FETCH NEXT FROM obtenerDatos INTO @ID_Tramo, @ID_PUERTO_DESDE, @ID_PUERTO_HASTA
	END
	CLOSE obtenerDatos
	DEALLOCATE obtenerDatos

END
GO	

------------------------------------------------ tr_creacion_recorridoxtramo ----------------------------------------------------
--ESTE TRIGGER TIENE SENTIDO SER INVOCADO SOLO EN LA MIGRACION, X ESO LO DESTRUYO TERMINADA LA MIGRACION
go
CREATE TRIGGER tr_creacion_recorridoxtramo ON VAMONIUEL.TRAMO
AFTER INSERT
AS 
BEGIN	
	--VARIABLES RELACIONADAS AL RECORRIDOXTRAMO
	DECLARE @ID_Tramo int
	DECLARE @ID_Recorrido int

	DECLARE obtenerDatos CURSOR FOR
	SELECT I.ID, R.ID
	FROM inserted I
	LEFT JOIN VAMONIUEL.RECORRIDO R ON ( I.PUERTO_DESDE= R.PUERTO_DESDE AND I.PUERTO_HASTA= R.PUERTO_HASTA )

	OPEN obtenerDatos
	FETCH NEXT FROM obtenerDatos INTO @ID_Tramo, @ID_Recorrido

	WHILE @@FETCH_STATUS=0
	BEGIN
		--INSERTO EN LA TABLA INTERMEDIA
		BEGIN	
		INSERT INTO [VAMONIUEL].[TramoXRecorrido] ([id_recorrido],[id_tramo])
		VALUES  (@ID_Recorrido, @ID_Tramo )

		END
	
	FETCH NEXT FROM obtenerDatos INTO @ID_Tramo, @ID_Recorrido
	END
	CLOSE obtenerDatos
	DEALLOCATE obtenerDatos

END
GO	
------------------------------------------- INICIO  MIGRACION ----------------------------------------------------------------------------------------------------
 INSERT INTO VAMONIUEL.[Cliente]
(	[CLI_NOMBRE],[CLI_APELLIDO],[CLI_DNI],[CLI_DIRECCION],[CLI_TELEFONO],[CLI_MAIL],[CLI_FECHA_NAC])--, [ID_Usuario])
select  distinct[CLI_NOMBRE],[CLI_APELLIDO],[CLI_DNI],[CLI_DIRECCION] ,[CLI_TELEFONO],[CLI_MAIL],[CLI_FECHA_NAC]
-- ,(select ID from VAMONIUEL.Usuario where CAST([Cli_Dni] as nvarchar(50)) = Usuario)
from gd_esquema.Maestra
where [Cli_Dni]  IS NOT NULL

INSERT INTO [VAMONIUEL].[CRUCERO]
 ([CRU_FABRICANTE],[CRUCERO_MODELO],[CRUCERO_IDENTIFICADOR],[habilitado])
 select  distinct [CRU_FABRICANTE] ,[CRUCERO_MODELO],[CRUCERO_IDENTIFICADOR],1
from gd_esquema.Maestra

INSERT INTO [VAMONIUEL].[CABINA] ([CABINA_NRO],[CABINA_PISO],[CABINA_TIPO],[CABINA_TIPO_PORC_RECARGO],[ID_Crucero])
select  distinct [CABINA_NRO],[CABINA_PISO],[CABINA_TIPO],[CABINA_TIPO_PORC_RECARGO],C.ID
from gd_esquema.Maestra M 
LEFT JOIN VAMONIUEL.CRUCERO C ON	(M.CRU_FABRICANTE= C.CRU_FABRICANTE 
						AND M.CRUCERO_IDENTIFICADOR = C.CRUCERO_IDENTIFICADOR 
						AND M.CRUCERO_MODELO = C.CRUCERO_MODELO)

--Devuelve correctamente
/*
SELECT id FROM VAMONIUEL.CRUCERO C LEFT JOIN gd_esquema.Maestra M ON  M.CRU_FABRICANTE= C.CRU_FABRICANTE 
								    AND M.CRUCERO_IDENTIFICADOR = C.CRUCERO_IDENTIFICADOR 
									AND M.CRUCERO_MODELO = C.CRUCERO_MODELO*/

INSERT INTO [VAMONIUEL].[Puerto]([Nombre])
select  distinct [PUERTO_DESDE]
from gd_esquema.Maestra
--Pareceria que no hace falta esto, pero x las dudas...
INSERT INTO [VAMONIUEL].[Puerto]([Nombre])
select  distinct [PUERTO_HASTA]
from gd_esquema.Maestra
WHERE [PUERTO_HASTA] NOT IN (select  distinct [PUERTO_DESDE] from gd_esquema.Maestra)

INSERT INTO [VAMONIUEL].[RECORRIDO]([RECORRIDO_CODIGO] ,[PUERTO_DESDE],[PUERTO_HASTA])
select  distinct [RECORRIDO_CODIGO],[PUERTO_DESDE],[PUERTO_HASTA]
from gd_esquema.Maestra


--Cada vez que inserto un tramo ejecuto un trigger que me insertara en la tabla intermedia TramoXPuerto, los puerto de origen y destino
--La insercion en tramoxpuerto esta solucionada x el trigger
INSERT INTO [VAMONIUEL].[Tramo]
 ([PUERTO_DESDE] ,[PUERTO_HASTA],[RECORRIDO_PRECIO_BASE])
select  distinct [PUERTO_DESDE],[PUERTO_HASTA], [RECORRIDO_PRECIO_BASE]
from gd_esquema.Maestra


INSERT INTO [VAMONIUEL].[VIAJE]([Origen],[Destino],[FechaInicio],[FechaFin],[CRUCERO_IDENTIFICADOR],[ID_Crucero],[ID_Recorrido])
SELECT DISTINCT M.PUERTO_DESDE, M.PUERTO_HASTA, M.FECHA_SALIDA, M.FECHA_LLEGADA,M.[CRUCERO_IDENTIFICADOR],
(SELECT TOP 1 CRU.ID FROM VAMONIUEL.CRUCERO CRU WHERE M.[CRUCERO_IDENTIFICADOR] = cru.[CRUCERO_IDENTIFICADOR]), 
(SELECT  R.ID FROM VAMONIUEL.RECORRIDO R  WHERE M.PUERTO_DESDE = R.PUERTO_DESDE AND M.PUERTO_HASTA = R.PUERTO_HASTA)
FROM gd_esquema.Maestra M


INSERT INTO [VAMONIUEL].[PASAJE] 
([PASAJE_CODIGO],[PASAJE_PRECIO],[PASAJE_FECHA_COMPRA],[FECHA_SALIDA],[FECHA_LLEGADA],[FECHA_LLEGADA_ESTIMADA],[ID_Cliente],ID_Viaje)
SELECT DISTINCT[PASAJE_CODIGO],[PASAJE_PRECIO],[PASAJE_FECHA_COMPRA],[FECHA_SALIDA],[FECHA_LLEGADA],[FECHA_LLEGADA_ESTIMADA],
 C.ID,(SELECT TOP 1 V.ID FROM VAMONIUEL.VIAJE V WHERE M.FECHA_SALIDA = V.FechaInicio AND M.FECHA_LLEGADA = V.FechaFin)
FROM gd_esquema.Maestra M
LEFT JOIN VAMONIUEL.CLIENTE C ON (M.[CLI_NOMBRE] = C.[CLI_NOMBRE]
      AND M.[CLI_APELLIDO] = c.[CLI_APELLIDO]
      AND M.[CLI_DNI] = c.[CLI_DNI]
      AND M.[CLI_DIRECCION] = c.[CLI_DIRECCION]
      AND M.[CLI_TELEFONO] = c.[CLI_TELEFONO]
      AND M.[CLI_MAIL] = c.[CLI_MAIL]
      AND M.[CLI_FECHA_NAC] = c.[CLI_FECHA_NAC])
--Sacandole esta condicion hago insercion incluso de aquellas que me representan las reservas
WHERE [PASAJE_CODIGO] IS NOT NULL
      AND [PASAJE_PRECIO] IS NOT NULL
      AND [PASAJE_FECHA_COMPRA] IS NOT NULL

----------------------------------------------ESTO NO VA MAS--------------------------------------------------------------------------------------
--PRIMERO INSERTO LOS PASAJES Y LUEGO LAS RESERVAS
--VOY A TRATAR DE CREAR LOS PASAJES A TRAVÃS DE INSERCION DE LAS RESERVAS

--INSERT INTO [VAMONIUEL].[PASAJE] 
--([PASAJE_CODIGO],[FECHA_SALIDA],[FECHA_LLEGADA],[FECHA_LLEGADA_ESTIMADA],[ID_Cliente], ID_VIAJE)
--SELECT DISTINCT RESERVA_CODIGO,[FECHA_SALIDA],[FECHA_LLEGADA],[FECHA_LLEGADA_ESTIMADA],
--C.ID, (SELECT TOP 1 V.ID FROM VAMONIUEL.VIAJE V WHERE M.FECHA_SALIDA = V.FechaInicio AND M.FECHA_LLEGADA = V.FechaFin)
--FROM gd_esquema.Maestra M
--LEFT JOIN VAMONIUEL.CLIENTE C ON (M.[CLI_NOMBRE] = C.[CLI_NOMBRE]
--      AND M.[CLI_APELLIDO] = c.[CLI_APELLIDO]
--      AND M.[CLI_DNI] = c.[CLI_DNI]
--      AND M.[CLI_DIRECCION] = c.[CLI_DIRECCION]
--      AND M.[CLI_TELEFONO] = c.[CLI_TELEFONO]
--      AND M.[CLI_MAIL] = c.[CLI_MAIL]
--      AND M.[CLI_FECHA_NAC] = c.[CLI_FECHA_NAC])
--WHERE [PASAJE_CODIGO] IS  NULL    AND [PASAJE_PRECIO] IS  NULL    AND [PASAJE_FECHA_COMPRA] IS  NULL

 -------------------------------------------------------------------------------------------------------------------------

--Cada vez que cargue una reserva se va a ejecutar un trigger que me va a generar un 'pasaje temporal'
--Esto funca sin insertar el id_pasaje
INSERT INTO [VAMONIUEL].[RESERVA]
([RESERVA_CODIGO],[RESERVA_FECHA])
SELECT DISTINCT M.[RESERVA_CODIGO],M.[RESERVA_FECHA]
FROM gd_esquema.Maestra M


	
----------BORRO ESTE TRIGGER YA QUE LUEGO DE LA MIGRACION NO ME SIRVE/ME TRAE PROBLEMAS----------------------------------
DROP TRIGGER VAMONIUEL.tr_creacion_recorridoxtramo
-------------------------------------------------------------------------------------------------------------------------

------------------------------------------- FIN  MIGRACION ----------------------------------------------------------------------------------------------------


------------------------------------------- CREACION DE VISTAS------------------------------------------------------------------------------------------


GO --Yo voy a tener que consultar esto de tal manera que no se cumpla la condición
CREATE VIEW VAMONIUEL.cruceros_ocupados_por_fecha AS
SELECT DISTINCT Cru.[ID],Cru.[CRU_FABRICANTE],Cru.[CRUCERO_MODELO],Cru.[CRUCERO_IDENTIFICADOR],Cru.[habilitado], V.FechaInicio, V.FechaFin
FROM [GD1C2019].[VAMONIUEL].[CRUCERO] Cru JOIN VAMONIUEL.VIAJE V ON (CRU.ID = V.ID_Crucero)
where cru.habilitado = 1
GO

go
CREATE VIEW VAMONIUEL.tramos_asociados_a_recorridos
AS
SELECT r.id idRecorrido,t.ID idTramo, t.PUERTO_DESDE parada1, t.PUERTO_HASTA parada2, t.RECORRIDO_PRECIO_BASE Precio
From VAMONIUEL.RECORRIDO r JOIN VAMONIUEL.TramoXRecorrido tr ON (r.ID = tr.id_recorrido)
JOIN VAMONIUEL.Tramo t on (tr.id_tramo = t.ID)
go


go
CREATE VIEW VAMONIUEL.TipoCabina
AS
SELECT DISTINCT CABINA_TIPO Tipo FROM VAMONIUEL.CABINA
GO

go
CREATE VIEW VAMONIUEL.Marca
AS
SELECT DISTINCT CRU_FABRICANTE Marca FROM VAMONIUEL.CRUCERO
GO

--------------------------------  VIEWS PARA compra y reservas pasajes ------------------------------------------------------------------------------------------------
go
create view VAMONIUEL.viajes_con_oyd
as
select v.ID ID_de_viaje, v.ID_Crucero,v.FechaInicio,v.FechaFin, r.PUERTO_DESDE origen, r.PUERTO_HASTA destino
from VAMONIUEl.VIAJE v join VAMONIUEL.RECORRIDO r on (v.ID_Recorrido = r.ID) 
go

go
create view VAMONIUEL.recorrido_completo_xviaje
as
select 
	v.ID Viaje, p.Nombre Puerto_por_el_que_pasa
from 
	VAMONIUEL.VIAJE v join VAMONIUEL.RECORRIDO r on ( v.ID_Recorrido = r.ID)
	join VAMONIUEL.TramoXRecorrido trr on (trr.id_recorrido=r.ID)
	join VAMONIUEL.Tramo tr on ( tr.ID = trr.id_tramo)
	join VAMONIUEL.TramoXPuerto trp on (trp.id_tramo = tr.ID)
	join VAMONIUEL.Puerto p on (p.ID = trp.id_puerto)
go

go
create view VAMONIUEL.cabinas_del_viaje
as
select cxv.ID_Viaje Viaje, cxv.ID ID_Cabina, c.CABINA_TIPO Tipo_de_cabina,c.CABINA_PISO
from VAMONIUEL.CabinaXViaje cxv join VAMONIUEL.CABINA c on (cxv.ID_Cabina = c.ID)
where cxv.ocupada  = 0
go

go
create view VAMONIUEL.precio_base_recorrido
as
select v.ID viaje, r.ID recorrido, sum(tr.RECORRIDO_PRECIO_BASE) precio_del_recorrido
FROM	
	VAMONIUEL.VIAJE v join VAMONIUEL.RECORRIDO r on (r.ID=v.ID_Recorrido)
	join VAMONIUEL.TramoXRecorrido trr on ( trr.id_recorrido=r.ID)
	join VAMONIUEL.Tramo tr on (trr.id_tramo = tr.id)
group by v.id , r.ID
go

go
create view VAMONIUEL.recargo_cabina_viaje
as
select cxv.ID cabina, c.CABINA_TIPO_PORC_RECARGO recargo
from
	VAMONIUEL.CABINA c  join VAMONIUEL.CabinaXViaje cxv on (cxv.ID_Cabina = c.ID)
go

go
create view VAMONIUEL.proxima_reserva_codigo_a_ins
as
SELECT 
	MAX([RESERVA_CODIGO]) +1 cod
FROM 
	[GD1C2019].[VAMONIUEL].[RESERVA]
go

go
create view VAMONIUEL.proxima_recorrido_codigo_a_ins
as
SELECT 
	MAX([RECORRIDO_CODIGO]) +1 cod
FROM 
	[GD1C2019].[VAMONIUEL].[RECORRIDO]
go

--------------------------------  VIEWS PARA LISTADO ESTADISTICO ------------------------------------------------------------------------------------------------
--View top 5 recorridos con mas pasajes comprados(tomo al pasaje comprado cuando tiene fecha de compra) la otra opcion no me tira resultados por que no hay nada en la tabla de pagos
GO
CREATE VIEW VAMONIUEL.recorridos_mayor_pasajes_comprados
AS
select top 5 r.ID, r.RECORRIDO_CODIGO , v.FechaInicio, count(*) cantidad_pasajes_comprados
from VAMONIUEL.VIAJE v join VAMONIUEL.RECORRIDO r ON (v.ID_Recorrido = r.ID)
	join VAMONIUEL.PASAJE p ON (p.ID_Viaje = v.ID)
--where exists (select ID_Pasaje from VAMONIUEL.PAGO where ID_Pasaje = p.ID) --esta linea es la que considera a la tabla pagos
where  p.PASAJE_FECHA_COMPRA IS NOT NULL
GROUP BY r.ID, r.RECORRIDO_CODIGO,v.FechaInicio
ORDER BY 4 DESC 
GO

--Top 5 de los recorridos con más cabinas libres en cada uno de los viajes realizados.
GO
CREATE VIEW VAMONIUEL.recorridos_mas_cabinas_libres_xviaje
as
select 
	top 5 r.ID, r.RECORRIDO_CODIGO , v.ID viaje, v.Origen, v.Destino, v.FechaInicio, count(*) cantidad_cabinas_libres
from
	VAMONIUEL.RECORRIDO r join VAMONIUEL.VIAJE v on (r.ID = v.ID_Recorrido) 
	join VAMONIUEL.CabinaXViaje cxv on (v.ID = cxv.ID_Viaje)
where
	cxv.ocupada=0 
GROUP BY 
	r.ID, r.RECORRIDO_CODIGO, v.ID, v.Origen, v.Destino,v.FechaInicio
ORDER BY 7 DESC 
GO

--Top 5 de los cruceros con mayor cantidad de días fuera de servicio.
GO
CREATE VIEW VAMONIUEL.cruceros_mayor_cant_dias_fuera_servicio
as
select
	top 5 cr.ID, cr.CRUCERO_MODELO Modelo, cr.CRU_FABRICANTE Fabricante, ec.Fecha_fuera_de_servicio, (DATEDIFF(day, ec.Fecha_fuera_de_servicio, ec.Fecha_reinicio_de_servicio)) cantidad_dias_fuera_de_servicio
FROM
	VAMONIUEL.CRUCERO cr join VAMONIUEL.Estado_del_Crucero ec on (cr.ID=ec.ID_Crucero)
ORDER BY 5 DESC
go

--VIEW para obtener el a�o minimo
go
CREATE VIEW VAMONIUEL.anio_minimo_de_viaje
AS
SELECT MIN(YEAR(v.FechaInicio)) anio
FROM VAMONIUEL.VIAJE V
GO

------------------------------------------- CREACION DE STORED PROCEDURES------------------------------------------------------------------------------------------
GO --FUNCIONA PERFECTO
CREATE PROCEDURE VAMONIUEL.dar_de_baja_reservas_por_logueo_de_admin
AS--Cada vez que se loguea algún admin checkeo si hay alguna reserva pa dar de baja
BEGIN 
	UPDATE [VAMONIUEL].[RESERVA]
	SET Habilitado = 0
	WHERE (DATEDIFF(YEAR, RESERVA_FECHA, GETDATE()) > 0 ) OR
		  (DATEDIFF(MONTH, RESERVA_FECHA, GETDATE()) > 0 ) OR
		  (DATEDIFF(DAY, RESERVA_FECHA, GETDATE()) > 3 )
END
GO

--GO 
--CREATE PROCEDURE VAMONIUEL.dar_de_baja_reservas_por_logueo_de_admin
--AS--Cada vez que se loguea algún admin checkeo si hay alguna reserva pa dar de baja
--BEGIN 
--	DECLARE @id_reserva int
--	DECLARE @id_cabinaxviaje int
--	DECLARE @limite_de_dias int
--	SET @limite_de_dias=3

--	DECLARE  c1 CURSOR FOR
--	--Me traigo el id de la reserva y la de cabinaocupada para luego updatear 
--	--si me pase con la fecha de reserva
--	SELECT R.id, P.ID_CabinaXViaje FROM VAMONIUEL.RESERVA R 
--	JOIN VAMONIUEL.PASAJE P ON R.ID_Pasaje = P.ID
--	JOIN VAMONIUEL.CabinaXViaje CABXVIAJE ON P.ID_CabinaXViaje = CABXVIAJE.ID
--	WHERE (DATEDIFF(YEAR, R.RESERVA_FECHA, GETDATE()) > 0 ) OR
--		  (DATEDIFF(MONTH, R.RESERVA_FECHA, GETDATE()) > 0 ) OR
--		  (DATEDIFF(DAY, R.RESERVA_FECHA, GETDATE()) > @limite_de_dias )

--	OPEN C1
--	FETCH NEXT FROM C1 INTO  @id_reserva, @id_Cabinaxviaje
--	WHILE @@FETCH_STATUS=0
--	BEGIN
--		UPDATE [VAMONIUEL].[RESERVA] SET Habilitado = 0 WHERE ID=@id_reserva
--		UPDATE VAMONIUEL.CabinaXViaje SET Ocupada= 0 WHERE ID=@id_Cabinaxviaje

--		FETCH NEXT FROM C1 INTO  @id_reserva, @id_Cabinaxviaje
--	END

--	CLOSE C1
--	DEALLOCATE C1
--END


--drop trigger vamoniuel.dar_de_baja_reservas_por_pago_de_cliente
GO 
CREATE TRIGGER VAMONIUEL.dar_de_baja_reservas_por_pago_de_cliente ON VAMONIUEL.PAGO
INSTEAD OF INSERT
AS--Cada vez que un cliente quiere pagar, verifico si tiene una reserva valida
BEGIN 
	DECLARE @id_reserva int
	DECLARE @fecha_pago DATETIME
	DECLARE @id_pasaje int
	DECLARE @reserva_Fecha DATETIME
	DECLARE @dias_de_diferencia int
	DECLARE @medio_de_pago nvarchar(200)
	DECLARE @limite_de_dias int
	DECLARE @id_cabina int
	SET @dias_de_diferencia=0
	SET @limite_de_dias=3

	--Puede o no tener una reserva asociada
	SELECT @id_reserva=R.ID, @fecha_pago=i.fecha_pago, @id_pasaje=i.ID_Pasaje, @medio_de_pago= i.[medio_de_pago],
	@reserva_Fecha= R.RESERVA_FECHA, @id_cabina=P.id_cabinaxviaje
	FROM inserted i LEFT JOIN VAMONIUEL.RESERVA R ON I.ID_PASAJE = R.ID_Pasaje
	JOIN VAMONIUEL.PASAJE P ON I.ID_PASAJE = P.ID
	
	--Aca habria que observar si la fecha de pago la ingreso a manopla o es un getdate
	if(@reserva_Fecha is NOT null)
		--Comparo el anio
		if (DATEDIFF(YEAR, @reserva_Fecha, @fecha_pago) > 0  )
		BEGIN SET @dias_de_diferencia=365 END
		ELSE
		BEGIN--Estoy en el mismo anio, evaluo el mes
			if (DATEDIFF(MONTH, @reserva_Fecha, @fecha_pago) > 0 )
			BEGIN SET @dias_de_diferencia=365 END
			ELSE--Estoy en el mismo mes, evaluo el dia
			BEGIN
				if (DATEDIFF(DAY, @reserva_Fecha, @fecha_pago) > @limite_de_dias )
				BEGIN SET @dias_de_diferencia=365 END
			END
		END	

	if( @dias_de_diferencia <= @limite_de_dias)--DIAS BIEN O RESERVA NULL
		BEGIN--Efectuo el pago normalmente
		INSERT INTO [VAMONIUEL].[PAGO]([fecha_pago],medio_de_pago,[ID_Pasaje])
		VALUES (@fecha_pago,@medio_de_pago, @id_pasaje)
		UPDATE [VAMONIUEL].[RESERVA] SET Habilitado = 0 WHERE ID=@id_reserva
		END
	ELSE --Se paso con los dias
		BEGIN
		UPDATE [VAMONIUEL].[RESERVA] SET Habilitado = 0 WHERE ID=@id_reserva
		UPDATE VAMONIUEL.CabinaXViaje SET Ocupada= 0 WHERE ID=@id_cabina
		END
END
GO

GO
CREATE VIEW VAMONIUEL.Roles_usuario
AS
SELECT u.Usuario, r.Nombre as nombre_rol, r.ID as rol_id FROM VAMONIUEL.Usuario u 
join VAMONIUEL.Rol_X_Usuario ru on ru.ID_Usuario = u.ID 
join VAMONIUEL.Rol r on r.ID = ru.ID_ROL 
WHERE r.Habilitado = 1
GO
CREATE VIEW [VAMONIUEL].idClientexNombreUsuario
AS
SELECT c.ID idCliente , u.Usuario nombreUsr 
	FROM [VAMONIUEL].Usuario u join [VAMONIUEL].Cliente c 
		on(u.ID = c.ID_Usuario)
GO
CREATE VIEW [VAMONIUEL].funciones_usuarios
AS
SELECT u.Usuario, r.Nombre as nombre_rol, f.nombre as nombre_funcion, f.ID as funcion_id FROM [VAMONIUEL].Usuario u 
join [VAMONIUEL].Rol_X_Usuario ru on ru.ID_Usuario = u.ID 
join [VAMONIUEL].Rol r on r.ID = ru.ID_ROL 
join [VAMONIUEL].Rol_X_Funcion rf on rf.ID_Rol = r.ID 
join [VAMONIUEL].Funcion f on f.ID = rf.ID_Funcion 
WHERE r.Habilitado = 1
GO
GO
CREATE PROCEDURE [VAMONIUEL].existe_usuario @Usuario nvarchar(50), @Contrasenia nvarchar(max), @resultado bit OUTPUT, @autogenerada bit output
AS
BEGIN
	declare @hash binary(32) = (select HASHBYTES('SHA2_256', @Contrasenia))
	select @resultado = (select case when (select count(*) from VAMONIUEL.Usuario where Contrasenia = @hash and Usuario = @Usuario) >=1 then 1 else 0 end)
	if(@resultado = 1)
	begin
		set @autogenerada = (select contrasena_autogenerada from Usuario where Usuario = @Usuario)
		update Usuario set [cant_accesos_fallidos] = 0 where Usuario = @Usuario
	end
	else
	begin
		if(exists(select * from VAMONIUEL.Usuario where Usuario = @Usuario))
		begin
			update Usuario set [cant_accesos_fallidos] = ((select cant_accesos_fallidos from VAMONIUEL.Usuario where Usuario = @Usuario) + 1) where Usuario = @Usuario
		end
	end
END
GO

