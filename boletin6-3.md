-- Deshabilitar restricción temporalmente (si es necesario)
ALTER TABLE INCIDENCIAS DISABLE TRIGGER ALL;

-- Borrar jugadores
DELETE FROM JUGADORES
WHERE CodJugador NOT IN (
    SELECT DISTINCT CodJugador
    FROM INCIDENCIAS i
    JOIN PARTIDOS p ON i.CodPartido = p.CodPartido
    WHERE p.Competicion = 'Liga' AND i.Tipo = 'Gol'
)
AND CodEquipo IN (
    SELECT CodEquipo 
    FROM EQUIPOS 
    WHERE Localidad = 'Madrid'
);

