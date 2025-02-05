create table alumnos (
    dni       VARCHAR2(4),
    nombre    VARCHAR2(30),
    apellido1 VARCHAR2(30),
    apellido2 VARCHAR2(30),
    direccion VARCHAR2(50),
    sexo      VARCHAR2(2),
    fechanac  DATE,
    -- restricciones    
    CONSTRAINT pk_alumnos PRIMARY KEY (dni)
);

CREATE TABLE profesores (
    dni       VARCHAR2(4),
    nombre    VARCHAR(20),
    apellido1 VARCHAR2(20),
    apellido2 VARCHAR2(20),
    direccion VARCHAR2(50),
    titulo    VARCHAR(30),
    sueldo    INTEGER,
    -- restricciones    
    CONSTRAINT pk_profesores PRIMARY KEY (dni)    
);

CREATE TABLE cursos (
    codigocurso VARCHAR2(5),
    nombrecurso VARCHAR2(40),
    maxalumnos  INTEGER,
    fechaini    DATE,
    fechafin    DATE,
    numhoras    INTEGER,
    profesor    VARCHAR2(4),
    -- restricciones    
    CONSTRAINT pk_cursos PRIMARY KEY (codigocurso)   
);

CREATE TABLE matriculas (
    dnialumno   VARCHAR2(4),
    codcurso    VARCHAR2(5),
    pruebaA     INTEGER,
    pruebaB     INTEGER,
    tipo        VARCHAR2(10),
    inscripcion DATE,
    -- restricciones    
    CONSTRAINT pk_matriculas PRIMARY KEY (dnialumno, codcurso),
    CONSTRAINT fk_dnialumno FOREIGN KEY (dnialumno) REFERENCES alumnos (dni),
    CONSTRAINT fk_codcurso FOREIGN KEY (codcurso) REFERENCES cursos (codigocurso),
    CONSTRAINT pruebaA_ok CHECK ( pruebaA BETWEEN 0 AND 50 ),
    CONSTRAINT pruebaB_ok CHECK ( pruebaB BETWEEN 0 AND 50 )
);

CREATE TABLE oposiciones (
    codigo    VARCHAR2(6),
    nombre    VARCHAR2(30),
    fecexam   DATE,
    organismo VARCHAR2(50),
    plazas    INTEGER,
    categoria VARCHAR2(1),
    -- restricciones    
    CONSTRAINT pk_oposiciones PRIMARY KEY (codigo),
    CONSTRAINT categoria_ok CHECK ('A' <= categoria and categoria <= 'E')
);

CREATE TABLE curso_oposicion (
    codcurso     VARCHAR2(4),
    codoposicion VARCHAR2(6),
    -- restricciones    
    CONSTRAINT pk_curso_oposicion PRIMARY KEY (codcurso,codoposicion),
    CONSTRAINT fk_codcursoop FOREIGN KEY (codcurso) REFERENCES cursos (codigocurso),
    CONSTRAINT fk_codoposicion FOREIGN KEY (codoposicion) REFERENCES oposiciones (codigo)        
);

CREATE TABLE manuales (
    referencia VARCHAR2(5),
    titulo     VARCHAR2(50),
    autor      VARCHAR2(30),
    fechapub   DATE,
    precio     INTEGER,
    -- restricciones    
    CONSTRAINT pk_manuales PRIMARY KEY (referencia)    
);

