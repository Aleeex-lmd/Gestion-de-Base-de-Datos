-- 1
ALTER TABLE empresas
ADD Horasdecolaboracion NUMBER(5);

UPDATE empresas e
SET Horasdecolaboracion = (
    SELECT NVL(SUM(p.num_horas), 0)
    FROM practicas p
    WHERE p.cif = e.cif
);

ALTER TABLE empresas
MODIFY Horasdecolaboracion NUMBER(5) NOT NULL;

SELECT nombre, Horasdecolaboracion
FROM empresas
ORDER BY Horasdecolaboracion DESC;


-- 2
CREATE VIEW HorasPracticasAlumnos AS
SELECT 
    a.nombre AS alumno,
    NVL(SUM(p.num_horas), 0) AS horas_practicas
FROM 
    alumnos a
LEFT JOIN 
    practicas p ON a.dni = p.dni
GROUP BY 
    a.nombre;

SELECT * FROM HorasPracticasAlumnos;

-- 4

SELECT 
    e.cif,
    e.nombre,
    SUM(p.num_horas) AS total_horas
FROM 
    empresas e
JOIN 
    practicas p ON e.cif = p.cif
WHERE 
    EXTRACT(MONTH FROM p.fecha_inicio) = 4
GROUP BY 
    e.cif, e.nombre
HAVING 
    SUM(p.num_horas) > 400;


ALTER TABLE practicas DISABLE CONSTRAINT fk_dni;

DELETE FROM alumnos
WHERE dni NOT IN (
    SELECT DISTINCT dni 
    FROM practicas
    WHERE fecha_inicio >= ADD_MONTHS(SYSDATE, -6)
);

ALTER TABLE practicas ENABLE CONSTRAINT fk_dni;

-- 5
INSERT INTO practicas (dni, cif, fecha_inicio, num_horas)
SELECT 
    a.dni, 
    e.cif, 
    TO_DATE('20/04/08', 'DD/MM/YY'), 
    510
FROM 
    alumnos a
JOIN 
    empresas e ON e.responsable_legal = 'Carmela'
WHERE 
    a.nombre = 'Mariano';

SELECT 
    p.dni,
    p.cif,
    p.fecha_inicio,
    p.num_horas
FROM 
    practicas p
JOIN 
    alumnos a ON p.dni = a.dni
JOIN 
    empresas e ON p.cif = e.cif
WHERE 
    a.nombre = 'Mariano'
    AND e.responsable_legal = 'Carmela';


-- 6
SELECT 
    dni,
    nombre
FROM 
    (SELECT 
        a.dni,
        a.nombre,
        SUM(p.num_horas) AS total_horas
     FROM 
        alumnos a
     JOIN 
        practicas p ON a.dni = p.dni
     JOIN 
        empresas e ON p.cif = e.cif
     WHERE 
        a.direccion = 'Triana'
        AND e.sector = 'Informatica'
     GROUP BY 
        a.dni, a.nombre
     ORDER BY 
        total_horas DESC) 
WHERE ROWNUM = 1;

