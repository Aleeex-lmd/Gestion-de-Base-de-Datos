SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE informe_empleados IS
    CURSOR cur_departamentos IS 
        SELECT deptno, dname FROM dept ORDER BY deptno;

    CURSOR cur_empleados(p_deptno NUMBER) IS 
        SELECT ename, sal FROM emp WHERE deptno = p_deptno ORDER BY ename;

    v_total_salarios_empresa NUMBER := 0;
    v_total_salarios_depto NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    DBMS_OUTPUT.PUT_LINE('      INFORME DE EMPLEADOS   ');
    DBMS_OUTPUT.PUT_LINE('-----------------------------');

    -- Recorrer cada departamento
    FOR dept_rec IN cur_departamentos LOOP
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || dept_rec.dname);
        
        v_total_salarios_depto := 0;

        -- Recorrer empleados del departamento actual
        FOR emp_rec IN cur_empleados(dept_rec.deptno) LOOP
            DBMS_OUTPUT.PUT_LINE(emp_rec.ename || '....' || emp_rec.sal);
            v_total_salarios_depto := v_total_salarios_depto + emp_rec.sal;
        END LOOP;

        -- Mostrar total del departamento
        DBMS_OUTPUT.PUT_LINE('Total Salarios Dpto ' || dept_rec.dname || ': ' || v_total_salarios_depto);
        DBMS_OUTPUT.PUT_LINE('---------------------------------');

        -- Acumular en el total de la empresa
        v_total_salarios_empresa := v_total_salarios_empresa + v_total_salarios_depto;
    END LOOP;

    -- Mostrar total general de la empresa
    DBMS_OUTPUT.PUT_LINE('Total de Salarios en la Empresa: ' || v_total_salarios_empresa);
END informe_empleados;
/

-- Ejecutar el procedimiento
BEGIN
    informe_empleados;
END;
/
