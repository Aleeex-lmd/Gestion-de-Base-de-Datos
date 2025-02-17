-- Hacer un procedimiento que muestre el nombre y el salario del empleado cuyo código es 7082

CREATE PROCEDURE ObtenerEmpleado()
BEGIN
    SELECT nombre, salario 
    FROM empleados 
    WHERE codigo = 7082;
END 

-- Hacer un procedimiento que reciba como parámetro un código de empleado y devuelva su nombre

CREATE PROCEDURE ObtenerEmpleadoporCodigo(IN codigoempleado INT)
BEGIN
    SELECT nombre
    FROM empleado
    WHERE codigo = codigoempleado;
END

--  Crear un procedimiento PL/SQL que cuente el número de filas que hay en la tabla EMP (de Scottt), deposita el resultado en una variable y visualiza su contenido

CREATE PROCEDURE ContarEmpleados AS
    v_total_empleados NUMBER; 
BEGIN
    SELECT COUNT(*) INTO v_total_empleados FROM EMP;
    
    DBMS_OUTPUT.PUT_LINE('Total de empleados: ' || v_total_empleados);
END ContarEmpleados;
/

-- Escribir un procedimiento que reciba una fecha y escriba el año, en número, correspondiente a esa fecha

CREATE PROCEDURE ObtenerAnio(p_fecha DATE) AS
    v_anio NUMBER;
BEGIN
    v_anio := EXTRACT(YEAR FROM p_fecha);

    DBMS_OUTPUT.PUT_LINE('El año es: ' || v_anio);
END ObtenerAnio;
/

-- Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su suma
CREATE PROCEDURE sum5(
    num1 IN NUMBER, 
    num2 IN NUMBER, 
    num3 IN NUMBER, 
    num4 IN NUMBER, 
    num5 IN NUMBER
) AS
    resultado NUMBER; 
BEGIN
    resultado := num1 + num2 + num3 + num4 + num5;

    DBMS_OUTPUT.PUT_LINE('La suma da: ' || resultado);
END sum5;
/

BEGIN
    sum5(1,2,3,4,5);
END;
/

--  Implementar un procedimiento que reciba un importe y visualice el desglose del cambio en unidades monetarias de 0.01, 0.02, 0.05, 0.10, 0.20, 0.50, 1, 2, 5, 10, 20, 50, 100, 200, 500 y 1000 € en orden inverso al que aparecen aquí enumeradas

CREATE PROCEDURE Cambiomoneda(p_importe NUMBER) AS
    TYPE t_monedas IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_monedas t_monedas;
    v_cantidad NUMBER;
    v_importe NUMBER := p_importe;
BEGIN
    -- Definir las unidades monetarias en orden inverso
    v_monedas(1) := 1000; 
    v_monedas(2) := 500; 
    v_monedas(3) := 200; 
    v_monedas(4) := 100; 
    v_monedas(5) := 50; 
    v_monedas(6) := 20; 
    v_monedas(7) := 10; 
    v_monedas(8) := 5; 
    v_monedas(9) := 2; 
    v_monedas(10) := 1; 
    v_monedas(11) := 0.50; 
    v_monedas(12) := 0.20; 
    v_monedas(13) := 0.10; 
    v_monedas(14) := 0.05; 
    v_monedas(15) := 0.02; 
    v_monedas(16) := 0.01; 

    DBMS_OUTPUT.PUT_LINE('Desglose del importe: ' || p_importe || '€');

    FOR i IN 1..16 LOOP
        v_cantidad := TRUNC(v_importe / v_monedas(i));  -- Cantidad de billetes/monedas
        IF v_cantidad > 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_cantidad || ' x ' || v_monedas(i) || '€');
            v_importe := v_importe - (v_cantidad * v_monedas(i)); -- Reducir el importe
        END IF;
    END LOOP;
END Cambiomoneda;
/

BEGIN
    Cambiomoneda(1220);
END;
/

-- Codificar un procedimiento que permita borrar un empleado cuyo número se pasará en la llamada.
CREATE BorraEmpleado(e_numempleado NUMBER) AS
BEGIN
    DELETE FROM empleados
    WHERE numemp = e_numempleado;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Empleado con número ' || e_numempleado || ' eliminado.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el empleado con número ' || e_numempleado);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el empleado: ' || SQLERRM);
END BorraEmpleado;
/

-- . Visualizar todos los procedimientos y funciones de usuarios almacenados en la base de datos y su situación (valid o invalid).
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS 
FROM USER_OBJECTS 
WHERE OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION');

