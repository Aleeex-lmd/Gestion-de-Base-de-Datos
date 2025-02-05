-- Tabla VEHICULOS
CREATE TABLE VEHICULOS (
    Matricula CHAR(7) PRIMARY KEY,
    Marca VARCHAR(10) NOT NULL,
    Modelo VARCHAR(10) NOT NULL,
    Fecha_Compra DATE CHECK (Fecha_Compra >= '2001-01-01'),
    Precio_por_dia DECIMAL(5, 2) CHECK (Precio_por_dia > 0)
);

-- Tabla CLIENTES
CREATE TABLE CLIENTES (
    DNI CHAR(9) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Nacionalidad VARCHAR(30),
    Fecha_Nacimiento DATE,
    Direccion VARCHAR(50)
);

-- Tabla ALQUILERES
CREATE TABLE ALQUILERES (
    Matricula CHAR(7) NOT NULL,
    DNI CHAR(9) NOT NULL,
    Fecha_Inicial DATE,
    Num_Dias TINYINT CHECK (Num_Dias > 0),
    Kilometros SMALLINT DEFAULT 0 CHECK (Kilometros >= 0),
    PRIMARY KEY (Matricula, DNI, Fecha_Inicial),
    FOREIGN KEY (Matricula) REFERENCES VEHICULOS(Matricula),
    FOREIGN KEY (DNI) REFERENCES CLIENTES(DNI)
);
