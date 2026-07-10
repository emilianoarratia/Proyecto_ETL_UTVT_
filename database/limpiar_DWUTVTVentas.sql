-- ============================================================
-- limpiar_DWUTVTVentas.sql
-- Limpia los datos de todas las tablas para poder volver
-- a ejecutar el paquete SSIS sin errores de duplicados.
-- ============================================================

USE DWUTVTVentas;
GO

-- Deshabilitar restricciones de FK temporalmente
ALTER TABLE dbo.FactVentas NOCHECK CONSTRAINT ALL;
GO

-- Limpiar en orden: primero hechos, luego dimensiones, luego logs
DELETE FROM dbo.FactVentas;
DELETE FROM dbo.DimCliente;
DELETE FROM dbo.DimProducto;
DELETE FROM dbo.LogErrores;
DELETE FROM dbo.LogProceso;

-- Resetear identidades
DBCC CHECKIDENT ('dbo.FactVentas',  RESEED, 0);
DBCC CHECKIDENT ('dbo.DimCliente',  RESEED, 0);
DBCC CHECKIDENT ('dbo.DimProducto', RESEED, 0);
DBCC CHECKIDENT ('dbo.LogErrores',  RESEED, 0);
DBCC CHECKIDENT ('dbo.LogProceso',  RESEED, 0);

-- Rehabilitar restricciones de FK
ALTER TABLE dbo.FactVentas CHECK CONSTRAINT ALL;
GO

PRINT 'Base de datos limpiada. Lista para nueva ejecucion.';
