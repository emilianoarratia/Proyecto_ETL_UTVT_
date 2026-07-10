# Proyecto ETL UTVT - DWUTVTVentas

## Contexto
Proyecto práctico para construir un proceso ETL con SSIS, SQL Server y Git para la empresa Comercializadora UTVT S.A. de C.V.

## Objetivo
Cargar archivos CSV de clientes, productos y ventas hacia el Data Warehouse `DWUTVTVentas`, aplicando limpieza, validación, manejo de errores, bitácora de ejecución y automatización.

## Estructura
```text
Proyecto_ETL_UTVT/
├── data/
│   ├── entrada/
│   ├── procesados/
│   └── errores/
├── database/
├── ssis/
├── docs/
├── scripts/
├── evidencias/
├── README.md
├── .gitignore
└── Release_1.0.txt
```

## Archivos de entrada
| Archivo | Registros |
|---|---:|
| Clientes.csv | 1000 |
| Productos.csv | 500 |
| Ventas.csv | 5000 |

## Calidad detectada en insumos
| Validación | Registros detectados |
|---|---:|
| Clientes duplicados | 100 |
| Clientes inactivos | 55 |
| Productos duplicados | 50 |
| Productos inactivos | 26 |
| Productos con precio <= 0 | 31 |
| Ventas duplicadas | 178 |
| Ventas con cantidad <= 0 | 212 |
| Ventas con precio <= 0 | 203 |

## Base de datos
Ejecutar el script:

```sql
database/create_DWUTVTVentas.sql
```

Tablas creadas:
- DimCliente
- DimProducto
- FactVentas
- LogErrores
- LogProceso

## Flujo SSIS solicitado
Paquete: `ssis/CargaVentas.dtsx`

Control Flow:
1. Validar existencia de archivos.
2. Carga Clientes.
3. Carga Productos.
4. Carga Ventas.
5. Registrar estadísticas.
6. Mover archivos.
7. Comprimir archivos.
8. Finalizar proceso.

## Variables requeridas en SSIS
| Variable | Tipo sugerido | Uso |
|---|---|---|
| RutaEntrada | String | Carpeta de archivos CSV |
| RutaProcesados | String | Carpeta de archivos procesados |
| RutaErrores | String | Carpeta de errores |
| FechaProceso | DateTime | Fecha/hora de ejecución |
| TotalLeidos | Int32 | Registros leídos |
| TotalInsertados | Int32 | Registros insertados |
| TotalErrores | Int32 | Registros rechazados |

## Validaciones principales

### Clientes
- Eliminar duplicados.
- Convertir texto a mayúsculas.
- Eliminar espacios innecesarios.
- Reemplazar NULL.
- Excluir clientes inactivos.
- Registrar errores en archivo y tabla `LogErrores`.

### Productos
- Eliminar duplicados.
- Precio mayor que cero.
- Costo mayor que cero.
- Producto activo.
- Categoría válida: Computo, Accesorios, Muebles, Redes, Almacenamiento, Infraestructura.

### Ventas
- Cantidad mayor que cero.
- PrecioUnitario mayor que cero.
- Cliente existente.
- Producto existente.
- FechaVenta válida.
- Venta no duplicada.
- Calcular Subtotal, IVA y Total.

## Fórmulas
```text
Subtotal = Cantidad * PrecioUnitario
IVA = Subtotal * 0.16
Total = Subtotal + IVA
```

## Automatización
Ejecutar PowerShell desde SSIS con Execute Process Task:

```powershell
scripts/comprimir_procesados.ps1
```

El ZIP debe generarse con el formato:

```text
Procesados_YYYYMMDD_HHMMSS.zip
```

## Comandos Git sugeridos
```bash
git init
git add .
git commit -m "feat: crear estructura inicial del proyecto ssis"

git checkout -b feature/clientes
git add .
git commit -m "feat: implementar carga de clientes"

git checkout main
git checkout -b feature/productos
git add .
git commit -m "feat: implementar carga de productos"

git checkout main
git checkout -b feature/ventas
git add .
git commit -m "feat: implementar carga de ventas"

git checkout main
git merge feature/clientes
git merge feature/productos
git merge feature/ventas

git commit -m "fix: corregir validaciones de datos"
git commit -m "docs: agregar diccionario de datos"
git commit -m "refactor: reorganizar control flow en sequence containers"

git tag -a Release_1.0 -m "Primera versión estable del proyecto ETL"
```

## Evidencias a capturar
- Control Flow completo.
- Data Flow Clientes.
- Data Flow Productos.
- Data Flow Ventas.
- Tablas cargadas en SQL Server.
- Tabla LogErrores.
- Tabla LogProceso.
- Carpeta procesados.
- Archivo ZIP generado.
- Historial de Git.
- Ramas.
- Pull Request.
- Release 1.0.

## Nota importante
El archivo `.dtsx` se incluye como plantilla base/documentada. SSIS guarda conexiones y metadatos dependientes del equipo; para ejecución real se debe abrir Visual Studio/SSDT, configurar el Connection Manager de SQL Server y los Flat File Connection Managers con las rutas locales.
