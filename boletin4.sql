--Boletín Práctico Sentencias Sencillas de SQL

-- alumnos (nombre, apellido1, apellido2, dni, dirección, sexo, fechaNac)

-- cursos (nombreCurso, codigoCurso, profesor, maxAlumnos, fechaIni, fechaFin, numhoras)

-- profesores (nombre, apellido1, apellido2, dni, direccion, titulo, sueldo)

-- manuales (referencia, titulo, autor, fechaPub, precio)

-- oposiciones (nombre, código, fecExam, organismo, plazas, categoria)

-- matriculas (dniAlumno, codCurso, pruebaA, pruebaB, tipo, inscripcion)

-- curso_oposicion (codCurso, codOposicion)

-- curso_manual (codCurso, referencia)

--     a.nombre || ' ' || a.apellido1 || ' ' || a.apellido2 AS "Nombre Completo"


-- Obtener el nombre de los cursos de más de 300 horas y que admiten a más de 100 alumnos.
-- ORACLE y MARIADB
SELECT nombreCurso 
FROM cursos 
WHERE numhoras > 300 AND maxAlumnos > 100; 

-- Obtener el nombre, código, fecha de inicio, fecha final y horas de todos los cursos que se imparten en la academia, ordenados alfabéticamente por nombre.
-- ORACLE y MARIADB
SELECT 
    nombreCurso,
    codigoCurso, 
    fechaIni, 
    fechaFin, 
    numhoras 
FROM cursos
ORDER BY nombreCurso ASC;

-- Mostrar toda la información de los cursos que comienzan en el mes de Mayo, incluyendo Nombre, Código, DNI del profesor, número máximo de alumnos, fecha de inicio, fecha final y número de horas.
-- ORACLE y MARIADB
SELECT*
FROM cursos
WHERE TO_CHAR(fechaIni, 'MM') = '05';

-- Mostrar el nombre de la oposición y la categoría de las oposiciones de categoría A, B o C.
-- ORACLE y MARIADB
SELECT
    nombre AS "Nombre Oposicion", 
    categoria As "Categoria"
FROM oposiciones
WHERE categoria='A' OR categoria='B' OR categoria='C';

-- Mostrar los nombres completos de los profesores con el título que poseen.
-- ORACLE y MARIADB
SELECT
    nombre, apellido1, apellido2,
    titulo AS Titulo
FROM profesores;

-- Obtener un listado con el nombre completo de los alumnos con matricula oficial, el nombre del curso en el que están matriculados y la fecha de inscripción a dicho curso.
-- ORACLE y MARIDB
SELECT
    a.nombre, a.apellido1, a.apellido2,
    c.nombreCurso AS "Curso",
    m.inscripcion AS "Fecha de Inscripción"
FROM alumnos a
JOIN matriculas m ON a.dni = m.dniAlumno
JOIN cursos c ON m.codCurso = c.codigoCurso;


-- Relación de los cursos que sirven para preparar la oposición llamada 'Maestros de Primaria' junto con el nombre del profesor que lo imparte.
-- ORACLE y MARIADB
SELECT
    c.nombrecurso AS "Nombre del Curso",
    p.nombre AS "Nombre del profesor"
FROM cursos c
JOIN curso_oposicion co ON c.codigoCurso = co.codCurso
JOIN profesores p ON c.profesor = p.dni
JOIN oposiciones o ON co.codOposicion = o.codigo
WHERE o.nombre = 'Maestros de Primaria';


-- Listado de las oposiciones a las que se puede acceder, recibiendo los cursos que imparte el profesor 'Manuel López García'.
-- ORACLE y MARIADB
SELECT
    o.nombre AS "Oposiciones accesibles"
FROM oposiciones o 
JOIN curso_oposicion co ON o.codigo = co.codOposicion
JOIN cursos c ON co.codCurso = c.codigoCurso
JOIN profesores p ON c.profesor = p.dni
WHERE p.nombre = 'Manuel' and p.apellido1 = 'Lopez' and p.apellido2 = 'Garcia';

-- Titulo y precio de los manuales recomendados para el curso 'Función Pública'.
-- ORACLE y MARIADB
SELECT
    m.titulo AS "Titulo manual",
    m.precio AS "Precio"
FROM manuales m
JOIN curso_manual cm ON m.referencia = cm.referencia
JOIN cursos c ON cm.codCurso = c.codigoCurso
WHERE c.nombreCurso = 'Función Publica';

-- Obtener un listado con los alumnos más jóvenes que 'Luisa Sánchez Donoso'.
-- ORACLE y MARIADB
SELECT
    a.nombre, a.apellido1, a.apellido2
FROM alumnos a
WHERE a.fechaNac > ( SELECT fechaNac
                        FROM alumnos
                        WHERE nombre = 'Luisa' AND apellido1 = 'Sanchez' AND apellido2 = 'Donoso');

