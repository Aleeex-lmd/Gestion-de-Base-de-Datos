CREATE TABLE alumnos (
    dni       VARCHAR(4),
    nombre    VARCHAR(30),
    apellido1 VARCHAR(30),
    apellido2 VARCHAR(30),
    direccion VARCHAR(50),
    sexo      VARCHAR(2),
    fechanac  DATE,
    PRIMARY KEY (dni)
);

CREATE TABLE profesores (
    dni       VARCHAR(4),
    nombre    VARCHAR(20),
    apellido1 VARCHAR(20),
    apellido2 VARCHAR(20),
    direccion VARCHAR(50),
    titulo    VARCHAR(30),
    sueldo    INT,
    PRIMARY KEY (dni)
);

CREATE TABLE cursos (
    codigocurso VARCHAR(5),
    nombrecurso VARCHAR(40),
    maxalumnos  INT,
    fechaini    DATE,
    fechafin    DATE,
    numhoras    INT,
    profesor    VARCHAR(4),
    PRIMARY KEY (codigocurso)
);

CREATE TABLE matriculas (
    dnialumno   VARCHAR(4),
    codcurso    VARCHAR(5),
    pruebaA     INT,
    pruebaB     INT,
    tipo        VARCHAR(10),
    inscripcion DATE,
    PRIMARY KEY (dnialumno, codcurso),
    FOREIGN KEY (dnialumno) REFERENCES alumnos (dni),
    FOREIGN KEY (codcurso) REFERENCES cursos (codigocurso)
);

CREATE TABLE oposiciones (
    codigo    VARCHAR(6),
    nombre    VARCHAR(30),
    fecexam   DATE,
    organismo VARCHAR(50),
    plazas    INT,
    categoria VARCHAR(1),
    PRIMARY KEY (codigo)
);

CREATE TABLE curso_oposicion (
    codcurso     VARCHAR(4),
    codoposicion VARCHAR(6),
    PRIMARY KEY (codcurso, codoposicion),
    FOREIGN KEY (codcurso) REFERENCES cursos (codigocurso),
    FOREIGN KEY (codoposicion) REFERENCES oposiciones (codigo)
);

CREATE TABLE manuales (
    referencia VARCHAR(5),
    titulo     VARCHAR(50),
    autor      VARCHAR(30),
    fechapub   DATE,
    precio     INT,
    PRIMARY KEY (referencia)
);

CREATE TABLE curso_manual (
    codcurso    VARCHAR(6),
    referencia  VARCHAR(5),
    PRIMARY KEY (codcurso, referencia),
    FOREIGN KEY (codcurso) REFERENCES cursos (codigocurso),
    FOREIGN KEY (referencia) REFERENCES manuales (referencia)
);

-- Inserción de datos
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) 
VALUES 
    ('1111','Carlos','Puerta','Perez','c/ Pí, 21','V',STR_TO_DATE('12/09/1989','%d/%m/%Y')),
    ('2222','Luisa','Sanchez','Donoso','c/ Sierpes, 1','M',STR_TO_DATE('12/05/1968','%d/%m/%Y')),
    ('3333','Eva','Ramos','Prieto','c/ Rueda, 31','M',STR_TO_DATE('12/04/1969','%d/%m/%Y')),
    ('4444','Luis','Paez','Garcia','c/ Martin Villa, 21','V',STR_TO_DATE('22/04/1979','%d/%m/%Y')),
    ('5555','Ana','Padilla','Torres','c/ Tetuan, 2','M',STR_TO_DATE('12/09/1970','%d/%m/%Y')),
    ('6666','Lola','Flores','Ruiz','c/ Real, 14','M',STR_TO_DATE('18/04/1970','%d/%m/%Y'));

INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) 
VALUES 
    ('111','Manuel','Lopez','Garcia','c/ Albeniz,12','Ingeniero de Caminos',2000),
    ('222','Luis','Perez','Sanchez','c/ Huelva, 1','Licenciado en Psicologia',1400),
    ('333','Ana','Garcia','Lopez','c/ Sevilla,2','Ingeniero de Caminos',2200),
    ('444','Eva','Parra','Ruiz','c/ Astoria,7','Licenciado en Derecho',1200),
    ('555','Federico','Flores','Alba','c/ Tarifa, 1','Ingeniero Informático',2500),
    ('666','Alberto','Moreno','Rodriguez','c/ Parra, 2','Ingeniero de Caminos',2100);

