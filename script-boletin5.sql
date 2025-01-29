CREATE TABLE Centros (
  num_centro INT,
  nombre VARCHAR(50),
  direccion VARCHAR(40),
  localidad VARCHAR(40),
  provincia VARCHAR(30),
  CONSTRAINT pk_centros PRIMARY KEY (num_centro)
);

CREATE TABLE Departamentos (
  num_dpto INT,
  nombre VARCHAR(50),
  presupuesto DECIMAL(10, 2),
  num_centro INT,
  CONSTRAINT pk_departamentos PRIMARY KEY (num_dpto),
  CONSTRAINT fk_departamentos FOREIGN KEY (num_centro) REFERENCES Centros(num_centro)
);

CREATE TABLE Empleados (
  num_emp INT,
  nombre VARCHAR(50),
  fecha_nacimiento DATE,
  fecha_ingreso DATE,
  telf_emp INT,
  salario DECIMAL(10, 2),
  comision DECIMAL(10, 2),
  num_hijos INT,
  tipo VARCHAR(10),
  num_dpto INT,
  CONSTRAINT pk_empleados PRIMARY KEY (num_emp),
  CONSTRAINT fk_empleados FOREIGN KEY (num_dpto) REFERENCES Departamentos(num_dpto),
  CONSTRAINT chk_tipo CHECK (tipo IN ('fijo', 'eventual'))
);

-- Insert statements with each row inserted separately
INSERT INTO Centros VALUES (1, 'Zona Sur', 'C/. Miraflores s/n', 'Sevilla', 'Sevilla');
INSERT INTO Centros VALUES (2, 'Zona Centro', 'Avda. Felipe II,4', 'Dos Hermanas', 'Sevilla');

INSERT INTO Departamentos VALUES (5, 'Reparaciones', 150000, 1);
INSERT INTO Departamentos VALUES (10, 'Ventas', 200000, 2);

INSERT INTO Empleados VALUES (1, 'Juan Perez', TO_DATE('1960-10-25', 'YYYY-MM-DD'), TO_DATE('1980-10-25', 'YYYY-MM-DD'), 954858691, 10000, 500, 0, 'fijo', 5);
INSERT INTO Empleados VALUES (2, 'Rosa Gil', TO_DATE('1965-12-25', 'YYYY-MM-DD'), TO_DATE('1989-10-25', 'YYYY-MM-DD'), 954668221, 12000, 1500, 1, 'fijo', 10);
