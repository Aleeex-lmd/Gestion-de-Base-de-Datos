Aquí tienes las consultas SQL para resolver las preguntas planteadas en **MariaDB**, **Oracle**, y **PostgreSQL**. Asegúrate de adaptar los nombres de las tablas y columnas a los esquemas específicos de tu base de datos.

---

### **1.2. Caladeros con más de 1000 kilos de pescado azul en los últimos tres meses**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT c.nombre AS caladero, SUM(ca.kilos) AS total_kilos
FROM Caladeros c
JOIN Capturas ca ON c.codigo_caladero = ca.codigo_caladero
JOIN Especies e ON ca.codigo_especie = e.codigo_especie
WHERE e.tipo = 'pescado azul' 
  AND ca.fecha_captura >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY c.nombre
HAVING SUM(ca.kilos) > 1000
ORDER BY total_kilos DESC;
```

---

### **1.3. Añadir columna `KilosTotalesCapturados` a la tabla `Caladeros` y rellenarla**
```sql
-- Añadir columna (MariaDB, Oracle, PostgreSQL)
ALTER TABLE Caladeros ADD COLUMN KilosTotalesCapturados BIGINT;

-- Rellenar columna con datos de la tabla Capturas
UPDATE Caladeros c
SET KilosTotalesCapturados = (
    SELECT COALESCE(SUM(ca.kilos), 0)
    FROM Capturas ca
    WHERE ca.codigo_caladero = c.codigo_caladero
);
```

---

### **1.4. Crear vista con nombre del barco, último lote vendido, especie y dinero ganado**
```sql
-- Crear vista (MariaDB, Oracle, PostgreSQL)
CREATE VIEW VistaBarcosLotes AS
SELECT b.nombre AS barco, 
       l.codigo_lote AS ultimo_lote,
       e.nombre AS especie,
       l.dinero_ganado
FROM Barcos b
JOIN Lotes l ON b.codigo_barco = l.codigo_barco
JOIN Especies e ON l.codigo_especie = e.codigo_especie
WHERE l.fecha_venta = (
    SELECT MAX(l2.fecha_venta)
    FROM Lotes l2
    WHERE l2.codigo_barco = b.codigo_barco
);
```

---

### **1.5. Barcos que capturaron más de 1200 kilos de sardinas en el caladero 'Terranova'**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT b.nombre AS barco, SUM(ca.kilos) AS total_kilos
FROM Barcos b
JOIN Capturas ca ON b.codigo_barco = ca.codigo_barco
JOIN Caladeros c ON ca.codigo_caladero = c.codigo_caladero
JOIN Especies e ON ca.codigo_especie = e.codigo_especie
WHERE e.nombre = 'sardinas' AND c.nombre = 'Terranova'
GROUP BY b.nombre
HAVING SUM(ca.kilos) > 1200;
```

---

### **1.6. Especies ordenadas por kilos vendidos en Febrero**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT e.nombre AS especie, SUM(l.kilos) AS total_kilos
FROM Especies e
JOIN Lotes l ON e.codigo_especie = l.codigo_especie
WHERE EXTRACT(MONTH FROM l.fecha_venta) = 2
GROUP BY e.nombre
ORDER BY total_kilos DESC;
```

---

### **1.7. Barcos que superaron el cupo de capturas de alguna especie**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT b.nombre AS barco, e.nombre AS especie, SUM(ca.kilos) AS kilos_capturados, e.cupo
FROM Barcos b
JOIN Capturas ca ON b.codigo_barco = ca.codigo_barco
JOIN Especies e ON ca.codigo_especie = e.codigo_especie
GROUP BY b.nombre, e.nombre, e.cupo
HAVING SUM(ca.kilos) > e.cupo;
```

---

### **1.8. Armador con más ingresos por venta de pescado**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT a.nombre AS armador, SUM(l.dinero_ganado) AS total_ingresos
FROM Armadores a
JOIN Barcos b ON a.codigo_armador = b.codigo_armador
JOIN Lotes l ON b.codigo_barco = l.codigo_barco
GROUP BY a.nombre
ORDER BY total_ingresos DESC
LIMIT 1; -- Eliminar LIMIT en Oracle; usar FETCH FIRST ROW ONLY
```

---

### **1.9. Barcos con más capturas por nacionalidad**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT b.nombre AS barco, b.nacionalidad, SUM(ca.kilos) AS total_kilos
FROM Barcos b
JOIN Capturas ca ON b.codigo_barco = ca.codigo_barco
GROUP BY b.nombre, b.nacionalidad
HAVING SUM(ca.kilos) = (
    SELECT MAX(SUM(ca2.kilos))
    FROM Capturas ca2
    JOIN Barcos b2 ON ca2.codigo_barco = b2.codigo_barco
    WHERE b2.nacionalidad = b.nacionalidad
    GROUP BY b2.nacionalidad
)
ORDER BY b.nacionalidad;
```

