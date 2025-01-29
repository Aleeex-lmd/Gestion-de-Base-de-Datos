-- tabla modelos (codigo, constructor, asientos, pesomaximo, autonomia)
-- tabla aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision)
-- tabla rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo 
-- tabla vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada)

-- 1
SELECT 
    m.constructor,
    COUNT (v.codruta) AS "Num vuelos realizados"
FROM vuelos v 
JOIN aviones a ON v.matricula = a.matricula
JOIN modelos m ON a.codmodelo = m.codigo
GROUP BY m.constructor;

--2 

ALTER TABLE Aviones ADD tempv INT(5);
UPDATE Aviones
SET tempv = (select SUM(r.minutosvuelo)
                FROM
                JOIN Vuelos v ON a.matricula = v.matricula
                JOIN Rutas r ON v.codruta = r.codigo;

-- 3
SELECT a.matricula AS "Matrícula avión", (SUM(v.numbilletesvendidos)/ COUNT(v.numbilletesvendidos) ) AS "Media billetes vendidos"
FROM aviones a
INNER JOIN Vuelos v ON a.matricula = v.matricula
GROUP BY a.matricula;

-- 4
CREATE VIEW examen4 AS(
    SELECT r.codigo, r.aeropuertoorigen, r.aeropuertodestino, (SUM(v.numbilletesvendidos) * r.preciobillete ) AS "Total billetes vendidos"
    FROM Rutas r 
    JOIN Vuelos v ON r.codigo = v.codruta
    GROUP BY r.codigo, r.aeropuertodestino, aeropuertoorigen, r.preciobillete);

select * from examen4;

SELECT r.codigo, SUM(v.numbilletesvendidos)
FROM Rutas r 
JOIN Vuelos v ON r.codigo = v.codruta
GROUP BY r.codigo;
-- 5

SELECT a.matricula 
FROM aviones a 
JOIN vuelos v ON a.matricula = v.matricula
JOIN rutas r ON v.codruta = r.codigo
WHERE aeropuertoorigen = 'MAD' AND a.anyofab > 2016
ORDER BY a.matricula DESC;

--6 
SELECT r.codigo
FROM rutas r 
JOIN vuelos v ON r.codigo = v.codruta
WHERE ((r.preciobillete * v.numbilletesvendidos) < costeestimadovuelo);

-- Se a añadido una inserccion para probar su funcionamiento
insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A06',8056,'MAD','CHN',12.1,9276,567);
insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A06','EC-AAA','IB', to_date('28/02/22 05:00','DD/MM/YY HH24:MI'),9,'T1','T1');