-- Obtener el nombre de los cursos en los que hay más alumnos matriculados que en el curso más numeroso del profesor 'Manuel López García'.
-- ORACLE y MARIADB 

ERROR

SELECT
    c.nombreCurso
FROM cursos c
JOIN matriculas m ON c.codigoCurso = m.codCurso
JOIN profesores p ON c.profesor = p.dni
GROUP BY c.nombreCurso, c.profesor
HAVING COUNT(m.dniAlumno) > (
        SELECT MAX(num_alumnos)
        FROM (
            SELECT 
                COUNT(m2.dniAlumno) AS num_alumnos
            FROM matriculas m2
            JOIN cursos c2 ON m2.codCurso = c2.codigoCurso
            JOIN profesores p2 ON c2.profesor = p2.dni
            WHERE p2.nombre = 'Manuel' AND p2.apellido1 = 'Lopez' AND p2.apellido2 = 'Garcia'
        )
    );

-- Obtener el nombre completo de los profesores que impartan cursos con un número de horas mayor que alguno de los cursos impartidos por el profesor 'Manuel López García'.
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2
FROM profesores p 
JOIN cursos c ON p.dni = c.profesor
WHERE c.numhoras > (SELECT 
                    MAX(c.numhoras)
                    FROM cursos c
                    JOIN profesores p ON c.profesor = p.dni
                    WHERE p.nombre = 'Manuel' AND p.apellido1 = 'Lopez' AND p.apellido2 = 'Garcia'
);

-- Obtener los nombres de los cursos impartidos por el profesor 'Luis Pérez Sánchez' que sirvan para la oposición 'Funcionario de Prisiones'.
-- ORACLE y MARIADB
SELECT
    c.nombreCurso
FROM cursos c
JOIN profesores p ON c.profesor = p.dni
JOIN curso_oposicion co ON c.codigoCurso = co.codCurso
JOIN oposiciones o ON co.codOposicion = o.codigo
WHERE p.nombre = 'Luis' AND p.apellido1 = 'Perez' AND p.apellido2 = 'Sanchez' AND o.nombre = 'Funcionario de Prisiones';

-- Obtener el nombre y los apellidos de los alumnos que no se han matriculado por libre en ningún curso.
-- ORACLE y MARIADB
SELECT
    a.nombre, a.apellido1, a.apellido2 AS 
FROM alumnos a
WHERE NOT EXISTS (
    SELECT 1
    FROM matriculas m
    WHERE m.dniAlumno = a.dni AND m.tipo = 'libre'
);

-- Obtener nombre, apellidos, sueldo y título de aquellos profesores que tienen un sueldo mayor que el de alguno de sus compañeros de titulación.
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2, p.sueldo, p.titulo AS "Titulo"
FROM profesores p
JOIN profesores p2 ON p.titulo = p2.titulo
WHERE p.sueldo > p2.sueldo;

--Obtener nombre y apellido de los profesores que imparten algún curso de más de 100 horas pero no imparten ningún curso de menos de 50 alumnos.
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2 AS "Nombre Completo"
FROM profesores p 
JOIN cursos c ON p.dni = c.profesor
WHERE c.numhoras > 100 AND c.maxAlumnos >= 50;

-- Mostrar el nombre de las oposiciones que son de la misma categoría pero distinto organismo que la oposición con código 'C-512'.
-- ORACLE y MARIADB
SELECT
    o.nombre
FROM oposiciones o
WHERE o.categoria = (
        SELECT o2.categoria
        FROM oposiciones o2
        WHERE o2.codigo = 'C-512'
    )
    AND o.organismo != (
        SELECT o2.organismo
        FROM oposiciones o2
        WHERE o2.codigo = 'C-512'
    ) AND o.codigo != 'C-512';

-- Obtener el nombre y apellidos de los alumnos que solo se han presentado a una de las pruebas en algún curso.
-- ORACLE y MARIADB
SELECT 
    a.nombre, a.apellido1, a.apellido2
FROM alumnos a 
JOIN matriculas m ON a.dni = m.dniAlumno
WHERE m.pruebaA IS NULL AND m.pruebaB IS NOT NULL OR m.pruebaA IS NOT NULL AND m.pruebaB IS NULL;

-- Nombre de todos los cursos junto con el código de las oposiciones para las que están destinados.
-- ORACLE y MARIADB
SELECT
    c.nombreCurso AS "Nombre del curso", 
    co.codOposicion AS "Codigo de la oposicion"
FROM cursos c
JOIN curso_oposicion co ON c.codigoCurso = co.codCurso;

