-- Ejercicio 1: Devolver código de departamento
CREATE OR REPLACE FUNCTION DevolverCodDept(p_nombre_dept VARCHAR2) RETURN NUMBER IS
    v_cod_dept DEPARTAMENTOS.COD_DEPT%TYPE;
BEGIN
    SELECT COD_DEPT INTO v_cod_dept FROM DEPARTAMENTOS WHERE NOMBRE_DEPT = p_nombre_dept;
    RETURN v_cod_dept;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Ejercicio 2: Hallar número de empleados
CREATE OR REPLACE PROCEDURE HallarNumEmp(p_nombre_dept VARCHAR2) IS
    v_cod_dept NUMBER;
    v_num_emp NUMBER;
BEGIN
    v_cod_dept := DevolverCodDept(p_nombre_dept);
    IF v_cod_dept IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('El departamento no existe.');
        RETURN;
    END IF;
    
    SELECT COUNT(*) INTO v_num_emp FROM EMPLEADOS WHERE COD_DEPT = v_cod_dept;
    
    IF v_num_emp = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El departamento no tiene empleados.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Número de empleados: ' || v_num_emp);
    END IF;
END;
/

-- Ejercicio 3: Calcular coste salarial
CREATE OR REPLACE FUNCTION CalcularCosteSalarial(p_nombre_dept VARCHAR2) RETURN NUMBER IS
    v_cod_dept NUMBER;
    v_coste NUMBER := 0;
BEGIN
    v_cod_dept := DevolverCodDept(p_nombre_dept);
    IF v_cod_dept IS NULL THEN
        RETURN NULL;
    END IF;
    
    SELECT NVL(SUM(SALARIO + NVL(COMISION, 0)), 0) INTO v_coste FROM EMPLEADOS WHERE COD_DEPT = v_cod_dept;
    RETURN v_coste;
END;
/

-- Ejercicio 4: Mostrar costes salariales
CREATE OR REPLACE PROCEDURE MostrarCostesSalariales IS
BEGIN
    FOR r IN (SELECT NOMBRE_DEPT FROM DEPARTAMENTOS) LOOP
        DBMS_OUTPUT.PUT_LINE(r.NOMBRE_DEPT || ': ' || CalcularCosteSalarial(r.NOMBRE_DEPT));
    END LOOP;
END;
/

-- Ejercicio 5: Mostrar abreviaturas
CREATE OR REPLACE PROCEDURE MostrarAbreviaturas IS
BEGIN
    FOR r IN (SELECT NOMBRE FROM EMPLEADOS) LOOP
        DBMS_OUTPUT.PUT_LINE(SUBSTR(r.NOMBRE, 1, 3));
    END LOOP;
END;
/

-- Ejercicio 6: Mostrar empleados más antiguos
CREATE OR REPLACE PROCEDURE MostrarMasAntiguos IS
BEGIN
    FOR r IN (SELECT d.NOMBRE_DEPT, e.NOMBRE FROM EMPLEADOS e
              JOIN DEPARTAMENTOS d ON e.COD_DEPT = d.COD_DEPT
              WHERE e.FECHA_INGRESO = (SELECT MIN(FECHA_INGRESO) FROM EMPLEADOS WHERE COD_DEPT = e.COD_DEPT)) LOOP
        DBMS_OUTPUT.PUT_LINE(r.NOMBRE_DEPT || ': ' || r.NOMBRE);
    END LOOP;
END;
/

-- Ejercicio 7: Mostrar jefes
CREATE OR REPLACE PROCEDURE MostrarJefes(p_nombre_dept VARCHAR2) IS
BEGIN
    FOR r IN (SELECT DISTINCT e.NOMBRE FROM EMPLEADOS e
              WHERE e.COD_DEPT = DevolverCodDept(p_nombre_dept) AND e.COD_EMP IN (SELECT DISTINCT JEFE FROM EMPLEADOS WHERE JEFE IS NOT NULL)) LOOP
        DBMS_OUTPUT.PUT_LINE(r.NOMBRE);
    END LOOP;
END;
/

-- Ejercicio 8: Mostrar mejores vendedores
CREATE OR REPLACE PROCEDURE MostrarMejoresVendedores IS
BEGIN
    FOR r IN (SELECT NOMBRE FROM EMPLEADOS WHERE COMISION IS NOT NULL ORDER BY COMISION DESC FETCH FIRST 2 ROWS ONLY) LOOP
        DBMS_OUTPUT.PUT_LINE(r.NOMBRE);
    END LOOP;
END;
/

-- Ejercicio 9: Mostrar empleados con nombre de departamento al revés
CREATE OR REPLACE PROCEDURE MostrarsodaelpmE(p_nombre_dept_reverso VARCHAR2) IS
    v_nombre_dept VARCHAR2(50);
BEGIN
    SELECT NOMBRE_DEPT INTO v_nombre_dept FROM DEPARTAMENTOS WHERE REVERSE(NOMBRE_DEPT) = p_nombre_dept_reverso;
    FOR r IN (SELECT NOMBRE FROM EMPLEADOS WHERE COD_DEPT = DevolverCodDept(v_nombre_dept)) LOOP
        DBMS_OUTPUT.PUT_LINE(r.NOMBRE);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El departamento no existe.');
END;
/

-- Ejercicio 10: Recortar sueldos
CREATE OR REPLACE PROCEDURE RecortarSueldos(p_letra CHAR) IS
BEGIN
    UPDATE EMPLEADOS SET SALARIO = SALARIO * 0.8 WHERE NOMBRE LIKE p_letra || '%';
    COMMIT;
END;
/

-- Ejercicio 11: Borrar becarios
CREATE OR REPLACE PROCEDURE BorrarBecarios IS
BEGIN
    FOR r IN (SELECT COD_DEPT FROM DEPARTAMENTOS) LOOP
        DELETE FROM EMPLEADOS WHERE COD_EMP IN (SELECT COD_EMP FROM EMPLEADOS WHERE COD_DEPT = r.COD_DEPT ORDER BY FECHA_INGRESO DESC FETCH FIRST 2 ROWS ONLY);
    END LOOP;
    COMMIT;
END;
/
