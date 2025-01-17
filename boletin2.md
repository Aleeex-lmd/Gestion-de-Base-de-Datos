### Consultas SQL para Oracle, MariaDB y PostgreSQL

---

#### 1. **Muestra el número de empleados que ganan más de 1400 por orden descendiente de salario.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT COUNT(*) AS NUM_EMPLEADOS
FROM EMP
WHERE SAL > 1400
ORDER BY SAL DESC;
```

---

#### 2. **Muestra el salario medio de los conserjes (`JOB='CLERK'`).**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT AVG(SAL) AS SALARIO_MEDIO
FROM EMP
WHERE JOB = 'CLERK';
```

---

#### 3. **Muestra el empleado que gana más junto con su salario con el formato:**  
**'El nombre del empleado que más gana es xxxx, y gana nnnnn'.**
```sql
-- Oracle
SELECT 'El nombre del empleado que más gana es ' || ENAME || ', y gana ' || SAL AS MENSAJE
FROM EMP
WHERE SAL = (SELECT MAX(SAL) FROM EMP);

-- MariaDB, PostgreSQL
SELECT CONCAT('El nombre del empleado que más gana es ', ENAME, ', y gana ', SAL) AS MENSAJE
FROM EMP
WHERE SAL = (SELECT MAX(SAL) FROM EMP);
```

---

#### 4. **Muestra los nombres de los conserjes ordenados por salario.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME
FROM EMP
WHERE JOB = 'CLERK'
ORDER BY SAL;
```

---

#### 5. **Muestra el gasto de personal total de la empresa, sumando salarios y comisiones.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT SUM(SAL + COALESCE(COMM, 0)) AS GASTO_TOTAL
FROM EMP;
```

---

#### 6. **Muestra un informe con los nombres de los empleados y su salario con el siguiente formato:**  
**nombre1........ salario1**  
**nombren.........salarion**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT LPAD(ENAME, 20, '.') || LPAD(SAL, 10, ' ') AS INFORME
FROM EMP;
```

---

#### 7. **Muestra el número de trienios completos de cada empleado.**
```sql
-- Oracle
SELECT ENAME, FLOOR((SYSDATE - HIREDATE) / 1095) AS TRIENIOS_COMPLETOS
FROM EMP;

-- MariaDB, PostgreSQL
SELECT ENAME, FLOOR((DATEDIFF(CURDATE(), HIREDATE) / 1095)) AS TRIENIOS_COMPLETOS
FROM EMP;
```

---

#### 8. **Muestra el total de dinero ganado por el empleado desde que se incorporó a la empresa suponiendo que el salario no ha cambiado en todo ese tiempo.**
```sql
-- Oracle
SELECT ENAME, ROUND((SYSDATE - HIREDATE) * SAL / 30, 2) AS TOTAL_GANADO
FROM EMP;

-- MariaDB, PostgreSQL
SELECT ENAME, ROUND((DATEDIFF(CURDATE(), HIREDATE) * SAL / 30), 2) AS TOTAL_GANADO
FROM EMP;
```

---

#### 9. **Muestra con dos decimales el salario diario de cada trabajador suponiendo que los meses tienen 30 días.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME, ROUND(SAL / 30, 2) AS SALARIO_DIARIO
FROM EMP;
```

---

#### 10. **Muestra los empleados que tengan en su nombre al menos dos vocales.**
```sql
-- Oracle
SELECT ENAME
FROM EMP
WHERE LENGTH(REGEXP_REPLACE(ENAME, '[^AEIOUaeiou]', '')) >= 2;

-- MariaDB, PostgreSQL
SELECT ENAME
FROM EMP
WHERE LENGTH(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ENAME, 'A', ''), 'E', ''), 'I', ''), 'O', ''), 'U', '')) <= LENGTH(ENAME) - 2;
```

---

#### 11. **Muestra los empleados cuyo nombre empieza por una vocal.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME
FROM EMP
WHERE ENAME LIKE 'A%' OR ENAME LIKE 'E%' OR ENAME LIKE 'I%' OR ENAME LIKE 'O%' OR ENAME LIKE 'U%';
```

---

#### 12. **Muestra los departamentos que tienen algún empleado cuyo nombre tiene más de cinco letras.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT DISTINCT D.DNAME
FROM DEPT D
JOIN EMP E ON D.DEPTNO = E.DEPTNO
WHERE LENGTH(E.ENAME) > 5;
```

---

#### 13. **Muestra en minúsculas los nombres de los departamentos que tienen algún empleado.**
```sql
-- Oracle
SELECT LOWER(DNAME) AS NOMBRE_DEPARTAMENTO
FROM DEPT
WHERE DEPTNO IN (SELECT DISTINCT DEPTNO FROM EMP);

-- MariaDB, PostgreSQL
SELECT LOWER(DNAME) AS NOMBRE_DEPARTAMENTO
FROM DEPT
WHERE DEPTNO IN (SELECT DISTINCT DEPTNO FROM EMP);
```

---

#### 14. **Muestra un mensaje de saludo a cada empleado con el formato:**  
**'Hola nombreempleado'.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT CONCAT('Hola ', ENAME) AS SALUDO
FROM EMP;
```

---

#### 15. **Muestra el nombre de cada empleado junto con el nombre del mes en el que entró en la empresa.**
```sql
-- Oracle
SELECT ENAME, TO_CHAR(HIREDATE, 'Month') AS MES
FROM EMP;

-- MariaDB, PostgreSQL
SELECT ENAME, DATE_FORMAT(HIREDATE, '%M') AS MES
FROM EMP;
```

---

#### 16. **Muestra la hora del sistema con el formato:**  
**'Hoy es nn del mes de nombremes del año n.nnn y son las hh y nn minutos.'**
```sql
-- Oracle
SELECT 'Hoy es ' || TO_CHAR(SYSDATE, 'DD "del mes de" Month "del año" YYYY "y son las" HH24 "y" MI "minutos."') AS FECHA
FROM DUAL;

-- MariaDB, PostgreSQL
SELECT CONCAT('Hoy es ', DATE_FORMAT(NOW(), '%d "del mes de" %M "del año" %Y "y son las" %H "y" %i "minutos."')) AS FECHA;
```

---

#### 17. **Muestra el nombre del primer empleado por orden alfabético.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME
FROM EMP
ORDER BY ENAME
LIMIT 1;
```

---

#### 18. **Muestra el número de jefes que hay en la empresa.**
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT COUNT(DISTINCT MGR) AS NUM_JEFES
FROM EMP;
```

---

#### 19. **Muestra los empleados que fueron dados de alta entre el 01/03/1988 y el 31/06/1989.**
```sql
-- Oracle
SELECT *
FROM EMP
WHERE HIREDATE BETWEEN TO_DATE('01-MAR-1988', 'DD-MON-YYYY') AND TO_DATE('30-JUN-1989', 'DD-MON-YYYY');

-- MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE HIREDATE BETWEEN '1988-03-01' AND '1989-06-30';
```

---

#### 20. **Muestra los empleados que llevan más de 6 años en la empresa.**
```sql
-- Oracle
SELECT *
FROM EMP
WHERE SYSDATE - HIREDATE > 365 * 6;

-- MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE DATEDIFF(CURDATE(), HIREDATE) > 365 * 6;
```