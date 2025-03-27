# 📈 Guía Completa: Creación de Tablas en PostgreSQL

## 🔹 1. Conceptos Básicos
En PostgreSQL, una **tabla** organiza los datos en filas y columnas. Cada columna tiene un tipo de dato específico y puede incluir restricciones.

## 🔹 2. Sintaxis Básica de `CREATE TABLE`
```sql
CREATE TABLE nombre_tabla (
    nombre_columna TIPO_DE_DATO CONSTRAINTS,
    nombre_columna2 TIPO_DE_DATO CONSTRAINTS,
    ...
);
```

### ✅ Ejemplo:
```sql
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) CHECK (salario > 0),
    fecha_contratacion DATE DEFAULT CURRENT_DATE
);
```

## 🔹 3. Tipos de Datos Comunes en PostgreSQL
| Tipo de Dato  | Descripción |
|--------------|-------------|
| `SERIAL` | Entero autoincremental |
| `VARCHAR(n)` | Texto de longitud variable (hasta `n` caracteres) |
| `TEXT` | Texto sin límite de longitud |
| `INTEGER` | Números enteros |
| `DECIMAL(p,s)` | Números decimales con `p` dígitos y `s` decimales |
| `BOOLEAN` | Verdadero o falso |
| `DATE` | Fecha |
| `TIMESTAMP` | Fecha y hora |

## 🔹 4. Restricciones (`CONSTRAINTS`)
Las restricciones aseguran la integridad de los datos:
- **`PRIMARY KEY`**: Identifica de forma única cada fila.
- **`NOT NULL`**: No permite valores nulos.
- **`UNIQUE`**: No permite valores duplicados.
- **`CHECK`**: Define condiciones que los datos deben cumplir.
- **`FOREIGN KEY`**: Relaciona una columna con la clave primaria de otra tabla.

### ✅ Ejemplo de Restricciones:
```sql
CREATE TABLE departamentos (
    id_depto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    presupuesto DECIMAL(12,2) CHECK (presupuesto >= 1000)
);
```

## 🔹 5. Creación de una Tabla con Clave Foránea
```sql
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    id_depto INT,
    FOREIGN KEY (id_depto) REFERENCES departamentos(id_depto)
);
```

## 🔹 6. Modificación de Tablas (`ALTER TABLE`)

### ✅ Agregar una nueva columna:
```sql
ALTER TABLE empleados ADD COLUMN email VARCHAR(100);
```

### ✅ Modificar una columna:
```sql
ALTER TABLE empleados ALTER COLUMN salario TYPE DECIMAL(12,2);
```

### ✅ Eliminar una columna:
```sql
ALTER TABLE empleados DROP COLUMN email;
```

### ✅ Agregar una restricción:
```sql
ALTER TABLE empleados ADD CONSTRAINT fk_depto FOREIGN KEY (id_depto) REFERENCES departamentos(id_depto);
```

## 🔹 7. Eliminación de una Tabla (`DROP TABLE`)
```sql
DROP TABLE empleados;
```

## 🔹 8. Creación de Tablas Temporales
Las tablas temporales almacenan datos solo durante una sesión o transacción.
```sql
CREATE TEMP TABLE temp_datos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
);
```

## 🔹 9. Creación de Tablas a partir de otra (`CREATE TABLE AS`)
```sql
CREATE TABLE copia_empleados AS
SELECT * FROM empleados WHERE salario > 3000;
```

## 🔹 10. Uso de Expresiones Regulares en Columnas
PostgreSQL permite validar formatos de datos usando **expresiones regulares** en restricciones `CHECK`.

### ✅ Ejemplo: Validar un DNI (8 dígitos seguidos de una letra)
```sql
CREATE TABLE personas (
    id SERIAL PRIMARY KEY,
    dni VARCHAR(9) CHECK (dni ~ '^[0-9]{8}[A-Z]$')
);
```

### ✅ Ejemplo: Validar un número de teléfono (9 dígitos)
```sql
CREATE TABLE contactos (
    id SERIAL PRIMARY KEY,
    telefono VARCHAR(9) CHECK (telefono ~ '^\d{9}$')
);
```

## 🔹 11. Sintaxis de Expresiones Regulares en PostgreSQL
| Patrón | Descripción |
|---------|-------------|
| `^` | Inicio de la cadena |
| `$` | Fin de la cadena |
| `[0-9]` | Cualquier dígito del 0 al 9 |
| `[A-Z]` | Cualquier letra mayúscula de la A a la Z |
| `\d` | Equivalente a `[0-9]` |
| `{n}` | Exactamente `n` repeticiones |
| `{n,m}` | Entre `n` y `m` repeticiones |



