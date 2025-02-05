-- Boletin 5 consultas

-- Centros (num_centro, nombre, direccion, localidad) 

-- Departamentos (num_dpto, nombre, presupuesto, num_centro)

-- Empleados (num_emp, nombre, fecha_nacimiento, fecha_ingreso, telf_emp, salario, comision, num_hijos, tipo, num_dpto)


-- Obtener  el  salario  y  nombre  de  los  empleados  sin  hijos  por  orden  decreciente de salario y por orden alfabético dentro de salario
SELECT 
    e.salario,
    e.nombre
FROM Empleados e
WHERE e.num_hijos = 0
ORDER BY e.salario DESC, e.nombre ASC;

-- Para los empleados del departamento 112 hallar el nombre y el salario total de cada uno (salario más comisión), por orden de salario total decreciente y por orden alfabético dentro de salario total.
SELECT 
    e.nombre,
    (e.salario + e.comision) AS "Salario total"
FROM Empleados e
WHERE  e.num_dpto = 120
ORDER BY (e.salario + e.comision) DESC, e.nombre ASC;

-- Hallar cuántos departamentos hay y el presupuesto anual medio de ellos, para los departamentos que tienen director provisional.
SELECT 
    d.num_dpto,
    SUM(d.presupuesto) / COUNT(e.num_emp) AS "Media presupuesto"
FROM Departamentos d
JOIN Empleados e ON d.num_dpto = e.num_dpto
WHERE e.tipo = 'Eventual'
GROUP BY d.num_dpto;

 -- Para cada extensión telefónica y para cada departamento hallar cuantos empleados la usan y el salario medio de éstos


-- Hallar  si  hay  algún  departamento  en  la  tabla  Departamento  cuyo  centro  de trabajo no exista en la tabla Centro
SELECT 
    d.num_dpto, d.nombre
FROM Departamentos d
WHERE d.num_centro NOT IN (SELECT c.num_centro FROM Centros c);

SELECT 
    d.num_dpto, d.nombre
FROM Departamentos d
LEFT JOIN Centros c ON d.num_centro = c.num_centro
WHERE c.num_centro IS NULL;

-- 6. Para todos los departamentos que no sean de Dirección ni de Sectores, hallar el número de departamento y sus extensiones telefónicas, por orden creciente de departamento y, dentro de éste, por número de extensión creciente. 
