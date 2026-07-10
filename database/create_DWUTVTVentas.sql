CREATE DATABASE DWUTVTVentas;
GO

USE DWUTVTVentas;
GO

IF OBJECT_ID('dbo.FactVentas','U') IS NOT NULL DROP TABLE dbo.FactVentas;
IF OBJECT_ID('dbo.DimProducto','U') IS NOT NULL DROP TABLE dbo.DimProducto;
IF OBJECT_ID('dbo.DimCliente','U') IS NOT NULL DROP TABLE dbo.DimCliente;
IF OBJECT_ID('dbo.LogErrores','U') IS NOT NULL DROP TABLE dbo.LogErrores;
IF OBJECT_ID('dbo.LogProceso','U') IS NOT NULL DROP TABLE dbo.LogProceso;
GO

CREATE TABLE dbo.DimCliente(
    IdClienteSK INT IDENTITY(1,1) PRIMARY KEY,
    IdClienteOrigen INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Correo VARCHAR(150) NULL,
    Telefono VARCHAR(20) NULL,
    Ciudad VARCHAR(100) NULL,
    Estado VARCHAR(100) NULL,
    Pais VARCHAR(100) NULL,
    FechaRegistro DATE NULL,
    FechaCarga DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_DimCliente_Origen UNIQUE(IdClienteOrigen)
);
GO

CREATE TABLE dbo.DimProducto(
    IdProductoSK INT IDENTITY(1,1) PRIMARY KEY,
    IdProductoOrigen INT NOT NULL,
    NombreProducto VARCHAR(150) NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Precio DECIMAL(12,2) NOT NULL,
    Costo DECIMAL(12,2) NOT NULL,
    FechaCarga DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_DimProducto_Origen UNIQUE(IdProductoOrigen),
    CONSTRAINT CK_DimProducto_Precio CHECK(Precio > 0),
    CONSTRAINT CK_DimProducto_Costo CHECK(Costo > 0),
    CONSTRAINT CK_DimProducto_Categoria CHECK(Categoria IN
        ('Computo','Accesorios','Muebles','Redes','Almacenamiento','Infraestructura'))
);
GO

CREATE TABLE dbo.FactVentas(
    IdVentaSK INT IDENTITY(1,1) PRIMARY KEY,
    IdVentaOrigen INT NOT NULL,
    IdClienteSK INT NOT NULL,
    IdProductoSK INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(12,2) NOT NULL,
    Subtotal DECIMAL(12,2) NOT NULL,
    IVA DECIMAL(12,2) NOT NULL,
    Total DECIMAL(12,2) NOT NULL,
    FechaVenta DATE NOT NULL,
    Sucursal VARCHAR(100) NULL,
    FechaCarga DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_FactVentas_Origen UNIQUE(IdVentaOrigen),
    CONSTRAINT FK_FactVentas_DimCliente FOREIGN KEY(IdClienteSK) REFERENCES dbo.DimCliente(IdClienteSK),
    CONSTRAINT FK_FactVentas_DimProducto FOREIGN KEY(IdProductoSK) REFERENCES dbo.DimProducto(IdProductoSK),
    CONSTRAINT CK_FactVentas_Cantidad CHECK(Cantidad > 0),
    CONSTRAINT CK_FactVentas_Precio CHECK(PrecioUnitario > 0)
);
GO

CREATE TABLE dbo.LogErrores(
    IdError INT IDENTITY(1,1) PRIMARY KEY,
    NombrePaquete VARCHAR(100) NOT NULL,
    NombreFlujo VARCHAR(100) NOT NULL,
    ArchivoOrigen VARCHAR(150) NOT NULL,
    FilaOrigen VARCHAR(MAX) NULL,
    DescripcionError VARCHAR(500) NOT NULL,
    FechaError DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.LogProceso(
    IdProceso INT IDENTITY(1,1) PRIMARY KEY,
    NombrePaquete VARCHAR(100) NOT NULL,
    FechaInicio DATETIME NOT NULL,
    FechaFin DATETIME NULL,
    DuracionSegundos INT NULL,
    TotalLeidos INT NULL,
    TotalInsertados INT NULL,
    TotalErrores INT NULL,
    Estatus VARCHAR(50) NOT NULL,
    Mensaje VARCHAR(500) NULL
);
GO

-- Consulta de validación para evidencias
SELECT COUNT(*) AS TotalClientes FROM dbo.DimCliente;
SELECT COUNT(*) AS TotalProductos FROM dbo.DimProducto;
SELECT COUNT(*) AS TotalVentas FROM dbo.FactVentas;
SELECT COUNT(*) AS TotalErrores FROM dbo.LogErrores;
SELECT TOP 20 * FROM dbo.LogProceso ORDER BY IdProceso DESC;
GO