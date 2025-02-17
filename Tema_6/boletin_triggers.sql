-- 1. Trigger que solo permite a los vendedores tener comisiones
CREATE OR REPLACE TRIGGER trg_check_commission
BEFORE INSERT OR UPDATE ON EMP
FOR EACH ROW
BEGIN
    IF :NEW.COMM IS NOT NULL AND :NEW.JOB <> 'SALESMAN' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Solo los vendedores pueden tener comisiones.');
    END IF;
END;
/

-- 2. Auditoría de operaciones en la tabla EMP
CREATE TABLE AUDIT_EMP (
    usuario VARCHAR2(100),
    fecha TIMESTAMP,
    operacion VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trg_audit_emp
AFTER INSERT OR UPDATE OR DELETE ON EMP
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_EMP (usuario, fecha, operacion)
    VALUES (USER, SYSTIMESTAMP, CASE WHEN INSERTING THEN 'INSERT' WHEN UPDATING THEN 'UPDATE' WHEN DELETING THEN 'DELETE' END);
END;
/

-- 3. Control de sueldos según el cargo
CREATE OR REPLACE TRIGGER trg_salary_limits
BEFORE INSERT OR UPDATE ON EMP
FOR EACH ROW
BEGIN
    IF :NEW.JOB IN ('CLERK', 'ANALYST', 'MANAGER') THEN
        IF (:NEW.JOB = 'CLERK' AND (:NEW.SAL < 800 OR :NEW.SAL > 1100)) OR
           (:NEW.JOB = 'ANALYST' AND (:NEW.SAL < 1200 OR :NEW.SAL > 1600)) OR
           (:NEW.JOB = 'MANAGER' AND (:NEW.SAL < 1800 OR :NEW.SAL > 2000)) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Salario fuera de rango para el cargo.');
        END IF;
    END IF;
END;
/

-- 4. Impedir a MANOLO cambiar sueldo de empleados en DALLAS
CREATE OR REPLACE TRIGGER trg_no_mano_salaries
BEFORE UPDATE ON EMP
FOR EACH ROW
DECLARE
    v_location VARCHAR2(50);
BEGIN
    SELECT LOC INTO v_location FROM DEPT WHERE DEPTNO = :OLD.DEPTNO;
    IF USER = 'MANOLO' AND v_location = 'DALLAS' THEN
        RAISE_APPLICATION_ERROR(-20003, 'MANOLO no puede cambiar sueldos en DALLAS.');
    END IF;
END;
/

-- 5. Incremento de sueldo al cambiar localidad
CREATE OR REPLACE TRIGGER trg_increase_salary
AFTER UPDATE ON EMP
FOR EACH ROW
DECLARE
    v_old_loc VARCHAR2(50);
    v_new_loc VARCHAR2(50);
BEGIN
    SELECT LOC INTO v_old_loc FROM DEPT WHERE DEPTNO = :OLD.DEPTNO;
    SELECT LOC INTO v_new_loc FROM DEPT WHERE DEPTNO = :NEW.DEPTNO;
    IF v_old_loc <> v_new_loc THEN
        UPDATE EMP SET SAL = SAL * 1.1 WHERE EMPNO = :NEW.EMPNO;
    END IF;
END;
/

-- 6. Impedir que un departamento quede sin empleados
CREATE OR REPLACE TRIGGER trg_no_empty_department
BEFORE DELETE ON EMP
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM EMP WHERE DEPTNO = :OLD.DEPTNO;
    IF v_count = 1 THEN
        RAISE_APPLICATION_ERROR(-20004, 'No se puede eliminar el último empleado del departamento.');
    END IF;
END;
/

-- 7. Validación del campo Apenom en Alumnos
CREATE OR REPLACE TRIGGER trg_validate_apenom
BEFORE INSERT OR UPDATE ON ALUMNOS
FOR EACH ROW
BEGIN
    IF REGEXP_LIKE(:NEW.APENOM, '[[:digit:][:punct:]]') THEN
        RAISE_APPLICATION_ERROR(-20005, 'El campo Apenom no puede contener números o signos de puntuación.');
    END IF;
END;
/

-- 8. Restricción de notas en cursos distintos
CREATE OR REPLACE TRIGGER trg_one_course_per_student
BEFORE INSERT OR UPDATE ON NOTAS
FOR EACH ROW
DECLARE 
    v_count NUMBER;
BEGIN
    SELECT COUNT(DISTINCT CURSO) INTO v_count FROM NOTAS WHERE ALUMNO_ID = :NEW.ALUMNO_ID;
    IF v_count > 1 THEN
        RAISE_APPLICATION_ERROR(-20006, 'El alumno no puede tener notas en cursos distintos.');
    END IF;
END;
/

-- 9. Actualización de nota media en Alumnos
CREATE OR REPLACE TRIGGER trg_update_average
AFTER INSERT OR UPDATE OR DELETE ON NOTAS
FOR EACH ROW
BEGIN
    UPDATE ALUMNOS SET NOTA_MEDIA = (SELECT AVG(NOTA) FROM NOTAS WHERE ALUMNO_ID = :NEW.ALUMNO_ID)
    WHERE ALUMNO_ID = :NEW.ALUMNO_ID;
END;
/
