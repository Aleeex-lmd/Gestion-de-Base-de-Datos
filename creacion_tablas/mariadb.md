# 📊 Guía Completa: Creación de Tablas en MariaDB

## 🔹 1. Conceptos Básicos
En MariaDB, una **tabla** es una estructura de almacenamiento que organiza datos en filas y columnas. Cada columna tiene un tipo de datos específico y puede incluir restricciones.

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
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) CHECK (salario > 0),
    fecha_contratacion DATE DEFAULT CURRENT_DATE
);
```

## 🔹 3. Tipos de Datos Comunes en MariaDB
| Tipo de Dato  | Descripción |
|--------------|-------------|
| `INT` | Enteros |
| `DECIMAL(p,s)` | Números con `p` dígitos y `s` decimales |
| `VARCHAR(n)` | Texto de longitud variable (hasta `n` caracteres) |
| `CHAR(n)` | Texto de longitud fija |
| `DATE` | Fecha |
| `TEXT` | Texto grande |

## 🔹 4. Restricciones (`CONSTRAINTS`)
Las restricciones aseguran la integridad de los datos en la tabla:
- **`PRIMARY KEY`**: Identifica de forma única cada fila.
- **`NOT NULL`**: No permite valores nulos.
- **`UNIQUE`**: No permite valores duplicados en la columna.
- **`CHECK`**: Define una condición que los datos deben cumplir.
- **`FOREIGN KEY`**: Relaciona una columna con la clave primaria de otra tabla.

### ✅ Ejemplo de Restricciones:
```sql
CREATE TABLE departamentos (
    id_depto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    presupuesto DECIMAL(10,2) CHECK (presupuesto >= 1000)
);
```

## 🔹 5. Creación de una Tabla con Clave Foránea
```sql
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
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
ALTER TABLE empleados MODIFY COLUMN salario DECIMAL(12,2);
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
Las tablas temporales almacenan datos solo durante la sesión.
```sql
CREATE TEMPORARY TABLE temp_datos (
    id INT,
    nombre VARCHAR(50)
);
```

## 🔹 9. Creación de Tablas a partir de otra (`CREATE TABLE AS`)
```sql
CREATE TABLE copia_empleados AS
SELECT * FROM empleados WHERE salario > 3000;
```

## 🔹 10. Uso de Expresiones Regulares en Columnas
Se pueden usar **expresiones regulares** en restricciones `CHECK` para validar formatos de datos, como DNI o números de teléfono.

### ✅ Ejemplo: Validar un DNI (8 dígitos seguidos de una letra)
```sql
CREATE TABLE personas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dni VARCHAR(9) CHECK (dni REGEXP '^[0-9]{8}[A-Z]$')
);
```

### ✅ Ejemplo: Validar un número de teléfono (9 dígitos)
```sql
CREATE TABLE contactos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    telefono VARCHAR(9) CHECK (telefono REGEXP '^[0-9]{9}$')
);
```

## 🔹 11. Sintaxis de Expresiones Regulares en MariaDB
| Patrón | Descripción |
|---------|-------------|
| `^` | Inicio de la cadena |
| `$` | Fin de la cadena |
| `[0-9]` | Cualquier dígito del 0 al 9 |
| `[A-Z]` | Cualquier letra mayúscula de la A a la Z |
| `\d` | Equivalente a `[0-9]` |
| `{n}` | Exactamente `n` repeticiones |
| `{n,m}` | Entre `n` y `m` repeticiones |