--  Realizar un procedimiento que reciba un número y muestre su tabla de multiplicar
CREATE OR REPLACE PROCEDURE tablamultiplicar(numero NUMBER, maximo NUMBER) AS
    resultado NUMBER;
BEGIN
    FOR v_contador IN 0 .. maximo LOOP
        resultado := v_contador * numero;
        DBMS_OUTPUT.PUT_LINE(numero || ' x ' || v_contador || ' = ' || resultado);
    END LOOP;
END tablamultiplicar;
/

BEGIN
    tablamultiplicar(10,10);
END;
/

--  realiza un procedimiento que reciba dos números 'nota' y 'edad' y un carácter 'sexo' y muestre el mensaje 'ACEPTADA' si la nota es mayor o igual a cinco, la edad es mayor o igual a dieciocho y el sexo es 'M'. En caso de que se cumpla lo mismo, pero el sexo sea 'V', debe imprimir 'POSIBLE'
CREATE OR REPLACE PROCEDURE aceptarm(nota NUMBER, edad NUMBER) AS
BEGIN
    IF nota > 5 AND edad >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('ACEPTADO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO CUMPLE LOS REQUISITOS');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE aceptarv(nota NUMBER, edad NUMBER) AS
BEGIN
    IF nota > 5 AND edad >= 18 THEN
        DBMS_OUTPUT.PUT_LINE('POSIBLE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO CUMPLE LOS REQUISITOS');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE aceptar(nota NUMBER, edad NUMBER, sexo VARCHAR) AS
BEGIN
    CASE 
        WHEN sexo = 'M' THEN
            aceptarm(nota, edad);
        WHEN sexo = 'V' THEN
            aceptarv(nota, edad);
        WHEN sexo NOT IN ('V', 'M') THEN
            DBMS_OUTPUT.PUT_LINE('Caracter invalido');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Sexo no especificado');
    END CASE;
END;
/

CREATE OR REPLACE PROCEDURE aceptar(nota NUMBER, edad NUMBER, sexo CHAR) AS
BEGIN
    IF sexo = 'M' THEN
        IF nota > 5 AND edad >= 18 THEN
            DBMS_OUTPUT.PUT_LINE('ACEPTADO');
        ELSE
            DBMS_OUTPUT.PUT_LINE('NO CUMPLE LOS REQUISITOS');
        END IF;
    ELSIF sexo = 'V' THEN
        IF nota > 5 AND edad >= 18 THEN
            DBMS_OUTPUT.PUT_LINE('POSIBLE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('NO CUMPLE LOS REQUISITOS');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Caracter invalido');
    END IF;
END;
/


BEGIN 
    aceptar(10, 19, 'M');
END;
/

-- Procedimiento que recibe una letra e imprima si es vocal o consonante
CREATE OR REPLACE PROCEDURE vocaloconsonante(letra CHAR) AS
BEGIN
    IF REGEXP_LIKE(letra, '^[A-Za-z]$') THEN
        IF letra IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') THEN
            DBMS_OUTPUT.PUT_LINE('VOCAL');
        ELSE
            DBMS_OUTPUT.PUT_LINE('CONSONANTE');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Caracter inválido. Solo se permiten letras.');
    END IF;
END;
/


BEGIN
    vocaloconsonante('A');
END;
/

--  Procedimiento que reciba un número y escribe la cantidad de números pares que hay entre el 1 y el número indicado.
CREATE OR REPLACE PROCEDURE pares(maximo NUMBER) AS
BEGIN
    FOR i IN 2 .. maximo LOOP
        IF MOD(i, 2) = 0 THEN  -- Verificar si i es par
            DBMS_OUTPUT.PUT_LINE(i);
        END IF;
    END LOOP;
END;
/

BEGIN
    pares(10);
END;
/

-- Diseñar un procedimiento que muestre la suma de los números impares comprendidos entre dos valores numéricos enteros y positivos recibidos por parámetros
CREATE OR REPLACE PROCEDURE suma_impares(minimo NUMBER, maximo NUMBER) AS
    total NUMBER := 0;  -- Variable para almacenar la suma total
BEGIN
    -- Verificar si los parámetros son válidos
    IF minimo < 1 OR maximo < 1 THEN
        DBMS_OUTPUT.PUT_LINE('Los valores deben ser enteros positivos.');
        RETURN;
    END IF;

    -- Iterar entre los valores mínimo y máximo
    FOR i IN minimo .. maximo LOOP
        IF MOD(i, 2) = 1 THEN  -- Verificar si el número es impar
            total := total + i;  -- Sumar el número impar
        END IF;
    END LOOP;

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('La suma de los números impares entre ' || minimo || ' y ' || maximo || ' es: ' || total);
END;
/

