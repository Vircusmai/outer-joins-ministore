# MiniStore — Análisis de Inventario y Ventas con Outer JOINs

Este proyecto contiene el diagnóstico de consistencia e integridad de datos entre el catálogo de productos y las ventas de MiniStore utilizando técnicas de uniones externas (`LEFT JOIN`, `RIGHT JOIN` y `FULL OUTER JOIN`).

## Estructura del Repositorio
- `schema.sql`: Definición DDL de las tablas `productos` y `ventas` junto con la carga de los datos de prueba.
- `soluciones.sql`: Consultas SQL diseñadas para responder a las preguntas de auditoría del negocio.
- `README.md`: Justificación técnica y conceptual de cada consulta.

---

## Respuestas Técnicas y Justificación de Negocio

### 1. ¿Por qué usamos LEFT JOIN en la Consulta 1 y no INNER JOIN? ¿Qué se perdería con INNER JOIN?
Se utilizó `LEFT JOIN` con la tabla `productos` a la izquierda porque el requerimiento de negocio exige auditar el catálogo completo, incluyendo aquellos productos que **nunca registraron ventas**.  
Si hubiésemos utilizado un `INNER JOIN`, el motor descartaría todas las filas que no tienen coincidencia en la tabla `ventas`. En consecuencia, los productos **108 (Hub USB-C 7p)** y **109 (Parlante Bluetooth)** quedarían excluidos del reporte, impidiendo detectar productos estancados o con inventario inmovilizado.

### 2. ¿Por qué usamos RIGHT JOIN en la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha?
En la Consulta 2 colocamos `productos` a la izquierda (`FROM productos`) y `ventas` a la derecha (`RIGHT JOIN ventas`).  
Se empleó `RIGHT JOIN` para preservar la totalidad de los registros de la tabla de la derecha (`ventas`), sin importar si tienen o no correspondencia en el catálogo. Esto nos permite aislar anomalías transaccionales, detectando ventas registradas con identificadores de producto inexistentes (como la venta con `producto_id = 999`), lo cual evidencia una falla en la integridad referencial del sistema de captura.

### 3. ¿Qué representan los valores NULL en cada resultado?
- **En la Consulta 1 (`v.venta_id IS NULL`):** Representa la **ausencia de transacción comercial**. Significa que el producto existe válidamente en el catálogo, pero nadie lo ha comprado hasta la fecha.
- **En la Consulta 2 (`p.producto_id IS NULL`):** Representa un **registro huérfano por falta de maestro de datos**. Significa que se registró una venta con un `producto_id` (999) que no existe en la tabla de productos, alertando sobre un error humano o una desincronización de catálogos.

### 4. ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?
El `FULL OUTER JOIN` es la herramienta de conciliación y auditoría por excelencia en escenarios como:
- **Fusiones o migraciones de sistemas:** Al migrar dos bases de datos heredadas o integrar la información de dos empresas para detectar registros presentes en solo uno de los lados.
- **Conciliación contable y bancaria:** Para cruzar los extractos emitidos por el banco con los asientos de facturación interna de la empresa, identificando cobros no registrados en el sistema propio y facturas no acreditadas en el banco.
