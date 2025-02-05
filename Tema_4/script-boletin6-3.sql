-- Tabla EQUIPOS
CREATE TABLE EQUIPOS (
    CodEquipo CHAR(4) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Localidad VARCHAR(15)
);

-- Tabla JUGADORES
CREATE TABLE JUGADORES (
    CodJugador CHAR(4) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Fecha_Nacimiento DATE,
    Demarcacion VARCHAR(10),
    CodEquipo CHAR(4),
    FOREIGN KEY (CodEquipo) REFERENCES EQUIPOS(CodEquipo)
);

-- Tabla PARTIDOS
CREATE TABLE PARTIDOS (
    CodPartido CHAR(4) PRIMARY KEY,
    CodEquipoLocal CHAR(4),
    CodEquipoVisitante CHAR(4),
    Fecha DATE CHECK (EXTRACT(MONTH FROM Fecha) NOT IN (7, 8)),
    Competicion VARCHAR(4) CHECK (Competicion IN ('Copa', 'Liga')),
    Jornada VARCHAR(20),
    FOREIGN KEY (CodEquipoLocal) REFERENCES EQUIPOS(CodEquipo),
    FOREIGN KEY (CodEquipoVisitante) REFERENCES EQUIPOS(CodEquipo)
);

-- Tabla INCIDENCIAS
CREATE TABLE INCIDENCIAS (
    NumIncidencia CHAR(6) PRIMARY KEY,
    CodPartido CHAR(4),
    CodJugador CHAR(4),
    Minuto TINYINT CHECK (Minuto BETWEEN 1 AND 100),
    Tipo VARCHAR(20),
    FOREIGN KEY (CodPartido) REFERENCES PARTIDOS(CodPartido),
    FOREIGN KEY (CodJugador) REFERENCES JUGADORES(CodJugador)
);