BEGIN
    suma_impares(1, 20);
END;
/    

-- Diseñar un procedimiento que recibe por parámetros dos valores numéricos que representan la 
-- base y el exponente de una potencia donde el exponente es un número entero positivo o negativo. El 
-- procedimiento visualiza el valor de la potencia, teniendo en cuenta las siguientes consideraciones:
-- 1) Si la base y el exponente son cero, se mostrará un mensaje de error que diga "Datos erróneos".
-- 2) Si el exponente es cero la potencia es 1.
-- 3) Si el exponente es negativo la fórmula matemática de la potencia es pot = 1/base^exp. En este caso, 
-- si la base es cero escribir un mensaje de "Datos erróneos".
-- Nota: No utilizar ninguna función que calcule la potencia

CREATE OR REPLACE PROCEDURE calcular_potencia(
    p_base IN NUMBER, 
    p_exponente IN NUMBER
) IS
    v_resultado NUMBER := 1;
BEGIN
    -- Caso en el que base y exponente son 0
    IF p_base = 0 AND p_exponente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Datos erróneos');
    
    -- Caso en el que el exponente es 0
    ELSIF p_exponente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Resultado: 1');
    
    -- Caso en el que el exponente es positivo
    ELSIF p_exponente > 0 THEN
        FOR i IN 1..p_exponente LOOP
            v_resultado := v_resultado * p_base;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_resultado);
    
    -- Caso en el que el exponente es negativo
    ELSE
        IF p_base = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Datos erróneos');
        ELSE
            FOR i IN 1..ABS(p_exponente) LOOP
                v_resultado := v_resultado * p_base;
            END LOOP;
            v_resultado := 1 / v_resultado;
            DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_resultado);
        END IF;
    END IF;
END calcular_potencia;

-- Cree una tabla Tabla_Numeros con un atributo valor de tipo INTEGER. Cree un procedimientoque inserte números del 1 al 50. Compruebe los datos insertados en la tabla
-- Crear la tabla
CREATE TABLE Tabla_Numeros (
    valor INTEGER
);

-- Crear el procedimiento para insertar números del 1 al 50
CREATE OR REPLACE PROCEDURE insertar_numeros IS
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO Tabla_Numeros (valor) VALUES (i);
    END LOOP;
    COMMIT;
END insertar_numeros;

-- Llamar al procedimiento para insertar los datos
BEGIN
    insertar_numeros;
END;
/

-- Verificar los datos insertados
SELECT * FROM Tabla_Numeros;


-- Borre el contenido de la tabla Tabla_Numeros utilizando la sentencia DELETE. Cree un procedimiento que inserte del 10 al 1, excepto el 4 y el 5. Compruebe, de nuevo, los datos que contiene la tabla Tabla_Numeros.
-- Borrar el contenido de la tabla
DELETE FROM Tabla_Numeros;
COMMIT;

-- Crear el procedimiento para insertar números del 10 al 1, excepto el 4 y el 5
CREATE OR REPLACE PROCEDURE insertar_numeros_descendente IS
BEGIN
    FOR i IN REVERSE 1..10 LOOP
        IF i NOT IN (4, 5) THEN
            INSERT INTO Tabla_Numeros (valor) VALUES (i);
        END IF;
    END LOOP;
    COMMIT;
END insertar_numeros_descendente;

-- Llamar al procedimiento para insertar los nuevos datos
BEGIN
    insertar_numeros_descendente;
END;
/

-- Verificar los datos insertados
SELECT * FROM Tabla_Numeros;

-- Cree una tabla Tabla_Articulos con los siguientes atributos: código, nombre, precio e IVA. Introduzca datos de prueba utilizando la sentencia INSERT.
-- Construya un procedimiento que compruebe si el precio del artículo cuyo código es ‘A001’ es mayor que 10 euros y en caso afirmativo, imprima el nombre y el precio del artículo por pantalla.
CREATE OR REPLACE PROCEDURE comprobar_precio IS
    v_nombre Tabla_Articulos.nombre%TYPE;
    v_precio Tabla_Articulos.precio%TYPE;
BEGIN
    SELECT nombre, precio INTO v_nombre, v_precio
    FROM Tabla_Articulos
    WHERE codigo = 'A001';
    
    IF v_precio > 10 THEN
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre || ', Precio: ' || v_precio);
    END IF;
END comprobar_precio;
/

-- Ejecutar el procedimiento
BEGIN
    comprobar_precio;
END;
/

