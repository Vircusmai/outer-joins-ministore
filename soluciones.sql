-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Virginia Analia Cusmai
-- Fecha: 2026-10-05
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostramos todos los productos (tabla izquierda) y cruzamos con ventas.
-- Los productos 108 y 109 aparecen con venta_id NULL porque no tienen transacciones.

SELECT 
    p.producto_id,
    p.nombre AS nombre_producto,
    p.categoria,
    p.precio,
    v.venta_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos que no figuran en el catálogo?
-- Colocamos productos a la izquierda y ventas a la derecha (RIGHT JOIN).
-- Garantiza traer todas las ventas, identificando huérfanas con datos de catálogo en NULL.

SELECT 
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta,
    p.producto_id AS producto_id_catalogo,
    p.nombre AS nombre_producto
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestra todos los productos 
-- y todas las ventas sin perder registros, detectando inconsistencias en ambos extremos.

SELECT 
    p.producto_id AS catalogo_id,
    p.nombre AS producto_catalogo,
    p.precio,
    v.venta_id,
    v.producto_id AS venta_producto_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id
ORDER BY p.producto_id, v.venta_id;
