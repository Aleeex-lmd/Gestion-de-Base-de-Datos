create table modelos
(
	codigo VARCHAR2(8),
	constructor VARCHAR2(10),
	asientos NUMBER(3) not null,
	pesomaximo NUMBER(2),
	autonomia NUMBER(4),
	constraint pk_modelos primary key(codigo),
	constraint constructorok check(constructor in ('Boeing','Airbus'))
);

create table aviones
(
	matricula VARCHAR2(7),
	codmodelo VARCHAR2(8),
	anyofab NUMBER(4),
	fechaadquisicion DATE,
	fechaultimarevision DATE,
	constraint pk_aviones primary key(matricula),
	constraint fk_modelos foreign key (codmodelo) references modelos(codigo),
	constraint anyook check (anyofab>2010)
);

create table rutas
(
	codigo VARCHAR2(4),
	numkilometros NUMBER(4) not null,
	aeropuertoorigen VARCHAR2(3) not null,
	aeropuertodestino VARCHAR2(3) not null,
	preciobillete NUMBER(5,2),
	costeestimadovuelo NUMBER(8,2),
	minutosvuelo NUMBER(4),
	constraint pk_rutas primary key(codigo)
);

create table vuelos
(
	codruta VARCHAR2(4),
	matricula VARCHAR2(7),
	aerolinea VARCHAR2(2),
	fechahorasalida DATE,
	numbilletesvendidos NUMBER(3) default 0,
	terminalsalida VARCHAR2(2),
	terminalllegada VARCHAR2(2),
	constraint pk_vuelos primary key(codruta, aerolinea,fechahorasalida),
	constraint fk_rutas foreign key(codruta) references rutas(codigo),
	constraint fk_aviones foreign key (matricula) references aviones(matricula)
);
// Aviones
// Revisar el formato de fecha para que se ajuste a vuestro SGBD

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-AAA','A318',2018,to_date('09/08/18','DD/MM/YY'),to_date('09/06/20','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-ABB','A319',2017,to_date('10/08/18','DD/MM/YY'),to_date('09/03/20','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-ABC','A320',2018,to_date('11/08/18','DD/MM/YY'),to_date('09/02/20','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-ABD','B737-600',2017,to_date('12/08/18','DD/MM/YY'),to_date('09/04/20','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-ABE','A320neo',2016,to_date('13/08/18','DD/MM/YY'),to_date('09/01/20','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-ABF','A319',2018,to_date('14/08/18','DD/MM/YY'),to_date('09/05/20','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-BBB','A321',2017,to_date('15/08/18','DD/MM/YY'),to_date('09/11/19','DD/MM/YY'));

insert into aviones (matricula, codmodelo, anyofab, fechaadquisicion, fechaultimarevision) values('EC-CCC','A320',2018,to_date('16/08/18','DD/MM/YY'),to_date('09/12/19','DD/MM/YY'));


// Modelos

insert into modelos (codigo, constructor, asientos, pesomaximo, autonomia) values('A318','Airbus',107,68,3110);

insert into modelos (codigo, constructor, asientos, pesomaximo, autonomia) values('A319','Airbus',124,75,3750);

insert into modelos (codigo, constructor, asientos, pesomaximo, autonomia)  values('A320','Airbus',150,78,3300);

insert into modelos (codigo, constructor, asientos, pesomaximo, autonomia) values('A321','Airbus',185,93,3220);

insert into modelos (codigo, constructor, asientos, pesomaximo, autonomia) values('A320neo','Airbus',165,79,3500);

insert into modelos (codigo, constructor, asientos, pesomaximo, autonomia) values('B737-600','Boeing',130,65,3400);


// Rutas

insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A01',540,'SVQ','MAD',68.9,790.40,126);

insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A02',936,'SVQ','PMI',93,950.90,135);

insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A03',540,'MAD','SVQ',76,800,130);

insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A04',633,'MAD','PMI',151,987.60,100);

insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A05',2214,'MAD','ACE',123.4,1224,375);

insert into rutas (codigo, numkilometros, aeropuertoorigen, aeropuertodestino, preciobillete, costeestimadovuelo, minutosvuelo) values('A06',8056,'MAD','CHN',12.1,9276,567);

// Vuelos
// Revisar el formato de fecha y hora para que se ajuste a vuestro SGBD

// Añadido

insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A06','EC-AAA','IB', to_date('28/02/22 05:00','DD/MM/YY HH24:MI'),9,'T1','T1');


// Sevilla-Madrid

insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A01','EC-AAA','IB', to_date('17/06/20 09:00','DD/MM/YY HH24:MI'),100,'T1','T1');

insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A01','EC-ABC','FR',to_date('17/06/20 12:00','DD/MM/YY HH24:MI'),110,'T1','T1');


// Sevilla-Palma de Mallorca

insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A02','EC-ABB','IB',to_date('16/06/20 09:30','DD/MM/YY HH24:MI'),107,'T1','T2');


/// Madrid-Sevilla

insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A03','EC-ABD','FR', to_date('17/06/20 08:45','DD/MM/YY HH24:MI'),135,'T5','T1');

insert into vuelos (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A03','EC-ABE','IB', to_date('17/06/20 20:45','DD/MM/YY HH24:MI'),125,'T5','T1');


// Madrid-Palma de Mallorca

insert into vuelos  (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A04','EC-ABD','FR',to_date('18/06/20 08:45','DD/MM/YY HH24:MI'),131,'T3','T2');

insert into vuelos  (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A04','EC-ABE','IB',to_date('18/06/20 20:45','DD/MM/YY HH24:MI'),130,'T3','T2');


// Madrid-Lanzarote

insert into vuelos  (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada)  values('A05','EC-BBB','IB',to_date('14/06/20 09:30','DD/MM/YY HH24:MI'),175,'T4','T3');

insert into vuelos  (codruta, matricula, aerolinea, fechahorasalida, numbilletesvendidos, terminalsalida, terminalllegada) values('A05','EC-CCC','FR',to_date('14/06/204 12:30','DD/MM/YY HH24:MI'),160,'T4','T3');