-- Obtener un listado con el nombre completo de los alumnos matriculados en el curso 'Función Pública' junto con sus notas en ambas pruebas siempre que su media entre las dos supere los 25 puntos.
SELECT  
    a.nombre || ' ' || a.apellido1 || ' ' || a.apellido2 AS "Nombre Completo"
FROM alumnos a
JOIN matriculas m ON a.dni = m.dniAlumno 
JOIN cursos c ON m.codCurso = c.codigoCurso
WHERE c.nombreCurso = 'Función Publica' AND (m.pruebaA + m.pruebaB) / 2 > 25;

-- Mostrar el nombre y los apellidos de los alumnos que tengan más de 31 años
-- ORACLE y MARIADB
SELECT 
    a.nombre, a.apellido1, a.apellido2
FROM alumnos a
WHERE TO_CHAR(a.fechaNac, 'YYYY') < '1994';

-- Mostrar para cada curso su nombre y el número máximo de alumnos si admitiésemos un 25% más de los permitidos.
-- ORACLE y MARIADB
SELECT
    c.nombreCurso, 
    c.maxAlumnos * 1.25 AS "Máximo alumnos"
FROM 
    cursos c;

-- Obtener el nombre y los apellidos de todos los alumnos cuyo primer apellido empiece por la letra 'P'.
-- ORACLE y MARIADB
SELECT
    a.nombre, a.apellido1, a.apellido2 
FROM alumnos a
WHERE a.apellido1 LIKE 'P%';

-- Obtener el nombre y los apellidos junto a la fecha de nacimiento de todos los alumnos nacidos en el mes de abril.
-- ORACLE y MARIADB
SELECT 
    a.nombre, a.apellido1, a.apellido2, 
    a.fechaNac AS "Fecha de nacimiento"
FROM alumnos a
WHERE TO_CHAR(a.fechaNac, 'MM') = '04';

-- Mostrar una relación de los cursos que comienzan en el mes de septiembre, junto con el nombre y apellidos del profesor que lo imparte y la fecha de inicio del mismo.
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2,
    c.nombreCurso AS "Curso",
    c.fechaIni AS "Fecha inicio"
FROM cursos c 
JOIN profesores p ON c.profesor = p.dni
WHERE TO_CHAR(c.fechaIni, 'MM') = '09';

-- Nombre completo de los alumnos y puntuación media (entre las dos pruebas) de aquellos que hayan sacado más de 20 puntos de media en el curso 'La Constitución'.
-- ORACLE y MARIADB
SELECT 
    a.nombre, a.apellido1, a.apellido2,
    (m.pruebaA + m.pruebaB) / 2 AS "Nota media"
FROM alumnos a
JOIN matriculas m ON a.dni = m.dniAlumno 
JOIN cursos c ON m.codCurso = c.codigoCurso
WHERE c.nombreCurso = 'La Constitucion' AND (m.pruebaA + m.pruebaB) / 2 > 20;

-- Nombre completo de todas las personas (alumnos y profesores) que hay en la academia, ordenados alfabéticamente por apellidos.
-- ORACLE y MARIADB
SELECT 
    a.nombre AS "Nombre", a.apellido1 AS "Apellido 1", a.apellido2 AS "Apellido 2"
FROM alumnos a
ORDER BY "Apellido 1" ASC
UNION
SELECT
    p.nombre AS "Nombre", p.apellido1 "Apellido 1", p.apellido2 AS "Apellido 2"
FROM profesores p 
ORDER BY "Apellido 1" ASC;

--- 

-- Obtener el nombre y los apellidos de todos los profesores, junto con el nombre de los cursos que imparten (o en blanco si no imparten ningún curso)
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2, COALESCE(c.nombreCurso, 'NULL') AS nombreCurso
FROM profesores p
LEFT JOIN cursos c ON p.dni = c.profesor;

-- Número de alumnos matriculados en el curso 'La Constitución'
-- ORACLE y MARIADB
SELECT
    COUNT(m.dniAlumno) AS "Numero alumnos"
FROM matriculas M
JOIN cursos c ON m.codCurso = c.codigoCurso
WHERE c.nombreCurso = 'La Constitucion';

-- Número de alumnos nacidos en 1970
-- ORACLE y MARIADB
SELECT
    COUNT(a.dni) AS "Numero alumnos"
FROM alumnos A
WHERE TO_CHAR(a.fechaNac, 'YYYY') = 1970;

-- Nombre del curso con más horas
-- ORACLE y MARIADB
SELECT
    c.nombreCurso
FROM cursos c
WHERE c.numhoras = (SELECT MAX(numhoras) FROM cursos);

-- Obtener el nombre completo de los alumnos junto con el curso y la nota obtenida en la prueba 1 de aquellos que han obtenido la nota más alta en dicha prueba en cada curso
-- ORACLE y MARIADB
SELECT
    a.nombre || ' ' || a.apellido1 || ' ' || a.apellido2 AS "Nombre Completo", 
    c.nombreCurso, 
    m.pruebaA
