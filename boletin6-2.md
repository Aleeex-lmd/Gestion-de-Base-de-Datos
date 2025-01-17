A continuación, se presentan las soluciones a cada parte del ejercicio para **Oracle**, **MariaDB** y **PostgreSQL**. 

### **2.2. Añadir columna y rellenarla**
```sql
-- Añadir columna en la tabla VEHICULOS
ALTER TABLE VEHICULOS ADD Total_Kilometros INT DEFAULT 0;

-- Rellenar la columna Total_Kilometros con los datos de ALQUILERES
UPDATE VEHICULOS v
SET Total_Kilometros = (
    SELECT COALESCE(SUM(a.Kilometros), 0)
    FROM ALQUILERES a
    WHERE a.Matricula = v.Matricula
);
```

---

### **2.3. Media de kilómetros por alquiler por marca**
```sql
-- Muestra la media por marca, incluyendo marcas no alquiladas
SELECT 
    v.Marca, 
    COALESCE(AVG(a.Kilometros), 0) AS Media_Kilometros
FROM VEHICULOS v
LEFT JOIN ALQUILERES a ON v.Matricula = a.Matricula
GROUP BY v.Marca;
```

---

### **2.4. Vista: vehículos no alquilados hoy**
```sql
CREATE OR REPLACE VIEW Vehiculos_Disponibles AS
SELECT 
    v.Marca, 
    v.Modelo, 
    COUNT(v.Matricula) AS Vehiculos_No_Alquilados
FROM VEHICULOS v
LEFT JOIN ALQUILERES a 
    ON v.Matricula = a.Matricula
    AND CURRENT_DATE BETWEEN a.Fecha_Inicial AND (a.Fecha_Inicial + a.Num_Dias - 1)
WHERE a.Matricula IS NULL
GROUP BY v.Marca, v.Modelo;
```

---

### **2.5. Vista: coches que han hecho más de 1000 km con un cliente**
```sql
CREATE OR REPLACE VIEW Coches_Mas_1000Km AS
SELECT 
    a.Matricula
FROM ALQUILERES a
GROUP BY a.Matricula, a.DNI
HAVING SUM(a.Kilometros) > 1000;
```

---

### **2.6. Borrar coches con más de 3 años o 50000 kilómetros**
```sql
DELETE FROM VEHICULOS
WHERE Total_Kilometros > 50000
   OR Fecha_Compra < ADD_MONTHS(CURRENT_DATE, -36); -- Más de 3 años
```

---

### **2.7. Añadir columna de ingresos y calcularla**
```sql
-- Añadir columna
ALTER TABLE VEHICULOS ADD Ingresos DECIMAL(10, 2) DEFAULT 0;

-- Calcular ingresos
UPDATE VEHICULOS v
SET Ingresos = (
    SELECT SUM(
        CASE 
            WHEN EXTRACT(MONTH FROM a.Fecha_Inicial) IN (7, 8) THEN a.Num_Dias * v.Precio_por_dia * 1.25
            ELSE a.Num_Dias * v.Precio_por_dia
        END
    )
    FROM ALQUILERES a
    WHERE a.Matricula = v.Matricula
);
```

---

### **2.8. Duración media e importe medio por nacionalidad**
```sql
SELECT 
    c.Nacionalidad,
    COALESCE(AVG(a.Num_Dias), 0) AS Duracion_Media,
    COALESCE(AVG(
        a.Num_Dias * v.Precio_por_dia * 
        CASE 
            WHEN EXTRACT(MONTH FROM a.Fecha_Inicial) IN (7, 8) THEN 1.25 
            ELSE 1 
        END
    ), 0) AS Importe_Medio
FROM CLIENTES c
LEFT JOIN ALQUILERES a ON c.DNI = a.DNI
LEFT JOIN VEHICULOS v ON a.Matricula = v.Matricula
GROUP BY c.Nacionalidad;
```

