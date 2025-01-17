Aquí tienes las consultas solicitadas para la base de datos `Departamentos` que has creado:

### 1. Obtener el salario y nombre de los empleados sin hijos por orden decreciente de salario y por orden alfabético dentro de salario.
```sql
SELECT nombre, salario 
FROM Empleados
WHERE num_hijos = 0
ORDER BY salario DESC, nombre ASC;
```

### 2. Para los empleados del departamento 112, hallar el nombre y el salario total de cada uno (salario más comisión), por orden de salario total decreciente y por orden alfabético dentro de salario total.
```sql
SELECT nombre, (salario + comision) AS salario_total
FROM Empleados
WHERE num_dpto = 112
ORDER BY salario_total DESC, nombre ASC;
```

### 3. Hallar cuántos departamentos hay y el presupuesto anual medio de ellos, para los departamentos que tienen director provisional.
```sql
SELECT COUNT(*) AS num_departamentos, AVG(presupuesto) AS presupuesto_medio
FROM Departamentos
WHERE nombre LIKE '%provisional%';
```
Nota: Esto asume que la palabra "provisional" está presente en el nombre del departamento. Si hay una columna específica para identificar a los departamentos con director provisional, debes ajustar la consulta.

### 4. Para cada extensión telefónica y para cada departamento, hallar cuántos empleados la usan y el salario medio de éstos.
```sql
SELECT telf_emp, num_dpto, COUNT(*) AS num_empleados, AVG(salario) AS salario_medio
FROM Empleados
GROUP BY telf_emp, num_dpto;
```

### 5. Hallar si hay algún departamento en la tabla `Departamentos` cuyo centro de trabajo no exista en la tabla `Centros`.
```sql
SELECT num_dpto
FROM Departamentos
WHERE num_centro NOT IN (SELECT num_centro FROM Centros);
```

### 6. Para todos los departamentos que no sean de Dirección ni de Sectores, hallar el número de departamento y sus extensiones telefónicas, por orden creciente de departamento y, dentro de éste, por número de extensión creciente.
```sql
SELECT num_dpto, telf_emp
FROM Empleados
WHERE num_dpto NOT IN (SELECT num_dpto FROM Departamentos WHERE nombre IN ('Dirección', 'Sectores'))
ORDER BY num_dpto ASC, telf_emp ASC;
```

### 7. Hallar por orden alfabético los nombres de los empleados cuyo director es Marcos Pérez, bien como director fijo o bien como provisional, indicando cuál es el caso para cada uno de ellos.
```sql
SELECT e.nombre, 
       CASE 
           WHEN e.tipo = 'fijo' THEN 'Director Fijo'
           WHEN e.tipo = 'eventual' THEN 'Director Provisional'
       END AS tipo_director
FROM Empleados e
JOIN Departamentos d ON e.num_dpto = d.num_dpto
WHERE d.nombre = 'Marcos Pérez'
ORDER BY e.nombre ASC;
```
Asegúrate de que `Marcos Pérez` esté correctamente referenciado en la base de datos, como en el nombre del director de departamento.

### 8. Para cada centro, obtener la suma de los salarios de los empleados que trabajan en él.
```sql
SELECT c.num_centro, SUM(e.salario) AS suma_salarios
FROM Centros c
JOIN Departamentos d ON c.num_centro = d.num_centro
JOIN Empleados e ON d.num_dpto = e.num_dpto
GROUP BY c.num_centro;
```

### 9. Obtener el conjunto de los empleados con su número, departamento al que pertenecen y director de departamento, que tengan un salario inferior a 3.000 euros.
```sql
SELECT e.num_emp, e.nombre AS empleado, d.nombre AS departamento, 
       (SELECT nombre FROM Empleados WHERE num_emp = d.num_centro) AS director
FROM Empleados e
JOIN Departamentos d ON e.num_dpto = d.num_dpto
WHERE e.salario < 3000;
```
