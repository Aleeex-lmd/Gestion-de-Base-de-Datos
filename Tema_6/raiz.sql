CREATE OR REPLACE PROCEDURE raiz (
    p_numero IN NUMBER,
    p_exponente IN NUMBER,
    p_precision IN NUMBER DEFAULT 1e-6
) IS
    v_approx NUMBER := p_numero / 2;
    v_error NUMBER := 1;
    v_potencia NUMBER;
    v_derivada NUMBER;
BEGIN
    IF p_exponente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El exponente no puede ser cero');
        RETURN;
    END IF;

    WHILE v_error > p_precision LOOP
        v_potencia := 1;
        FOR i IN 1..p_exponente LOOP
            v_potencia := v_potencia * v_approx;
        END LOOP;

        v_derivada := p_exponente;
        FOR i IN 1..(p_exponente - 1) LOOP
            v_derivada := v_derivada * v_approx;
        END LOOP;

        v_error := ABS(v_potencia - p_numero);

        v_approx := v_approx - (v_potencia - p_numero) / v_derivada;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('El resultado es: ' || v_approx);
END raiz;
/

-- Para usar la función:
BEGIN
    raiz(2, 0.2);  
END;
/
