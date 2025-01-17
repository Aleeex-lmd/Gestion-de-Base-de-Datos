create database Departamentos character set utf8 collate utf8_spanish_ci;

use Departamentos;

create table Centros (
num_centro int(3),
nombre varchar(50),
direccion varchar(40),
localidad varchar(40),provincia varchar(30),
constraint pk_centros primary key (num_centro))engine=InnoDB;

create table Departamentos (
num_dpto int(3),
nombre varchar(50),
presupuesto decimal(10,2),
num_centro int(3),
constraint pk_departamentos primary key (num_dpto),
constraint fk_departamentos foreign key (num_centro) references Centros(num_centro))engine=InnoDB;

create table Empleados (
num_emp int(3),
nombre varchar(50),
fecha_nacimiento date,
fecha_ingreso date,
telf_emp int(8),
salario decimal(10,2),
comision decimal(10,2),
num_hijos int(1),
tipo enum('fijo','eventual'),
num_dpto int(3),
CONSTRAINT pk_empleados primary key (num_emp),
CONSTRAINT fk_empleados foreign key (num_dpto) references Departamentos(num_dpto))engine=InnoDB;

insert into Centros values (001,"Zona Sur","C/. Miraflores s/n","Sevilla","Sevilla"),(002,"Zona Centro","Avda. Felipe II,4","Dos Hermanas","Sevilla");

insert into Departamentos values (005,"Reparaciones",150000,001),(010,"Ventas",200000,002);

insert into Empleados values (001,"Juan P�ez",'1960/10/25','1980/10/25',954858691,10000,500,0,'fijo',005),(002,"Rosa Gil",'1965/12/25','1989/10/25',954668221,12000,1500,1,'fijo',010);

load data infile 'C_CENTROS.txt' into table Centros fields terminated by ',' enclosed by '"' lines terminated by '\r\n' starting by '-';

load data infile 'C_DEPARTAMENTOS.txt' into table Departamentos fields terminated by ',' enclosed by '"' lines terminated by '\r\n' starting by '-';

load data infile 'C_EMPLEADOS.txt' into table Empleados fields terminated by ',' enclosed by '"' lines terminated by '\r\n' starting by '-';