-- Construya un procedimiento que seleccione el artículo de mayor precio que esté almacenado en la tabla, almacene su valor en una variable y luego imprímalo.
CREATE OR REPLACE PROCEDURE mayor_precio IS
    v_max_precio NUMBER;
BEGIN 
    SELECT MAX(precio) INTO v_max_precio FROM Tabla_Articulos;

    DBMS_OUTPUT.PUT_LINE('El precio máximo es: ' || v_max_precio);
END mayor_precio;
/

-- Ejecutar el procedimiento
BEGIN
    mayor_precio;
END;
/

-- Construya un procedimiento que actualice el precio del artículo cuyo código es ‘A005’ según las
-- siguientes indicaciones:
-- − Si el artículo tiene un precio menor de 1 euro, su precio debe ser aumentado en 25 céntimos.
-- − Si está comprendido entre 1 euro y 10 euros su precio aumentará un 10 % .Si excede los 10 euros su precio aumentará en un 20 %.
-- − Si el precio es NULL, el aumento es 0.

CREATE OR REPLACE PROCEDURE actualizacion IS
    v_precio Tabla_Articulos.precio%TYPE;
BEGIN
    -- Obtener el precio actual del artículo 'A005'
    SELECT precio INTO v_precio
    FROM Tabla_Articulos
    WHERE codigo = 'A005';

    -- Aplicar las reglas de actualización
    IF v_precio IS NULL THEN
        v_precio := 0;  -- Si es NULL, el aumento es 0
    ELSIF v_precio < 1 THEN
        v_precio := v_precio + 0.25;
    ELSIF v_precio <= 10 THEN
        v_precio := v_precio * 1.10;  -- Aumenta 10%
    ELSE
        v_precio := v_precio * 1.20;  -- Aumenta 20%
    END IF;

    -- Actualizar la tabla con el nuevo precio
    UPDATE Tabla_Articulos
    SET precio = v_precio
    WHERE codigo = 'A005';

    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE actualizacion2(codigoactualizar Tabla_Articulos.codigo%TYPE) IS
    v_precio Tabla_Articulos.precio%TYPE;
BEGIN
    -- Verificar si el artículo existe
    BEGIN
        SELECT precio INTO v_precio
        FROM Tabla_Articulos
        WHERE codigo = codigoactualizar;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No existe un artículo con el código ' || codigoactualizar);
            RETURN;
    END;

    -- Aplicar las reglas de actualización
    IF v_precio IS NULL THEN
        v_precio := 0;  -- Si es NULL, el aumento es 0
    ELSIF v_precio < 1 THEN
        v_precio := v_precio + 0.25;
    ELSIF v_precio <= 10 THEN
        v_precio := v_precio * 1.10;  
    ELSE
        v_precio := v_precio * 1.20;
    END IF;

    -- Actualizar la tabla con el nuevo precio
    UPDATE Tabla_Articulos
    SET precio = v_precio
    WHERE codigo = codigoactualizar;

    COMMIT;

    -- Mensaje de confirmación
    DBMS_OUTPUT.PUT_LINE('El artículo con código ' || codigoactualizar || ' ha sido actualizado con éxito.');
END;
/

-- Crear un procedimiento que en la tabla emp incrementar el salario el 10% a los empleados que tengan una comisión superior al 5% del salario.
CREATE OR REPLACE PROCEDURE actualizar_salario IS
BEGIN
    -- Actualizar el salario de los empleados que cumplen la condición
    UPDATE emp
    SET salario = salario * 1.10
    WHERE comision > salario * 0.05;

    COMMIT;

    -- Mensaje de confirmación
    DBMS_OUTPUT.PUT_LINE('Se han actualizado los salarios de los empleados con comisión superior al 5% de su salario.');
END;
/

-- Crear un procedimiento que inserte un empleado en la tabla EMP. Su número será superior a los existentes y la fecha de incorporación a la empresa será la actual.
CREATE OR REPLACE PROCEDURE insertar_empleado(
    p_nombre    EMP.nombre%TYPE,
    p_puesto    EMP.puesto%TYPE,
    p_departamento EMP.departamento%TYPE,
    p_salario   EMP.salario%TYPE,
    p_comision  EMP.comision%TYPE
) IS
    v_nuevo_emp_no EMP.emp_no%TYPE;
BEGIN
    -- Obtener el número de empleado más alto y sumarle 1
    SELECT NVL(MAX(emp_no), 0) + 1 INTO v_nuevo_emp_no FROM EMP;

    -- Insertar el nuevo empleado
    INSERT INTO EMP (emp_no, nombre, puesto, departamento, salario, comision, fecha_ingreso)
    VALUES (v_nuevo_emp_no,
