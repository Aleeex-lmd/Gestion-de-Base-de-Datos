Aquí tienes las consultas SQL para responder a cada punto basado en el esquema **Scott** de Oracle (tablas `EMP` y `DEPT`):

---

### 1. Listar el nombre de los empleados que no tienen comisión
```sql
SELECT ENAME 
FROM EMP 
WHERE COMM IS NULL;
```

---

### 2. Mostrar el código, nombre y gasto de personal de los departamentos
```sql
SELECT D.DEPTNO, D.DNAME, SUM(E.SAL + NVL(E.COMM, 0)) AS GASTO_PERSONAL
FROM DEPT D
LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO, D.DNAME
ORDER BY GASTO_PERSONAL DESC;
```

---

### 3. Listar salario mínimo, máximo y medio por departamento
```sql
SELECT DEPTNO, 
       MIN(SAL) AS SALARIO_MINIMO, 
       MAX(SAL) AS SALARIO_MAXIMO, 
       AVG(SAL) AS SALARIO_MEDIO
FROM EMP
GROUP BY DEPTNO;
```

---

### 4. Listar el salario medio de los empleados
```sql
SELECT AVG(SAL) AS SALARIO_MEDIO
FROM EMP;
```

---

### 5. Listar departamentos con salarios ≥ 25% del gasto de personal
```sql
SELECT D.DNAME
FROM DEPT D
JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DNAME, D.DEPTNO
HAVING MAX(E.SAL) >= 0.25 * SUM(E.SAL + NVL(E.COMM, 0));
```

---

### 6. Listar departamentos con empleados que ganan > 15,000 euros al año
```sql
SELECT DISTINCT D.DNAME
FROM DEPT D
JOIN EMP E ON D.DEPTNO = E.DEPTNO
WHERE E.SAL * 12 > 15000;
```

---

### 7. Crear tabla TEMP y cargar datos de empleados de Dallas
```sql
CREATE TABLE TEMP (
    CODEMP NUMBER, 
    NOMDEPT VARCHAR2(30), 
    NOMEMP VARCHAR2(30), 
    SALEMP NUMBER
);

INSERT INTO TEMP (CODEMP, NOMDEPT, NOMEMP, SALEMP)
SELECT E.EMPNO, D.DNAME, E.ENAME, E.SAL
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME = 'DALLAS';
```

---

### 8. Incrementar un 10% los salarios < 10,000 euros al año
```sql
UPDATE EMP
SET SAL = SAL * 1.10
WHERE SAL * 12 < 10000;
```

---

### 9. Deshacer la operación anterior
```sql
ROLLBACK;
```

---

### 10. Departamentos con más de 2 empleados en el mismo oficio
```sql
SELECT D.DNAME, E.JOB, COUNT(*)
FROM DEPT D
JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DNAME, E.JOB
HAVING COUNT(*) > 2;
```

---

### 11. Departamento con menos empleados
```sql
SELECT D.DNAME, COUNT(E.EMPNO) AS NUM_EMPLEADOS
FROM DEPT D
LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DNAME
ORDER BY NUM_EMPLEADOS ASC
FETCH FIRST 1 ROWS ONLY;
```

---

### 12. Crear EMP_A_JUBILAR con empleados > 10 años
```sql
CREATE TABLE EMP_A_JUBILAR AS
SELECT *
FROM EMP
WHERE SYSDATE - HIREDATE > 3650;
```

---

### 13. Registros en EMP y no en EMP_A_JUBILAR
```sql
SELECT * 
FROM EMP
MINUS
SELECT * 
FROM EMP_A_JUBILAR;
```

---

### 14. Registros en EMP o EMP_A_JUBILAR (pero no en ambos)
```sql
SELECT * 
FROM EMP
UNION
SELECT * 
FROM EMP_A_JUBILAR;
```

---

### 15. Departamentos con número de empleados (incluyendo sin empleados)
```sql
SELECT D.DNAME, NVL(COUNT(E.EMPNO), 0) AS NUM_EMPLEADOS
FROM DEPT D
LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DNAME;
```