FROM alumnos a
JOIN matriculas m ON a.dni = m.dniAlumno
JOIN cursos c ON m.codCurso = c.codigoCurso
WHERE m.pruebaA = (
    SELECT MAX(pruebaA) 
    FROM matriculas 
    WHERE codCurso = m.codCurso);

-- Número total de alumnos matriculados en los cursos que imparte 'Luis Pérez Sánchez', así como la nota máxima y la mínima calificada por este profesor en la prueba 1 de cualquier curso.

-- ORACLE y MARIADB
SELECT
    COUNT(m.dniAlumno) AS "Total Alumnos", 
    MAX(GREATEST(m.pruebaA, m.pruebaB)) AS "Nota Máxima", 
    MIN(LEAST(m.pruebaA, m.pruebaB)) AS "Nota Mínima"
FROM matriculas m
JOIN cursos c ON m.codCurso = c.codigoCurso
JOIN profesores p ON c.profesor = p.dni
WHERE p.nombre = 'Luis' AND p.apellido1 = 'Perez' AND p.apellido2 = 'Sanchez';

-- Obtener un listado con el nombre de los profesores junto con el número total de alumnos que tienen matriculados en sus cursos
-- ORACLE y MARIADB
SELECTp.nombre, p.apellido1, p.apellido2, COUNT(m.dniAlumno) AS "Num total alumnos"
FROM profesores p
JOIN cursos c ON p.dni = c.profesor
JOIN matriculas m ON c.codigoCurso = m.codCurso
GROUP BY p.nombre, p.apellido1, p.apellido2;

-- Obtener la nota mínima, máxima y media en las pruebas 1 y 2 obtenidas en todos los cursos agrupadas por sexos.
-- ORACLE y MARIADB
SELECT
    MAX(m.pruebaA) AS "Nota Máxima Prueba A", 
    MIN(m.pruebaA) AS "Nota Mínima Prueba A",
    AVG(m.pruebaA) AS "Nota Media Prueba A",
    MAX(m.pruebaB) AS "Nota Máxima Prueba B", 
    MIN(m.pruebaB) AS "Nota Mínima Prueba B",
    AVG(m.pruebaB) AS "Nota Media Prueba B",
    a.sexo
FROM matriculas m
JOIN alumnos a ON m.dniAlumno = a.dni
GROUP BY a.sexo;

-- Nombre, apellidos y número de cursos de los profesores que imparten mayor número de cursos.
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2, COUNT(c.codigoCurso) AS "Número de Cursos"
FROM profesores p
JOIN cursos c ON p.dni = c.profesor
GROUP BY p.nombre, p.apellido1, p.apellido2
HAVING 
    COUNT(c.codigoCurso) = (SELECT 
            MAX(curso_count)
        FROM (SELECT 
                COUNT(codigoCurso) AS curso_count
            FROM cursos
            GROUP BY profesor
        )
    );

-- Nombre de las oposiciones que necesitan tres o más cursos
-- ORACLE y MARIADB
SELECT
    o.nombre
FROM oposiciones o
JOIN curso_oposicion co ON o.codigo = co.codOposicion
JOIN cursos c ON co.codCurso = c.codigoCurso
GROUP BY o.nombre
HAVING COUNT(c.codigoCurso) > 3;

-- Obtener el nombre y apellidos de los profesores que imparten cursos que suman más horas que todos los cursos de 'Luis Pérez Sánchez'.
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2
FROM profesores p
JOIN cursos c ON p.dni = c.profesor
GROUP BY p.nombre, p.apellido1, p.apellido2
HAVING SUM(c.numhoras) > (
        SELECT SUM(c2.numhoras)
        FROM cursos c2
        JOIN profesores p2 ON c2.profesor = p2.dni
        WHERE p2.nombre = 'Luis' AND p2.apellido1 = 'Perez' AND p2.apellido2 = 'Sanchez');

-- Obtener el nombre y los apellidos de los profesores que dan menos horas
-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2
FROM profesores p
JOIN cursos c ON p.dni = c.profesor
GROUP BY p.nombre, p.apellido1, p.apellido2
HAVING MIN(SUM(c.numhoras) );

-- ORACLE y MARIADB
SELECT
    p.nombre, p.apellido1, p.apellido2
FROM profesores p
JOIN cursos c ON p.dni = c.profesor
GROUP BY p.nombre, p.apellido1, p.apellido2
HAVING 
    SUM(c.numhoras) = (
        SELECT MIN(totalHoras)
        FROM (
            SELECT SUM(c2.numhoras) AS totalHoras
            FROM cursos c2
            GROUP BY c2.profesor
        ) 
    );
