USE [GD1C2019]
GO

DROP TABLE VAMONIUEL.TramoXPuerto
DROP TABLE VAMONIUEL.RecorridoXViaje
DROP TABLE VAMONIUEL.TramoXRecorrido
DROP TABLE VAMONIUEL.tramo
DROP TABLE VAMONIUEL.ViajeXRecorrido
DROP TABLE VAMONIUEL.Puerto
DROP TABLE VAMONIUEL.RESERVA
DROP TABLE VAMONIUEL.Estado_del_Crucero
DROP TABLE VAMONIUEL.Rol_X_Funcion
DROP TABLE VAMONIUEL.Rol_X_Usuario
DROP TABLE VAMONIUEL.Rol
DROP TABLE VAMONIUEL.Funcion
DROP TABLE VAMONIUEL.PAGO
DROP TABLE [VAMONIUEL].[PASAJE]
DROP TABLE VAMONIUEL.Cliente
DROP TABLE VAMONIUEL.Usuario
DROP VIEW VAMONIUEL.cruceros_ocupados_por_fecha
DROP PROCEDURE VAMONIUEL.dar_de_baja_reservas_por_logueo_de_admin
DROP TRIGGER VAMONIUEL.dar_de_baja_reservas_por_pago_de_cliente
DROP VIEW VAMONIUEL.tramos_asociados_a_recorridos
DROP VIEW VAMONIUEL.Marca
DROP VIEW VAMONIUEL.TipoCabina
DROP VIEW VAMONIUEL.recorridos_mayor_pasajes_comprados
drop VIEW VAMONIUEL.recorridos_mas_cabinas_libres_xviaje
drop VIEW VAMONIUEL.cruceros_mayor_cant_dias_fuera_servicio
DROP TABLE VAMONIUEL.CabinaXViaje
DROP TABLE VAMONIUEL.CABINA
DROP TABLE VAMONIUEL.VIAJE
DROP TABLE VAMONIUEL.RECORRIDO
DROP TABLE VAMONIUEL.CRUCERO
drop VIEW VAMONIUEL.anio_minimo_de_viaje
drop VIEW VAMONIUEL.Roles_usuario
drop VIEW [VAMONIUEL].funciones_usuarios
drop VIEW [VAMONIUEL].idClientexNombreUsuario
drop PROCEDURE [VAMONIUEL].existe_usuario
drop view VAMONIUEL.viajes_con_oyd