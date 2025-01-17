# Gestión de Bases de Datos  
## Tema 4: Lenguaje de Manipulación de Datos en ORACLE  
---

## Índice  
1. [Consultas sencillas](#consultas-sencillas)  
2. [Subconsultas](#subconsultas)  
3. [Combinaciones de tablas](#combinaciones-de-tablas)  
4. [Inserción de registros. Consultas de datos anexados](#inserción-de-registros-consultas-de-datos-anexados)  
5. [Modificación de registros. Consultas de actualización](#modificación-de-registros-consultas-de-actualización)  
6. [Borrado de registros. Consultas de eliminación](#borrado-de-registros-consultas-de-eliminación)  
7. [Cláusulas avanzadas de selección](#cláusulas-avanzadas-de-selección)  
   7.1. [Group by y having](#group-by-y-having)  
   7.2. [Outer joins. Combinaciones externas](#outer-joins-combinaciones-externas)  
   7.3. [Consultas con operadores de conjuntos](#consultas-con-operadores-de-conjuntos)  
   7.4. [Subconsultas correlacionadas](#subconsultas-correlacionadas)  
8. [Control de transacciones en SQL](#control-de-transacciones-en-sql)

---

## 1. Consultas sencillas. Sintaxis  
Para realizar consultas sobre los datos existentes se emplea la sentencia `SELECT`, cuyo formato básico es el siguiente:

```sql
SELECT [ALL | DISTINCT] [colum1, ..column | *]  
FROM tabla1, .., tablan  
[WHERE condicion]  
[ORDER BY col1 [DESC | ASC], col2 [DESC | ASC],…]
```

---

### 1.1. Consultas sencillas. ALL y DISTINCT

- `ALL`: Recupera todas las filas, opción por defecto.  
- `DISTINCT`: Recupera las filas distintas.

Ejemplos:

```sql
SELECT DISTINCT deptno FROM emp;
SELECT DISTINCT sal FROM emp;
```

---

### 1.2. Consultas sencillas. FROM

- `FROM`: Obligatoria, se especifican las tablas donde está la información necesaria.

```sql
SELECT * FROM emp;
```

- Si el usuario no es propietario de las tablas:

```sql
SELECT * FROM usuario.emp;
```

- Se puede poner alias a las tablas:

```sql
SELECT * FROM emp e;
```

---

### 1.3. Consultas sencillas. WHERE

- `WHERE` condición  
  La condición tendrá la forma: expresión operador expresión

- Operadores: `IN`, `NOT IN`, `BETWEEN`, `NOT BETWEEN`, `LIKE`

- Condiciones múltiples: `AND`, `OR`, `NOT`, `( )`

Ejemplos:

```sql
WHERE SAL > 1000;
WHERE (SAL > 1000) AND (COMM IS NOT NULL);
WHERE (comm IS NULL) AND (UPPER(ENAME) = 'MARY');
```

---

### 1.4. Consultas sencillas. Proyección

La proyección es la operación por la que se seleccionan determinadas columnas de las tablas consultadas.

```sql
SELECT [ALL|DISTINCT] colum1, ..column  
FROM tabla1,…tablan;
```

- Todas las columnas:

```sql
SELECT empno, ename, ... FROM EMP;
```

O bien:

```sql
SELECT * FROM emp;
```

- Algunas columnas:

```sql
SELECT deptno, dname FROM dept;
```

---

### 1.5. Consultas sencillas. Selección

La selección es la operación por la que se seleccionan determinadas filas de las tablas consultadas. Se realiza mediante la cláusula `WHERE` condición.

Ejemplos:

```sql
SELECT ename, job, mgr FROM emp WHERE deptno = 10;
SELECT * FROM emp WHERE job = 'CLERK' AND deptno = 10;
```

---

### 1.6. Consultas sencillas. Alias de columnas y tablas

Si el nombre de la columna resulta demasiado largo, corto o es poco significativo, se puede hacer uso de los alias de columnas. También pueden usarse los alias de tablas para no tener que usar el nombre completo de la tabla en el resto de la `SELECT` si tenemos que especificar a qué tabla pertenece una columna.

Ejemplo:

```sql
SELECT ename "nombre empleado", dname "nombre departamento"  
FROM emp e, dept d  
WHERE e.deptno = d.deptno;
```

---

### 1.7. Consultas sencillas. Ordenación

La ordenación de la consulta se realiza con la cláusula `ORDER BY columna [ASC|DESC]`.

- Por defecto se ordena de forma ascendente (`ASC`).

```sql
SELECT ename FROM emp ORDER BY sal * 12;
```

- Para tener 2 o más criterios de ordenación, el principal es el situado más a la izquierda y en caso de igualdad se van aplicándolos siguientes:

```sql
SELECT ename, job, sal * 12 AS salario_anual  
FROM emp  
ORDER BY job ASC, sal * 12 DESC;
```

---

### 1.8. Consultas sencillas. Vistas

Se puede poner un nombre a una consulta, a esto se le llama crear una vista. La sintaxis es la siguiente:

```sql
CREATE VIEW nombrevista AS  
SELECT...
```

Posteriormente se puede hacer una consulta usando la vista en la cláusula `FROM` en lugar de una tabla.

Ejemplo:

```sql
CREATE VIEW EMP30 AS  
SELECT * FROM EMP WHERE DEPTNO = 30;
```

Y:

```sql
SELECT ENAME, JOB FROM EMP30;
```


## 2. Subconsultas. Definición y sintaxis

### Definición:
Las subconsultas son consultas que se usan dentro de la cláusula WHERE de otra consulta.

### Sintaxis:
```sql
SELECT ……………
FROM ………
WHERE columna operador (SELECT ….
                         FROM....
                         WHERE… );
```

## 2. Subconsultas. Ejemplo

**Consulta**: Obtén los nombres de los empleados con el mismo oficio que Gil.

Primero averiguamos el oficio de Gil, así:
```sql
SELECT job
FROM emp
WHERE ename = 'Gil';
```

Y después mostramos los empleados cuyo oficio es el que hemos obtenido anteriormente:
```sql
SELECT ename
FROM emp
WHERE job = (SELECT job
             FROM emp
             WHERE ename = 'Gil');
```

## 2. Subconsultas. Ejemplo

Consulta los nombres y oficios de los empleados del departamento 20 cuyo oficio sea igual al de cualquiera de los empleados del departamento SALES.
```sql
SELECT ename, job
FROM emp
WHERE deptno = 20
AND job IN (SELECT job
            FROM emp
            WHERE deptno = (SELECT deptno
                            FROM dept
                            WHERE dname = 'SALES'));
```

## 2. Subconsultas. Condiciones de Búsqueda (I)

Las subconsultas aparecen como parte de una condición de búsqueda de una cláusula WHERE o HAVING.

### Las condiciones de búsqueda son:
- Test de comparación en subconsultas (<, >..)
- Test de pertenencia a un conjunto de valores (IN).
- Test de existencia (EXISTS, NO EXISTS).
- Test de comparación cuantificada (ANY, ALL).

## 2. Subconsultas. Condiciones de Búsqueda (II)

### Test de comparación en subconsultas.
Operadores utilizables: `<`, `>`, `=`, `>=`, `<=`, `<>`, `!=`.

Compara el valor de una expresión con un valor único producido por una subconsulta.

**Ejemplo**:
```sql
SELECT ename
FROM emp
WHERE job = (SELECT job
             FROM emp
             WHERE ename = 'JAMES');
```

## 2. Subconsultas. Condiciones de Búsqueda (III)

### Test de pertenencia a un conjunto de valores (IN).
Comprueba si el valor de una expresión es uno de los valores producidos por una subconsulta.

**Ejemplo**:
```sql
SELECT ename
FROM emp
WHERE job IN (SELECT job
              FROM emp
              WHERE deptno = 20);
```

## 2. Subconsultas. Condiciones de Búsqueda (IV)

### Test de existencia (EXISTS, NO EXISTS).
Si la subconsulta contiene filas, el test adopta el valor verdadero. Si la subconsulta no contiene ninguna fila, el test toma el valor falso.

**Ejemplo**:
```sql
SELECT dname
FROM dept
WHERE EXISTS (SELECT *
              FROM emp
              WHERE emp.deptno = dept.deptno);
```

## 2. Subconsultas. Condiciones de Búsqueda (V)

### Test de comparación cuantificada (ANY, ALL).
Se usan junto a operadores relacionales: `<`, `>`, etc.

- **ANY**: Compara el valor de una expresión con cada uno de los valores producidos por una subconsulta. Si alguna de las comparaciones devuelve TRUE, ANY devuelve TRUE. Si la subconsulta no devuelve nada, devolverá FALSE.
- **ALL**: Compara el valor de una expresión con cada uno de los valores producidos por una subconsulta. Si todas las comparaciones devuelven TRUE, ALL devuelve TRUE. En caso contrario, devolverá FALSE.

**Ejemplos de test de comparación cuantificada**:

- **Ejemplo ANY**:
```sql
SELECT *
FROM emp
WHERE sal = ANY (SELECT sal
                 FROM emp
                 WHERE deptno = 30);
```

- **Ejemplo ALL**:
```sql
SELECT *
FROM emp
WHERE sal < ALL (SELECT sal
                 FROM emp
                 WHERE deptno = 30);
```

## 2. Subconsultas. Subconsultas que generan valores simples

En algunos casos, podemos estar seguros de que una subconsulta va a devolver **SIEMPRE** una sola fila. En ese caso, podremos usar un operador relacional.

Si usamos `=` y la subconsulta devuelve más de un valor, se originará un error.

**Ejemplo**:
```sql
SELECT ename
FROM emp
WHERE job = (SELECT job
             FROM emp
             WHERE empno = 7082);
```

### Actividad: Averigua cuándo podemos usar un operador relacional sabiendo que no fallará nunca.

## 2. Subconsultas. Subconsultas que generan conjuntos de valores

La mayoría de las subconsultas pueden devolver más de una fila. En estos casos, debo utilizar el operador de pertenencia a un conjunto de valores (IN).

**Ejemplo**:
```sql
SELECT ename
FROM emp
WHERE job IN (SELECT job
              FROM emp
              WHERE deptno = 20);
```

## 2. Subconsultas. Ejemplos

- **Visualizar los datos de los empleados que trabajan en DALLAS o CHICAGO**:
```sql
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM dept
                 WHERE loc IN ('DALLAS', 'CHICAGO'));
```

- **Muestra los nombres de los empleados con el mismo oficio y salario que JAMES**:
```sql
SELECT ename, sal
FROM emp
WHERE (job, sal) = (SELECT job, sal
                    FROM emp
                    WHERE ename = 'JAMES');
```
## 3. Combinación de tablas

Cuando los datos que queremos mostrar se encuentran en varias tablas diferentes, es necesario colocarlas todas en el `FROM`. Cuando se hace esto, el gestor realiza el **producto cartesiano** de todas las tablas, es decir, combina cada fila de una de ellas con todas las filas de las otras. Esto genera filas sin sentido que es necesario filtrar con la llamada **condición de join**. A esto se le llama **combinación de tablas**.

### Formato:
```sql
SELECT columnas_de_las_tablas
FROM tabla1, tabla2…
WHERE tabla1.columna1 = tabla2.columna2;  -- condición de join
```

## 3. Combinación de tablas. Ejemplo de funcionamiento

Veamos un ejemplo del funcionamiento de la combinación:

Si queremos mostrar el nombre del empleado junto al nombre de su departamento, debemos obtener información de ambas tablas. Si hacemos `SELECT ENAME, DNAME FROM EMP, DEPT` olvidando la condición de join, el resultado será el producto cartesiano de ambas tablas:

### Tablas:
**Tabla EMP**:
| EMPNO | ENAME | DEPTNO |
|-------|-------|--------|
| 123   | PEPE  | 10     |
| 456   | ANA   | 10     |
| 789   | EVA   | 20     |

**Tabla DEPT**:
| DEPTNO | DNAME  | LOC   |
|--------|--------|-------|
| 10     | VENTAS | CORIA |
| 20     | I+D    | LORA  |
| 30     | PERSONAL | PILAS |

### Resultado sin condición de join:
| ENAME | DNAME   |
|-------|---------|
| PEPE  | VENTAS  |
| PEPE  | I+D     |
| PEPE  | PERSONAL|
| ANA   | VENTAS  |
| ANA   | I+D     |
| ANA   | PERSONAL|
| EVA   | VENTAS  |
| EVA   | I+D     |
| EVA   | PERSONAL|

Como se puede ver, el resultado es el producto cartesiano de ambas tablas, es decir, cada fila de una tabla se combina con todas las filas de la otra tabla.

## 3. Combinación de tablas. Reglas a seguir

- Se pueden unir tantas tablas como deseemos.
- El número de condiciones de join a incluir en la sentencia será el número de tablas menos uno.
- En la proyección, podemos usar columnas de todas las tablas incluidas.
- Si hay columnas con el mismo nombre en varias tablas, se deben especificar para evitar ambigüedades con la sintaxis:
  ```sql
  Nombre_tabla.nombre_columna.
  ```
- Se debe intentar evitar realizar combinaciones de tablas muy grandes por el gran consumo de recursos del servidor que conllevan.

## 3. Combinación de tablas. Ejemplos

1. **Consultar nombre de empleados, salario, nombre del departamento al que pertenecen y localidad de este**:
```sql
SELECT e.ename, e.sal, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;
```

2. **Muestra los nombres de los empleados con un salario entre 500 y 1000, cuyo oficio sea MANAGER**:
```sql
SELECT ename
FROM emp
WHERE sal BETWEEN 500 AND 1000
AND job = 'MANAGER';
```

3. **Muestra los nombres de los departamentos que no tengan empleados**:
```sql
SELECT dname
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);
```

4. **Muestra los nombres de los departamentos que tengan algún empleado**:
```sql
SELECT dname
FROM dept
WHERE deptno IN (SELECT deptno FROM emp);
```


## 4. Inserción de registros

Si queremos añadir datos individuales a una tabla debemos emplear la orden `INSERT...VALUES`.

### Formato:
```sql
INSERT INTO nombre_tabla [(colum1 [,(…)]]
VALUES (valor1 [, valor2]…);
```

Si no se especifican columnas, se entiende que serán todas las columnas de la tabla. Los valores que se darán a cada columna deben tener el mismo tipo de dato con el que se definió la columna. Si una columna no está en la lista, recibirá `NULL`. Si al crear la tabla se había definido como `NOT NULL`, la orden `INSERT` fallará.

## 4. Inserción de registros. Ejemplos

1. **Insertar un nuevo registro en la tabla `profesores`**:
```sql
INSERT INTO profesores (apellidos, especialidad, cod_centro)
VALUES ('Quiroga Martín, Mª Isabel', 'INFORMATICA', 45);
```

2. **Intento de inserción sin especificar todos los valores** (esto generará un error):
```sql
INSERT INTO profesores (apellidos, especialidad, cod_centro)
VALUES ('Seco Jiménez, Ernesto', 'LENGUA');
```
*Error: Falta el valor para `cod_centro`.*

3. **Insertar un registro completo en `profesores`**:
```sql
INSERT INTO profesores
VALUES (22, 23444800, 'Gonzalez Sevilla, Miguel A.', 'HISTORIA');
```

## 4. Inserción de registros. Consultas de datos anexados

En ocasiones, interesa introducir en una tabla un conjunto de datos provenientes de otra fuente. Para ello, se puede realizar una consulta de datos anexados. El formato es el siguiente:

### Formato:
```sql
INSERT INTO nombre_tabla [(colum1 [,(…)]]
SELECT ...
```

Se insertarán en la tabla tantos datos como filas devuelva la consulta.

### Ejemplo:
```sql
INSERT INTO emp_bcn
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                  FROM dept
                  WHERE loc = 'BARCELONA');
```

## 4. Inserción de registros. Consultas de datos anexados (combinación de datos)

También es posible insertar un registro individual combinando información que ya conocemos con otra que hay que extraer de la base de datos. 

### Ejemplo:
Insertar un empleado con código 1111 y nombre GARCIA en el departamento en el que trabaja PEPE con el mismo sueldo de éste. La fecha de ingreso será la del sistema:

```sql
INSERT INTO emp (empno, ename, hiredate, sal, deptno)
SELECT 1111, 'GARCIA', sysdate, sal, deptno
FROM emp
WHERE ename = 'PEPE';
```

## Actividades:

1. **Dadas las tablas, ALUM y NUEVOS, inserta en ALUM los nuevos alumnos**:
```sql
INSERT INTO ALUM
SELECT * FROM NUEVOS;
```

2. **Inserta en EMP el empleado 2000, SAAVEDRA, fecha de alta la de sistema, el salario el 20% más que MILLER y el resto de los datos los de este**:
```sql
INSERT INTO EMP (empno, ename, hiredate, sal, deptno, job, mgr)
SELECT 2000, 'SAAVEDRA', sysdate, sal * 1.2, deptno, job, mgr
FROM EMP
WHERE ename = 'MILLER';
```

## 5. Modificación de datos

Para modificar el valor de los datos existentes en la tabla se emplea la orden `UPDATE`. La sintaxis es la siguiente:

### Formato:
```sql
UPDATE nombre_tabla
SET column1 = valor1, ..column = valorn
WHERE condicion;
```

Si se omite la cláusula `WHERE`, se actualizarán todas las filas.

### Ejemplo:
```sql
UPDATE emp
SET sal = sal + 100, comm = NVL(comm, 0) + 10
WHERE empno = 7369;
```

## 5. Modificación de datos. Consultas de actualización

En una orden `UPDATE` podemos usar una consulta para obtener el valor que se va a poner en una columna. En este caso, la consulta debe devolver una fila y el mismo número de columnas y tipo de datos que las que hay entre paréntesis en el `SET`:

### Ejemplo:
```sql
UPDATE emp
SET sal = (SELECT max(sal) FROM emp)
WHERE empno = 7082;
```

O bien, podemos usar una consulta para determinar qué filas se van a actualizar:

### Ejemplo:
```sql
UPDATE emp
SET sal = 1000
WHERE deptno = (SELECT deptno FROM dept WHERE loc = 'LORA');
```

## 5. Modificación de datos. Consultas de actualización combinadas

También pueden combinarse ambos formatos, como en el siguiente ejemplo:

### Ejemplo:
Haz que los empleados del departamento 'ACCOUNTING' tengan el nombre en minúsculas y ganen el doble que 'JAMES':

```sql
UPDATE emp
SET ename = LOWER(ename),
    sal = (SELECT sal * 2
           FROM emp
           WHERE ename = 'JAMES')
WHERE deptno = (SELECT deptno
                FROM dept
                WHERE dname = 'ACCOUNTING');
```


## 6. Borrado de datos. Consultas de eliminación

Si deseamos eliminar uno o varios registros de una tabla, debemos emplear la orden `DELETE`. Su sintaxis es la siguiente:

### Formato:
```sql
DELETE [FROM] nombre_tabla
[WHERE condicion];
```

Se borran los registros que cumplan la condición, en la que puede incluirse una sentencia `SELECT` si es necesario. A esto se le llama consulta de eliminación.

Si se omite la cláusula `WHERE`, se borrarán todos los registros de la tabla.

### Ejemplo:
```sql
DELETE EMP
WHERE DEPTNO = 20;
```

## 7. Cláusulas avanzadas de selección

### 7.1. GROUP BY y HAVING

Cuando necesitamos obtener alguna información acerca de varios conjuntos de registros de la tabla, debemos usar la cláusula `GROUP BY`, que permite hallar subtotales. Por ejemplo, cuando necesitemos saber el salario medio por departamento será necesario realizar un agrupamiento por este campo:

### Ejemplo:
```sql
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;
```

#### Funcionamiento de `GROUP BY` y `HAVING`:
- **GROUP BY**: Se emplea para calcular propiedades de 1 o más conjuntos de filas, las filas resultantes de la agrupación se almacenan en una tabla temporal.
- **HAVING**: Condición de selección de los grupos de filas. Solo se muestran aquellos conjuntos de filas que cumplen con la condición especificada en la cláusula `HAVING`. Se evalúa sobre la tabla temporal, no puede existir sin realizar previamente un `GROUP BY`.

### Ejemplos de uso de `GROUP BY` y `HAVING`:

1. Muestra el número de empleados de cada departamento:
   ```sql
   SELECT deptno, COUNT(*)
   FROM emp
   GROUP BY deptno;
   ```

2. Muestra los departamentos con más de cuatro empleados:
   ```sql
   SELECT deptno, COUNT(*)
   FROM emp
   GROUP BY deptno
   HAVING COUNT(*) > 4;
   ```

3. Muestra los departamentos en los que el salario medio es mayor que el salario medio de la empresa:
   ```sql
   SELECT deptno, AVG(sal)
   FROM emp
   GROUP BY deptno
   HAVING AVG(sal) >= (SELECT AVG(sal) FROM emp);
   ```

#### Orden de evaluación de las Cláusulas de la orden `SELECT`:
1. `WHERE` (selecciona filas individuales)
2. `GROUP BY` (agrupa filas)
3. `HAVING` (selecciona grupos de filas)
4. `ORDER BY` (ordena los grupos de filas)

### Más ejemplos de `GROUP BY` y `HAVING`:

1. Muestra la suma de los salarios de cada departamento junto con el salario máximo y mínimo de los mismos:
   ```sql
   SELECT deptno,
          TO_CHAR(SUM(sal), '99G999D99') AS suma,
          TO_CHAR(MAX(sal), '99G999D99') AS Máximo,
          TO_CHAR(MIN(sal), '99G999D99') AS Mínimo
   FROM emp
   GROUP BY deptno;
   ```

2. Muestra en orden de mayor a menor cuantos empleados hay de cada oficio en cada departamento:
   ```sql
   SELECT deptno, job, COUNT(*)
   FROM emp
   GROUP BY deptno, job
   ORDER BY deptno;
   ```

3. Muestra los nombres de los departamentos que tienen más de cuatro analistas:
   ```sql
   SELECT dname, COUNT(empno)
   FROM emp e, dept d
   WHERE e.deptno = d.deptno AND job = 'ANALYST'
   GROUP BY dname
   HAVING COUNT(empno) > 4;
   ```

4. Muestra los nombres de los departamentos con mayor número de empleados:
   ```sql
   SELECT d.deptno, dname, COUNT(empno)
   FROM emp e, dept d
   WHERE e.deptno = d.deptno
   GROUP BY d.deptno, dname
   HAVING COUNT(empno) = (SELECT MAX(COUNT(*))
                          FROM emp
                          GROUP BY deptno);
   ```

### 7.2. Combinaciones externas

Permite combinar tablas y seleccionar filas de estas aunque no tengan correspondencia entre ellas. Se usan cuando deseo mostrar información de todos los registros de una de las tablas, tengan o no correspondencia en la otra tabla.

### Sintaxis:
```sql
SELECT tabla1.col1, ..tabla1.coln, tabla2.col1, …tabla2.coln
FROM tabla1, tabla2
WHERE tabla1.colum1 = tabla2.colum1(+);
```

### Ejemplo:
Prueba la siguiente sentencia:
```sql
SELECT d.deptno, d.dname, COUNT(empno)
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY d.deptno, d.dname;
```

¿Qué pasa con el departamento 40? Ahora, prueba la siguiente sentencia:
```sql
SELECT d.deptno, d.dname, COUNT(empno)
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY d.deptno, d.dname;
```
Con `OUTER JOIN`, se muestran todos los departamentos, aunque no tengan empleados, y el número de empleados estará a `NULL`.

### 7.3. Operadores de conjuntos

#### 7.3.1. Unión (`UNION`)

`UNION`: Une los resultados de 2 consultas, las filas duplicadas se reducen a una.

### Sintaxis:
```sql
SELECT colum1, colum2, ..column
FROM tabla1
WHERE condicion
UNION
SELECT colum1, colum2, ..column
FROM tabla2
WHERE condicion;
```

#### Ejemplo:
```sql
SELECT nombre FROM alum
UNION
SELECT nombre FROM nuevos;
```

`UNION ALL`: Igual pero las filas duplicadas no se reducen a una.

#### 7.3.2. Intersección (`INTERSECTION`)

Muestra las filas que son idénticas en ambas consultas.

### Sintaxis:
```sql
SELECT colum1, colum2, ..column
FROM tabla1
WHERE condicion
INTERSECT
SELECT colum1, colum2, ..column
FROM tabla2
WHERE condicion;
```

#### Ejemplo:
```sql
SELECT nombre FROM alum
INTERSECT
SELECT nombre FROM antiguos;
```

Es equivalente a:
```sql
SELECT nombre FROM alum
WHERE nombre IN
(SELECT nombre FROM antiguos);
```

#### 7.3.3. Diferencia (`MINUS`)

Muestra las filas que aparecen en la 1ª consulta y no en la 2ª.

### Sintaxis:
```sql
SELECT colum1, colum2, ..column
FROM tabla1
WHERE condicion
MINUS
SELECT colum1, colum2, ..column
FROM tabla2
WHERE condicion;
```

#### Ejemplo:
```sql
SELECT nombre, localidad FROM alum
MINUS
SELECT nombre, localidad FROM antiguos;
```

Es equivalente a:
```sql
SELECT nombre, localidad FROM alum
WHERE nombre NOT IN
(SELECT nombre FROM antiguos);
```

### Reglas:
- Las columnas de ambas tablas se asocian de izquierda a derecha.
- Las `SELECTs` tienen que tener el mismo número de columnas.
- Los nombres de las columnas de ambas `SELECTs` no tienen que coincidir.
- Los tipos de datos tienen que coincidir, aunque la longitud no tiene que ser la misma.

### 7.4. Subconsultas correlacionadas

En ocasiones, es necesario relacionar campos de la consulta principal con campos de la subconsulta.

#### Ejemplo:
Mostrar los datos de los empleados cuyos salarios sean iguales al máximo salario de su departamento.

La consulta debe quedar así:
```sql
SELECT *
FROM emp e
WHERE sal = (SELECT MAX(sal)
             FROM emp
             WHERE deptno = e.deptno);
```

Hacemos referencia desde la subconsulta a una columna o varias de la consulta más externa. A veces, el nombre de las columnas coincide, por lo tanto, usaremos alias para la tabla más externa.


# 8. Control de transacciones en SQL

## Transacción
Una transacción es una secuencia de una o más órdenes SQL que juntas forman una unidad de trabajo.

## ROLLBACK
La orden `ROLLBACK` aborta la transacción, volviendo las tablas a la situación del último `COMMIT`. 
Un **ROLLBACK automático** se produce cuando hay algún fallo del sistema y no hemos validado el trabajo hasta ese momento.

## COMMIT
El comando `COMMIT` se utiliza para validar las operaciones DML (Data Manipulation Language) que hemos realizado en la base de datos.

## AUTOCOMMIT
En SQL*Plus e iSQL*Plus, el parámetro **AUTOCOMMIT** sirve para validar automáticamente las transacciones en la base de datos siempre que esté activado (`ON`). Por defecto, está en `OFF`, por lo que las órdenes `INSERT`, `UPDATE` y `DELETE` no se ejecutan automáticamente hasta que no se haga un `COMMIT`.

### Comandos relacionados con AUTOCOMMIT:
- Para verificar si está activado:
  ```sql
  SHOW AUTOCOMMIT
  ```
- Para activarlo:
  ```sql
  SET AUTOCOMMIT ON
  ```

## Comandos que fuerzan un COMMIT implícito:
Hay ciertos comandos SQL que automáticamente realizan un `COMMIT` sin necesidad de llamarlo explícitamente:
- `QUIT`
- `EXIT`
- `CONNECT`
- `DISCONNECT`
- `CREATE TABLE`
- `DROP TABLE`
- `CREATE VIEW`
- `DROP VIEW`
- `GRANT`
- `ALTER`
- `REVOKE`
- `AUDIT`
- `NOAUDIT`
