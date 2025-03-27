## Tipos de Valores en Oracle, MariaDB y PostgreSQL

| Tipo de Dato  | Oracle        | MariaDB       | PostgreSQL    |
|--------------|--------------|--------------|--------------|
| Entero      | `NUMBER`     | `INT` | `INTEGER` |
| Decimal     | `NUMBER(p,s)` | `DECIMAL(p,s)` | `NUMERIC(p,s)` |
| Flotante    | `BINARY_FLOAT`, `BINARY_DOUBLE` | `FLOAT`, `DOUBLE` | `REAL`, `DOUBLE PRECISION` |
| Cadena      | `VARCHAR2(n)`, `CHAR(n)` | `VARCHAR(n)`, `CHAR(n)` | `VARCHAR(n)`, `CHAR(n)` |
| Texto Largo | `CLOB`       | `TEXT` | `TEXT` |
| Fecha/Hora  | `DATE`, `TIMESTAMP` | `DATETIME`, `TIMESTAMP` | `DATE`, `TIMESTAMP` |
| Booleano    | No existe (usa `NUMBER(1)`) | `BOOLEAN` | `BOOLEAN` |
| JSON        | `JSON`       | `JSON` | `JSON`, `JSONB` |

### Ejemplos de Tipos de Datos

| Tipo de Dato  | Ejemplo Oracle | Ejemplo MariaDB | Ejemplo PostgreSQL |
|--------------|---------------|----------------|----------------|
| Entero      | `id NUMBER(10);` | `id INT;` | `id INTEGER;` |
| Decimal     | `precio NUMBER(10,2);` | `precio DECIMAL(10,2);` | `precio NUMERIC(10,2);` |
| Flotante    | `valor BINARY_DOUBLE;` | `valor DOUBLE;` | `valor DOUBLE PRECISION;` |
| Cadena      | `nombre VARCHAR2(50);` | `nombre VARCHAR(50);` | `nombre VARCHAR(50);` |
| Texto Largo | `descripcion CLOB;` | `descripcion TEXT;` | `descripcion TEXT;` |
| Fecha/Hora  | `fecha DATE;` | `fecha DATETIME;` | `fecha TIMESTAMP;` |
| Booleano    | `activo NUMBER(1);` | `activo BOOLEAN;` | `activo BOOLEAN;` |
| JSON        | `datos JSON;` | `datos JSON;` | `datos JSONB;` |

---

## Edición de Tablas en Oracle, MariaDB y PostgreSQL

| Operación           | Oracle                      | MariaDB / MySQL             | PostgreSQL                  |
|---------------------|---------------------------|----------------------------|-----------------------------|
| Agregar Columna    | `ALTER TABLE t ADD c INT;` | `ALTER TABLE t ADD c INT;` | `ALTER TABLE t ADD c INT;` |
| Modificar Columna  | `ALTER TABLE t MODIFY c VARCHAR2(50);` | `ALTER TABLE t MODIFY c VARCHAR(50);` | `ALTER TABLE t ALTER COLUMN c TYPE VARCHAR(50);` |
| Eliminar Columna   | `ALTER TABLE t DROP COLUMN c;` | `ALTER TABLE t DROP COLUMN c;` | `ALTER TABLE t DROP COLUMN c;` |
| Renombrar Columna  | `ALTER TABLE t RENAME COLUMN c1 TO c2;` | `ALTER TABLE t CHANGE c1 c2 INT;` | `ALTER TABLE t RENAME COLUMN c1 TO c2;` |
| Renombrar Tabla    | `ALTER TABLE t RENAME TO t_new;` | `RENAME TABLE t TO t_new;` | `ALTER TABLE t RENAME TO t_new;` |
| Agregar Clave Primaria | `ALTER TABLE t ADD PRIMARY KEY (c);` | `ALTER TABLE t ADD PRIMARY KEY (c);` | `ALTER TABLE t ADD PRIMARY KEY (c);` |
| Agregar Índice     | `CREATE INDEX idx ON t(c);` | `CREATE INDEX idx ON t(c);` | `CREATE INDEX idx ON t(c);` |
| Eliminar Índice    | `DROP INDEX idx;` | `DROP INDEX idx;` | `DROP INDEX idx;` |

### Ejemplos de Edición de Tablas

| Operación           | Ejemplo Oracle | Ejemplo MariaDB | Ejemplo PostgreSQL |
|---------------------|---------------|----------------|----------------|
| Agregar Columna    | `ALTER TABLE empleados ADD edad INT;` | `ALTER TABLE empleados ADD edad INT;` | `ALTER TABLE empleados ADD edad INT;` |
| Modificar Columna  | `ALTER TABLE empleados MODIFY nombre VARCHAR2(100);` | `ALTER TABLE empleados MODIFY nombre VARCHAR(100);` | `ALTER TABLE empleados ALTER COLUMN nombre TYPE VARCHAR(100);` |
| Eliminar Columna   | `ALTER TABLE empleados DROP COLUMN direccion;` | `ALTER TABLE empleados DROP COLUMN direccion;` | `ALTER TABLE empleados DROP COLUMN direccion;` |
| Renombrar Columna  | `ALTER TABLE empleados RENAME COLUMN nombre TO nombre_completo;` | `ALTER TABLE empleados CHANGE nombre nombre_completo VARCHAR(100);` | `ALTER TABLE empleados RENAME COLUMN nombre TO nombre_completo;` |
| Renombrar Tabla    | `ALTER TABLE empleados RENAME TO empleados_nuevo;` | `RENAME TABLE empleados TO empleados_nuevo;` | `ALTER TABLE empleados RENAME TO empleados_nuevo;` |
| Agregar Clave Primaria | `ALTER TABLE empleados ADD PRIMARY KEY (id);` | `ALTER TABLE empleados ADD PRIMARY KEY (id);` | `ALTER TABLE empleados ADD PRIMARY KEY (id);` |
| Agregar Índice     | `CREATE INDEX idx_nombre ON empleados(nombre);` | `CREATE INDEX idx_nombre ON empleados(nombre);` | `CREATE INDEX idx_nombre ON empleados(nombre);` |
| Eliminar Índice    | `DROP INDEX idx_nombre;` | `DROP INDEX idx_nombre;` | `DROP INDEX idx_nombre;` |

Estas tablas ofrecen una comparación clara entre Oracle, MariaDB y PostgreSQL en cuanto a los tipos de datos soportados y la forma de editar sus tablas, incluyendo ejemplos de uso en una tablastinkface separada.
