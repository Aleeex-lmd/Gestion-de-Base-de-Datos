Parece que deseas resolver una serie de consultas relacionadas con una base de datos que contiene información sobre cursos, oposiciones, profesores y alumnos en una academia. Las consultas implican SQL, y aquí tienes las soluciones a cada una de ellas:

### **Consultas SQL**

1. **Cursos con más de 300 horas y que admiten más de 100 alumnos**:
   ```sql
   SELECT nombre 
   FROM cursos 
   WHERE horas > 300 AND max_alumnos > 100;
   ```

2. **Cursos con detalles ordenados alfabéticamente**:
   ```sql
   SELECT nombre, codigo, fecha_inicio, fecha_final, horas 
   FROM cursos 
   ORDER BY nombre ASC;
   ```

3. **Cursos que comienzan en Mayo**:
   ```sql
   SELECT nombre, codigo, dni_profesor, max_alumnos, fecha_inicio, fecha_final, horas 
   FROM cursos 
   WHERE MONTH(fecha_inicio) = 5;
   ```

4. **Oposiciones de categorías A, B o C**:
   ```sql
   SELECT nombre, categoria 
   FROM oposiciones 
   WHERE categoria IN ('A', 'B', 'C');
   ```

5. **Profesores y sus títulos**:
   ```sql
   SELECT CONCAT(nombre, ' ', apellidos) AS nombre_completo, titulo 
   FROM profesores;
   ```

6. **Alumnos con matrícula oficial y detalles del curso**:
   ```sql
   SELECT CONCAT(a.nombre, ' ', a.apellidos) AS alumno, c.nombre AS curso, m.fecha_inscripcion 
   FROM alumnos a 
   JOIN matriculas m ON a.dni = m.dni_alumno 
   JOIN cursos c ON m.codigo_curso = c.codigo 
   WHERE m.tipo_matricula = 'oficial';
   ```

7. **Cursos para 'Maestros de Primaria' con profesores**:
   ```sql
   SELECT c.nombre AS curso, CONCAT(p.nombre, ' ', p.apellidos) AS profesor 
   FROM cursos c 
   JOIN oposiciones o ON c.codigo_oposicion = o.codigo 
   JOIN profesores p ON c.dni_profesor = p.dni 
   WHERE o.nombre = 'Maestros de Primaria';
   ```

8. **Oposiciones accesibles con los cursos de 'Manuel López García'**:
   ```sql
   SELECT DISTINCT o.nombre 
   FROM oposiciones o 
   JOIN cursos c ON o.codigo = c.codigo_oposicion 
   JOIN profesores p ON c.dni_profesor = p.dni 
   WHERE CONCAT(p.nombre, ' ', p.apellidos) = 'Manuel López García';
   ```

9. **Manuales recomendados para 'Función Pública'**:
   ```sql
   SELECT titulo, precio 
   FROM manuales 
   WHERE codigo_curso = (SELECT codigo FROM cursos WHERE nombre = 'Función Pública');
   ```

10. **Alumnos más jóvenes que 'Luisa Sánchez Donoso'**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno 
    FROM alumnos 
    WHERE fecha_nacimiento > (SELECT fecha_nacimiento 
                              FROM alumnos 
                              WHERE CONCAT(nombre, ' ', apellidos) = 'Luisa Sánchez Donoso');
    ```

Aquí tienes todas las consultas SQL solicitadas para los 40 casos:

---

11. **Alumnos más jóvenes que 'Luisa Sánchez Donoso'**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno 
    FROM alumnos 
    WHERE fecha_nacimiento > (SELECT fecha_nacimiento 
                              FROM alumnos 
                              WHERE CONCAT(nombre, ' ', apellidos) = 'Luisa Sánchez Donoso');
    ```

12. **Cursos con más alumnos matriculados que el curso más numeroso del profesor 'Manuel López García'**:
    ```sql
    SELECT nombre 
    FROM cursos 
    WHERE max_alumnos > (
        SELECT max_alumnos 
        FROM cursos 
        WHERE dni_profesor = (SELECT dni 
                              FROM profesores 
                              WHERE CONCAT(nombre, ' ', apellidos) = 'Manuel López García') 
        ORDER BY max_alumnos DESC LIMIT 1);
    ```

13. **Profesores que imparten cursos con más horas que alguno de los cursos del profesor 'Manuel López García'**:
    ```sql
    SELECT DISTINCT CONCAT(p.nombre, ' ', p.apellidos) AS profesor
    FROM profesores p
    JOIN cursos c ON p.dni = c.dni_profesor
    WHERE c.horas > (
        SELECT horas 
        FROM cursos 
        WHERE dni_profesor = (SELECT dni 
                              FROM profesores 
                              WHERE CONCAT(nombre, ' ', apellidos) = 'Manuel López García')
        LIMIT 1);
    ```