INSERT INTO cursos (codigocurso, nombrecurso, maxalumnos, fechaini, fechafin, numhoras, profesor) 
VALUES 
    ('0001','Función Pública',120,STR_TO_DATE('03/05/2009','%d/%m/%Y'),STR_TO_DATE('30/06/2009','%d/%m/%Y'),400,'444'),
    ('0002','Los chiquillos',180,STR_TO_DATE('13/05/2009','%d/%m/%Y'),STR_TO_DATE('30/08/2009','%d/%m/%Y'),600,'222'),
    ('0003','Puentes Atirantados',20,STR_TO_DATE('03/12/2008','%d/%m/%Y'),STR_TO_DATE('30/06/2009','%d/%m/%Y'),800,'111'),
    ('0004','Vida familiar de los presos',120,STR_TO_DATE('03/05/2009','%d/%m/%Y'),STR_TO_DATE('30/06/2009','%d/%m/%Y'),400,'222'),
    ('0005','La Constitución',230,STR_TO_DATE('03/05/2009','%d/%m/%Y'),STR_TO_DATE('30/06/2009','%d/%m/%Y'),100,'444'),
    ('0006','Programación Visual para todos',80,STR_TO_DATE('03/09/2009','%d/%m/%Y'),STR_TO_DATE('30/09/2009','%d/%m/%Y'),30,'555');

-- Inserciones en la tabla manuales
INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) 
VALUES 
('M001', 'El Derecho', 'Garzón', STR_TO_DATE('12/05/2006','%d/%m/%Y'), 23),
('M002', 'C y PHP: lo mismo es', 'Joseph Sunday', STR_TO_DATE('12/09/2007','%d/%m/%Y'), 12),
('M003', 'Los delincuentes y sus sentimientos', 'El Chori', STR_TO_DATE('12/07/2008','%d/%m/%Y'), 16),
('M004', 'Las Administraciones Publicas', 'Ruiz', STR_TO_DATE('12/07/2007','%d/%m/%Y'), 8),
('M005', 'Estatica y Dinamica', 'Calatrava', STR_TO_DATE('02/05/2005','%d/%m/%Y'), 43),
('M006', 'Problemas irresolubles en JSP', 'John Tagua', STR_TO_DATE('07/07/2007','%d/%m/%Y'), 25);

-- Inserciones en la tabla oposiciones
INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) 
VALUES 
('C-502','Maestros de Primaria',STR_TO_DATE('27/05/2010','%d/%m/%Y'),'Consejeria Educacion', 1220, 'B'),
('C-512','Funcionario de Prisiones',STR_TO_DATE('20/06/2010','%d/%m/%Y'),'Consejeria Justicia', 120, 'C'),
('C-522','Profesores de Informática',STR_TO_DATE('27/06/2009','%d/%m/%Y'),'Consejeria Educacion', 12, 'A'),
('C-532','Jardineros del Estado',STR_TO_DATE('27/05/2010','%d/%m/%Y'),'Ministerio Medio Ambiente', 10, 'D'),
('C-542','Administrativos',STR_TO_DATE('27/05/2010','%d/%m/%Y'),'Ayuntamiento DH', 12, 'C'),
('C-552','Ingenieros del Ejercito',STR_TO_DATE('27/09/2010','%d/%m/%Y'),'Ministerio Defensa', 120, 'A');

-- Inserciones en la tabla matriculas
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) 
VALUES 
('1111','0001',12,8,'Oficial',STR_TO_DATE('12/06/2006','%d/%m/%Y')),
('1111','0005',18,5,'Oficial',STR_TO_DATE('12/07/2006','%d/%m/%Y')),
('2222','0003',25,28,'Libre',STR_TO_DATE('12/08/2006','%d/%m/%Y')),
('2222','0005',32,28,'Libre',STR_TO_DATE('12/09/2006','%d/%m/%Y')),
('3333','0006',12,NULL,'Oficial',STR_TO_DATE('12/10/2006','%d/%m/%Y')),
('4444','0006',NULL,18,'Oficial',STR_TO_DATE('12/11/2006','%d/%m/%Y')),
('5555','0006',20,48,'Oficial',STR_TO_DATE('12/12/2006','%d/%m/%Y')),
('5555','0002',32,38,'Libre',STR_TO_DATE('12/01/2007','%d/%m/%Y')),
('5555','0003',11,18,'Oficial',STR_TO_DATE('12/02/2007','%d/%m/%Y')),
('5555','0001',11,38,'Oficial',STR_TO_DATE('12/03/2007','%d/%m/%Y')),
('5555','0005',42,48,'Oficial',STR_TO_DATE('12/04/2007','%d/%m/%Y'));

-- Inserciones en la tabla curso_oposicion
INSERT INTO curso_oposicion (codcurso, codoposicion) 
VALUES 
('0001','C-502'),
('0001','C-512'),
('0001','C-522'),
('0001','C-532'),
('0001','C-542'),
('0001','C-552'),
('0002','C-502'),
('0003','C-552'),
('0004','C-512'),
('0006','C-522'),
('0005','C-502'),
('0005','C-512'),
('0005','C-522'),
('0005','C-532'),
('0005','C-542');

-- Inserciones en la tabla curso_manual
INSERT INTO curso_manual (codcurso, referencia) 
VALUES 
('0001','M001'),
('0004','M001'),
('0005','M001'),
('0006','M002'),
('0004','M003'),
('0001','M004'),
('0005','M004'),
('0003','M005'),
('0006','M006');
