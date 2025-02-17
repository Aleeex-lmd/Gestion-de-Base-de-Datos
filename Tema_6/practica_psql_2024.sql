CREATE OR REPLACE FUNCTION horallegada(fechahorasalida DATE, duracionminutos NUMBER) RETURN DATE IS
    horas NUMBER;
    minutos NUMBER;
BEGIN
    -- Convertir minutos a horas y minutos restantes
    horas := TRUNC(duracionminutos / 60);
    minutos := MOD(duracionminutos, 60);

    -- Retornar la fecha y hora de llegada sumando horas y minutos
    RETURN fechahorasalida + INTERVAL '1' HOUR * horas + INTERVAL '1' MINUTE * minutos;
END horallegada;
/

CREATE OR REPLACE PROCEDURE obtener_ruta_info(
    p_codigo_ruta IN NUMBER,
    p_origen OUT VARCHAR2,
    p_destino OUT VARCHAR2,
    p_duracion OUT NUMBER
) IS
BEGIN
    SELECT origen, destino, duracion_minutos
    INTO p_origen, p_destino, p_duracion
    FROM rutas
    WHERE codigo_ruta = p_codigo_ruta;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ruta no encontrada.');
END obtener_ruta_info;
/

CREATE OR REPLACE PROCEDURE mostrar_panel_ciudad(p_ciudad IN VARCHAR2) IS
    CURSOR cur_salidas IS
        SELECT anden, destino, hora_salida, 
               horallegada(hora_salida, duracion_minutos) AS hora_estimada_llegada, 
               matricula_bus
        FROM viajes
        WHERE ciudad_salida = p_ciudad
        ORDER BY hora_salida DESC
        FETCH FIRST 4 ROWS ONLY;

    CURSOR cur_llegadas IS
        SELECT anden, origen, horallegada(hora_salida, duracion_minutos) AS hora_estimada_llegada, 
               matricula_bus
        FROM viajes
        WHERE ciudad_destino = p_ciudad
        ORDER BY hora_estimada_llegada DESC
        FETCH FIRST 4 ROWS ONLY;

    v_count_salidas NUMBER := 0;
    v_count_llegadas NUMBER := 0;
BEGIN
    -- Verificar si la ciudad existe en la base de datos
    DECLARE
        v_existe NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_existe FROM ciudades WHERE nombre_ciudad = p_ciudad;
        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'La ciudad no existe en la base de datos.');
        END IF;
    END;

    -- Mostrar salidas
    DBMS_OUTPUT.PUT_LINE('Salidas');
    FOR rec IN cur_salidas LOOP
        DBMS_OUTPUT.PUT_LINE(rec.anden || ' ' || rec.destino || ' ' || rec.hora_salida || ' ' ||
                             rec.hora_estimada_llegada || ' ' || rec.matricula_bus);
        v_count_salidas := v_count_salidas + 1;
    END LOOP;
    
    IF v_count_salidas = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay salidas registradas.');
    END IF;

    -- Mostrar llegadas
    DBMS_OUTPUT.PUT_LINE('Llegadas');
    FOR rec IN cur_llegadas LOOP
        DBMS_OUTPUT.PUT_LINE(rec.anden || ' ' || rec.origen || ' ' || rec.hora_estimada_llegada || ' ' ||
                             rec.matricula_bus);
        v_count_llegadas := v_count_llegadas + 1;
    END LOOP;

    IF v_count_llegadas = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay llegadas registradas.');
    END IF;
END mostrar_panel_ciudad;
/

-- Ejercicio 2

-- Función para calcular la hora estimada de llegada
CREATE OR REPLACE FUNCTION horallegada(fechahorasalida DATE, duracionminutos NUMBER) 
RETURN DATE IS
BEGIN
    RETURN fechahorasalida + INTERVAL '1' MINUTE * duracionminutos;
END horallegada;
/

-- Procedimiento para validar si una ciudad existe
CREATE OR REPLACE PROCEDURE validar_ciudad(p_ciudad IN VARCHAR2) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM ciudades WHERE nombre_ciudad = p_ciudad;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La ciudad ' || p_ciudad || ' no existe.');
    END IF;
END validar_ciudad;
/

-- Procedimiento para consultar viajes disponibles
CREATE OR REPLACE PROCEDURE consultar_viajes_disponibles(
    p_origen IN VARCHAR2,
    p_destino IN VARCHAR2,
    p_fecha IN DATE
) IS
    -- Cursor para obtener los viajes disponibles
    CURSOR cur_viajes IS
        SELECT v.hora_salida, 
               horallegada(v.hora_salida, r.duracion_minutos) AS hora_llegada, 
               v.precio, v.plazas_disponibles
        FROM viajes v
        JOIN rutas r ON v.codigo_ruta = r.codigo_ruta
        WHERE r.origen = p_origen 
          AND r.destino = p_destino 
          AND v.fecha = p_fecha
          AND v.plazas_disponibles > 0
        ORDER BY v.hora_salida;

    v_count NUMBER := 0;
BEGIN
    -- Validar que las ciudades existen
    validar_ciudad(p_origen);
    validar_ciudad(p_destino);

    -- Verificar si hay rutas en la fecha indicada
    SELECT COUNT(*) INTO v_count 
    FROM viajes v
    JOIN rutas r ON v.codigo_ruta = r.codigo_ruta
    WHERE r.origen = p_origen 
      AND r.destino = p_destino 
      AND v.fecha = p_fecha;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No hay rutas operadas entre ' || p_origen || ' y ' || p_destino || ' el día ' || TO_CHAR(p_fecha, 'DD/MM/YYYY'));
    END IF;

    -- Mostrar viajes disponibles
    DBMS_OUTPUT.PUT_LINE('Viajes disponibles de ' || p_origen || ' a ' || p_destino || ' el ' || TO_CHAR(p_fecha, 'DD/MM/YYYY') || ':');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Hora Salida | Hora Llegada | Precio | Plazas');
    
    FOR rec IN cur_viajes LOOP
        DBMS_OUTPUT.PUT_LINE(rec.hora_salida || ' | ' || rec.hora_llegada || ' | ' || rec.precio || '€ | ' || rec.plazas_disponibles);
        v_count := v_count + 1;
    END LOOP;

    -- Si no hay billetes disponibles
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No hay billetes disponibles para esta ruta en la fecha indicada.');
    END IF;
END consultar_viajes_disponibles;
/

-- Ejemplo de ejecución
BEGIN
    consultar_viajes_disponibles('Madrid', 'Barcelona', TO_DATE('2024-02-06', 'YYYY-MM-DD'));
END;
/