14. **Cursos impartidos por 'Luis Pérez Sánchez' que preparan para la oposición 'Funcionario de Prisiones'**:
    ```sql
    SELECT c.nombre 
    FROM cursos c
    JOIN oposiciones o ON c.codigo_oposicion = o.codigo
    WHERE o.nombre = 'Funcionario de Prisiones'
    AND c.dni_profesor = (SELECT dni 
                          FROM profesores 
                          WHERE CONCAT(nombre, ' ', apellidos) = 'Luis Pérez Sánchez');
    ```

15. **Alumnos que no se han matriculado por libre en ningún curso**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno 
    FROM alumnos 
    WHERE dni NOT IN (SELECT dni_alumno 
                      FROM matriculas 
                      WHERE tipo_matricula = 'libre');
    ```

16. **Profesores con sueldo mayor que el de alguno de sus compañeros de titulación**:
    ```sql
    SELECT CONCAT(p.nombre, ' ', p.apellidos) AS profesor, p.sueldo, p.titulo
    FROM profesores p
    WHERE p.sueldo > (SELECT MAX(sueldo) 
                      FROM profesores 
                      WHERE titulo = p.titulo AND dni != p.dni);
    ```

17. **Profesores que imparten cursos de más de 100 horas pero no imparten cursos de menos de 50 alumnos**:
    ```sql
    SELECT CONCAT(p.nombre, ' ', p.apellidos) AS profesor
    FROM profesores p
    WHERE EXISTS (
        SELECT 1 
        FROM cursos c 
        WHERE c.dni_profesor = p.dni AND c.horas > 100
    ) AND NOT EXISTS (
        SELECT 1 
        FROM cursos c 
        WHERE c.dni_profesor = p.dni AND c.max_alumnos < 50
    );
    ```

18. **Oposiciones de la misma categoría pero distinto organismo que la oposición con código 'C-512'**:
    ```sql
    SELECT o.nombre
    FROM oposiciones o
    WHERE o.categoria = (SELECT categoria 
                         FROM oposiciones 
                         WHERE codigo = 'C-512') 
    AND o.organismo != (SELECT organismo 
                        FROM oposiciones 
                        WHERE codigo = 'C-512');
    ```

19. **Alumnos que solo se han presentado a una prueba en algún curso**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno
    FROM alumnos
    WHERE dni IN (
        SELECT dni_alumno
        FROM pruebas
        GROUP BY dni_alumno
        HAVING COUNT(DISTINCT tipo_prueba) = 1
    );
    ```

20. **Cursos junto con el código de las oposiciones para los que están destinados**:
    ```sql
    SELECT c.nombre, o.codigo 
    FROM cursos c
    JOIN oposiciones o ON c.codigo_oposicion = o.codigo;
    ```

21. **Alumnos del curso 'Función Pública' con notas superiores a 25 puntos de media**:
    ```sql
    SELECT CONCAT(a.nombre, ' ', a.apellidos) AS alumno, p1.nota AS prueba1, p2.nota AS prueba2 
    FROM alumnos a
    JOIN matriculas m ON a.dni = m.dni_alumno
    JOIN pruebas p1 ON m.codigo_curso = p1.codigo_curso AND a.dni = p1.dni_alumno
    JOIN pruebas p2 ON m.codigo_curso = p2.codigo_curso AND a.dni = p2.dni_alumno
    WHERE m.codigo_curso = (SELECT codigo 
                            FROM cursos 
                            WHERE nombre = 'Función Pública')
    AND (p1.nota + p2.nota) / 2 > 25;
    ```

22. **Alumnos con más de 31 años**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno
    FROM alumnos 
    WHERE TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) > 31;
    ```

23. **Cursos con un 25% más de alumnos**:
    ```sql
    SELECT nombre, max_alumnos, max_alumnos * 1.25 AS nuevos_max_alumnos
    FROM cursos;
    ```

24. **Alumnos cuyo primer apellido empieza por 'P'**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno 
    FROM alumnos 
    WHERE apellidos LIKE 'P%';
    ```

25. **Alumnos nacidos en abril**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS alumno, fecha_nacimiento 
    FROM alumnos 
    WHERE MONTH(fecha_nacimiento) = 4;
    ```

26. **Cursos que comienzan en septiembre con nombre del profesor y fecha de inicio**:
    ```sql
    SELECT c.nombre AS curso, CONCAT(p.nombre, ' ', p.apellidos) AS profesor, c.fecha_inicio 
    FROM cursos c
    JOIN profesores p ON c.dni_profesor = p.dni
    WHERE MONTH(c.fecha_inicio) = 9;
    ```

27. **Alumnos con media superior a 20 puntos en 'La Constitución'**:
    ```sql
    SELECT CONCAT(a.nombre, ' ', a.apellidos) AS alumno, 
           (p1.nota + p2.nota) / 2 AS media
    FROM alumnos a
    JOIN matriculas m ON a.dni = m.dni_alumno
    JOIN pruebas p1 ON m.codigo_curso = p1.codigo_curso AND a.dni = p1.dni_alumno
    JOIN pruebas p2 ON m.codigo_curso = p2.codigo_curso AND a.dni = p2.dni_alumno
    WHERE m.codigo_curso = (SELECT codigo 
                            FROM cursos 
                            WHERE nombre = 'La Constitución')
    HAVING media > 20;
    ```

28. **Nombre completo de todas las personas en la academia, ordenados alfabéticamente**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS persona 
    FROM (
        SELECT nombre, apellidos FROM alumnos
        UNION ALL
        SELECT nombre, apellidos FROM profesores
    ) AS personas
    ORDER BY apellidos;
    ```