CREATE TABLE curso_manual (
    codcurso    VARCHAR2(6),
    referencia  VARCHAR2(5),
    -- restricciones    
    CONSTRAINT pk_curso_manual PRIMARY KEY (codcurso, referencia),
    CONSTRAINT fk_codcursomanual FOREIGN KEY (codcurso) REFERENCES cursos (codigocurso),
    CONSTRAINT fk_refcursomanual FOREIGN KEY (referencia) REFERENCES manuales (referencia)
);
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) VALUES('1111','Carlos','Puerta','Perez','c/ Pí, 21','V',TO_DATE('12/09/1989','DD/MM/YYYY'));
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) VALUES('2222','Luisa','Sanchez','Donoso','c/ Sierpes, 1','M',TO_DATE('12/05/1968','DD/MM/YYYY'));
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) VALUES('3333','Eva','Ramos','Prieto','c/ Rueda, 31','M',TO_DATE('12/04/1969','DD/MM/YYYY'));
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) VALUES('4444','Luis','Paez','Garcia','c/ Martin Villa, 21','V',TO_DATE('22/04/1979','DD/MM/YYYY'));
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) VALUES('5555','Ana','Padilla','Torres','c/ Tetuan, 2','M',TO_DATE('12/09/1970','DD/MM/YYYY'));
INSERT INTO alumnos (dni, nombre, apellido1, apellido2, direccion, sexo, fechanac) VALUES('6666','Lola','Flores','Ruiz','c/ Real, 14','M',TO_DATE('18/04/1970','DD/MM/YYYY'));

INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) VALUES('111','Manuel','Lopez','Garcia','c/ Albeniz,12','Ingeniero de Caminos',2000);
INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) VALUES('222','Luis','Perez','Sanchez','c/ Huelva, 1','Licenciado en Psicologia',1400);
INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) VALUES('333','Ana','Garcia','Lopez','c/ Sevilla,2','Ingeniero de Caminos',2200);
INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) VALUES('444','Eva','Parra','Ruiz','c/ Astoria,7','Licenciado en Derecho',1200);
INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) VALUES('555','Federico','Flores','Alba','c/ Tarifa, 1','Ingeniero Informtico',2500);
INSERT INTO profesores (dni, nombre, apellido1, apellido2, direccion, titulo, sueldo) VALUES('666','Alberto','Moreno','Rodriguez','c/ Parra, 2','Ingeniero de Caminos',2100);

INSERT INTO cursos (codigocurso,nombrecurso,maxalumnos,fechaini,fechafin,numhoras,profesor) VALUES('0001','Función Publica',120,TO_DATE('03/05/09','DD/MM/YYYY'),TO_DATE('30/06/09','DD/MM/YYYY'),400,'444');
INSERT INTO cursos (codigocurso,nombrecurso,maxalumnos,fechaini,fechafin,numhoras,profesor) VALUES('0002','Los chiquillos',180,TO_DATE('13/05/09','DD/MM/YYYY'),TO_DATE('30/08/09','DD/MM/YYYY'),600,'222');
INSERT INTO cursos (codigocurso,nombrecurso,maxalumnos,fechaini,fechafin,numhoras,profesor) VALUES('0003','Puentes Atirantados',20,TO_DATE('03/12/08','DD/MM/YYYY'),TO_DATE('30/06/09','DD/MM/YYYY'),800,'111');
INSERT INTO cursos (codigocurso,nombrecurso,maxalumnos,fechaini,fechafin,numhoras,profesor) VALUES('0004','Vida familiar de los presos',120,TO_DATE('03/05/09','DD/MM/YYYY'),TO_DATE('30/06/09','DD/MM/YYYY'),400,'222');
INSERT INTO cursos (codigocurso,nombrecurso,maxalumnos,fechaini,fechafin,numhoras,profesor) VALUES('0005','La Constitucion',230,TO_DATE('03/05/09','DD/MM/YYYY'),TO_DATE('30/06/09','DD/MM/YYYY'),100,'444');
INSERT INTO cursos (codigocurso,nombrecurso,maxalumnos,fechaini,fechafin,numhoras,profesor) VALUES('0006','Programación Visual para todos',80,TO_DATE('03/09/09','DD/MM/YYYY'),TO_DATE('30/09/09','DD/MM/YYYY'),30,'555');

INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) VALUES('M001', 'El Derecho', 'Garzón', TO_DATE('12/05/06','DD/MM/YYYY'), 23);
INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) VALUES('M002', 'C y PHP: lo mismo es', 'Joseph Sunday', TO_DATE('12/09/07','DD/MM/YYYY'), 12);
INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) VALUES('M003', 'Los delincuentes y sus sentimientos', 'El Chori', TO_DATE('12/07/08','DD/MM/YYYY'), 16);
INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) VALUES('M004', 'Las Administraciones Publicas', 'Ruiz', TO_DATE('12/07/07','DD/MM/YYYY'), 8);
INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) VALUES('M005', 'Estatica y Dinamica', 'Calatrava', TO_DATE('02/05/05','DD/MM/YYYY'), 43);
INSERT INTO manuales (referencia, titulo, autor, fechapub, precio) VALUES('M006', 'Problemas irresolubles en JSP', 'John Tagua', TO_DATE('07/07/07','DD/MM/YYYY'), 25);

INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) VALUES('C-502','Maestros de Primaria',TO_DATE('27/05/10','DD/MM/YYYY'),'Consejeria Educacion', 1220, 'B');
INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) VALUES('C-512','Funcionario de Prisiones',TO_DATE('20/06/10','DD/MM/YYYY'),'Consejeria Justicia', 120, 'C');
INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) VALUES('C-522','Profesores de Informática',TO_DATE('27/06/09','DD/MM/YYYY'),'Consejeria Educacion', 12, 'A');
INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) VALUES('C-532','Jardineros del Estado',TO_DATE('27/05/10','DD/MM/YYYY'),'Ministerio Medio Ambiente', 10, 'D');
INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) VALUES('C-542','Administrativos',TO_DATE('27/05/10','DD/MM/YYYY'),'Ayuntamiento DH', 12, 'C');
INSERT INTO oposiciones (codigo, nombre, fecexam, organismo, plazas, categoria) VALUES('C-552','Ingenieros del Ejercito',TO_DATE('27/09/10','DD/MM/YYYY'),'Ministerio Defensa', 120, 'A');

INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('1111','0001',12,8,'Oficial',TO_DATE('12/06/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('1111','0005',18,5,'Oficial',TO_DATE('12/07/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('2222','0003',25,28,'Libre',TO_DATE('12/08/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('2222','0005',32,28,'Libre',TO_DATE('12/09/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, tipo, inscripcion) VALUES('3333','0006',12,'Oficial',TO_DATE('12/10/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaB, tipo, inscripcion) VALUES('4444','0006',18,'Oficial',TO_DATE('12/11/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('5555','0006',20,48,'Oficial',TO_DATE('12/12/06','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('5555','0002',32,38,'Libre',TO_DATE('12/01/07','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('5555','0003',11,18,'Oficial',TO_DATE('12/02/07','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('5555','0001',11,38,'Oficial',TO_DATE('12/03/07','DD/MM/YYYY'));
INSERT INTO matriculas (dnialumno, codcurso, pruebaA, pruebaB, tipo, inscripcion) VALUES('5555','0005',42,48,'Oficial',TO_DATE('12/04/07','DD/MM/YYYY'));

INSERT INTO curso_oposicion VALUES('0001','C-502');
INSERT INTO curso_oposicion VALUES('0001','C-512');
INSERT INTO curso_oposicion VALUES('0001','C-522');
INSERT INTO curso_oposicion VALUES('0001','C-532');
INSERT INTO curso_oposicion VALUES('0001','C-542');
INSERT INTO curso_oposicion VALUES('0001','C-552');
INSERT INTO curso_oposicion VALUES('0002','C-502');
INSERT INTO curso_oposicion VALUES('0003','C-552');
INSERT INTO curso_oposicion VALUES('0004','C-512');
INSERT INTO curso_oposicion VALUES('0006','C-522');
INSERT INTO curso_oposicion VALUES('0005','C-502');
INSERT INTO curso_oposicion VALUES('0005','C-512');
INSERT INTO curso_oposicion VALUES('0005','C-522');
INSERT INTO curso_oposicion VALUES('0005','C-532');
INSERT INTO curso_oposicion VALUES('0005','C-542');

INSERT INTO curso_manual (codcurso, referencia) VALUES('0001','M001');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0004','M001');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0005','M001');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0006','M002');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0004','M003');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0001','M004');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0005','M004');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0003','M005');
INSERT INTO curso_manual (codcurso, referencia) VALUES('0006','M006');