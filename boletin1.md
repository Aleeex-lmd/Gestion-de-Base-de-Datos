Aquí tienes las consultas SQL para cada uno de los sistemas de base de datos (Oracle, MariaDB y PostgreSQL). Se asumirá una estructura estándar de tablas como `EMP` (empleados) y `DEPT` (departamentos).

### Estructura básica de tablas
- **EMP**: `EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`
- **DEPT**: `DEPTNO`, `DNAME`, `LOC`

#### 1. Muestra los empleados que ganan más que SMITH
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE SAL > (SELECT SAL FROM EMP WHERE ENAME = 'SMITH');
```

#### 2. Muestra los nombres de los empleados junto con el nombre del departamento en el que trabajan
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT E.ENAME, D.DNAME
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO;
```

#### 3. Muestra los empleados del departamento 10 que entraron en la empresa antes del año 1998
```sql
-- Oracle
SELECT *
FROM EMP
WHERE DEPTNO = 10 AND HIREDATE < TO_DATE('01-JAN-1998', 'DD-MON-YYYY');

-- MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE DEPTNO = 10 AND HIREDATE < '1998-01-01';
```

#### 4. Muestra los empleados cuyo oficio es CLERK y ganan menos de 2000
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE JOB = 'CLERK' AND SAL < 2000;
```

#### 5. Muestra los empleados sin comisión del departamento 10
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE DEPTNO = 10 AND COMM IS NULL;
```

#### 6. Muestra los empleados del mismo departamento que ALLEN
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'ALLEN');
```

#### 7. Muestra los empleados cuyo nombre empiece por A
```sql
-- Oracle
SELECT *
FROM EMP
WHERE ENAME LIKE 'A%';

-- MariaDB, PostgreSQL
SELECT *
FROM EMP
WHERE ENAME LIKE 'A%';
```

#### 8. Muestra los empleados que trabajan en un departamento ubicado en DALLAS
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT E.*
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.LOC = 'DALLAS';
```

#### 9. Muestra nombre y salario de los empleados del departamento 'ACCOUNTING'
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT E.ENAME, E.SAL
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME = 'ACCOUNTING';
```

#### 10. Muestra nombre y comisión de los empleados cuyo oficio es 'SALESMAN'
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME, COMM
FROM EMP
WHERE JOB = 'SALESMAN';
```

#### 11. Muestra nombre y fecha de alta de todos los empleados que no son 'CLERK' ni 'SALESMAN'
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME, HIREDATE
FROM EMP
WHERE JOB NOT IN ('CLERK', 'SALESMAN');
```

#### 12. Muestra el nombre, el salario y la comisión de los empleados que trabajan en el mismo departamento que 'JONES'
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT ENAME, SAL, COMM
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'JONES');
```

#### 13. Muestra los nombres de los departamentos en los que trabaja alguien que gane menos que 'ALLEN'
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT DISTINCT D.DNAME
FROM DEPT D
JOIN EMP E ON D.DEPTNO = E.DEPTNO
WHERE E.SAL < (SELECT SAL FROM EMP WHERE ENAME = 'ALLEN');
```

#### 14. Muestra código y nombre de los empleados que están en un departamento de 'DALLAS' y ganan más que 'SMITH' pero menos que 'ALLEN'
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT E.EMPNO, E.ENAME
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.LOC = 'DALLAS'
  AND E.SAL > (SELECT SAL FROM EMP WHERE ENAME = 'SMITH')
  AND E.SAL < (SELECT SAL FROM EMP WHERE ENAME = 'ALLEN');
```

#### 15. Muestra el nombre del jefe (campo MGR) de los empleados del departamento 10
```sql
-- Oracle, MariaDB, PostgreSQL
SELECT DISTINCT M.ENAME AS MANAGER_NAME
FROM EMP E
JOIN EMP M ON E.MGR = M.EMPNO
WHERE E.DEPTNO = 10;
```