29. **Profesores y cursos que imparten**:
    ```sql
    SELECT CONCAT(p.nombre, ' ', p.apellidos) AS profesor, c.nombre AS curso 
    FROM profesores p
    LEFT JOIN cursos c ON p.dni = c.dni_profesor;
    ```

30. **Número de alumnos matriculados en 'La Constitución'**:
    ```sql
    SELECT COUNT(*) 
    FROM matriculas 
    WHERE codigo_curso = (SELECT codigo 
                          FROM cursos 
                          WHERE nombre = 'La Constitución');
    ```

31. **Número de alumnos nacidos en 1970**:
    ```sql
    SELECT COUNT(*) 
    FROM alumnos 
    WHERE YEAR(fecha_nacimiento) = 1970;
    ```

32. **Nombre del curso con más horas**:
    ```sql
    SELECT nombre 
    FROM cursos 
    ORDER BY horas DESC LIMIT 1;
    ```

33. **Alumnos con la nota más alta en la prueba 1 de cada curso**:
    ```sql
    SELECT CONCAT(a.nombre, ' ', a.apellidos) AS alumno, c.nombre AS curso, p1.nota 
    FROM alumnos a
    JOIN matriculas m ON a.dni = m.dni_alumno
    JOIN cursos c ON m.codigo_curso = c.codigo
    JOIN pruebas p1 ON m.codigo_curso = p1.codigo_curso AND a.dni = p1.dni_alumno
    WHERE p1.nota = (SELECT MAX(nota) 
                     FROM pruebas 
                     WHERE codigo_curso = p1.codigo_curso);
    ```

34. **Número total de alumnos en cursos de 'Luis Pérez Sánchez' y sus notas en la prueba 1**:
    ```sql
    SELECT COUNT(*) AS total_alumnos, MAX(p1.nota) AS nota_max, MIN(p1.nota) AS nota_min
    FROM cursos c
    JOIN profesores p ON c.dni_profesor = p.dni
    JOIN pruebas p1 ON c.codigo = p1.codigo_curso
    WHERE CONCAT(p.nombre, ' ', p.apellidos) = 'Luis Pérez Sánchez';
    ```

35. **Número total de alumnos matriculados en los cursos de cada profesor**:
    ```sql
    SELECT CONCAT(p.nombre, ' ', p.apellidos) AS profesor, COUNT(m.dni_alumno) AS total_alumnos
    FROM profesores p
    LEFT JOIN cursos c ON p.dni = c.dni_profesor
    LEFT JOIN matriculas m ON c.codigo = m.codigo_curso
    GROUP BY p.dni;
    ```

36. **Nota mínima, máxima y media por sexo en todas las pruebas**:
    ```sql
    SELECT sexo, 
           MIN(p1.nota) AS nota_min, 
           MAX(p1.nota) AS nota_max, 
           AVG(p1.nota) AS nota_media
    FROM pruebas p1
    JOIN alumnos a ON p1.dni_alumno = a.dni
    GROUP BY sexo;
    ```

37. **Profesores con más cursos**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS profesor, COUNT(*) AS num_cursos 
    FROM profesores p
    JOIN cursos c ON p.dni = c.dni_profesor
    GROUP BY p.dni 
    ORDER BY num_cursos DESC LIMIT 1;
    ```

38. **Oposiciones que requieren tres o más cursos**:
    ```sql
    SELECT o.nombre 
    FROM oposiciones o
    JOIN cursos c ON o.codigo = c.codigo_oposicion
    GROUP BY o.codigo 
    HAVING COUNT(c.codigo) >= 3;
    ```

39. **Profesores con más horas que todos los cursos de 'Luis Pérez Sánchez'**:
    ```sql
    SELECT CONCAT(p.nombre, ' ', p.apellidos) AS profesor 
    FROM profesores p
    JOIN cursos c ON p.dni = c.dni_profesor
    WHERE SUM(c.horas) > (SELECT SUM(horas) 
                          FROM cursos 
                          WHERE dni_profesor = (SELECT dni 
                                                FROM profesores 
                                                WHERE CONCAT(nombre, ' ', apellidos) = 'Luis Pérez Sánchez'));
    ```

40. **Profesores que dan menos horas**:
    ```sql
    SELECT CONCAT(nombre, ' ', apellidos) AS profesor 
    FROM profesores p
    JOIN cursos c ON p.dni = c.dni_profesor
    GROUP BY p.dni
    ORDER BY SUM(c.horas) ASC LIMIT 1;
    ```

