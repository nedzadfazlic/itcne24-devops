drop table if exists sqlite_sequence;
drop table if exists shirts;
drop table if exists cart;
drop table if exists purchases;
drop table if exists users;

CREATE TABLE sqlite_sequence(name text ,seq integer);
CREATE TABLE IF NOT EXISTS users (
       id integer PRIMARY KEY AUTO_INCREMENT NOT NULL, 
       username text NOT NULL, 
       password text NOT NULL, 
       fname text, 
       lname text, 
       email text);
CREATE TABLE IF NOT EXISTS shirts
(
	id integer not null
		primary key AUTO_INCREMENT,
	samplename text,
	image text,
	price real,
	onSale integer,
	onSalePrice real,
	kind text,
	typeClothes text
);
CREATE TABLE IF NOT EXISTS cart
(
	image text,
	samplename text,
	qty integer,
	price real,
	subTotal real,
	id INTEGER
);
CREATE TABLE IF NOT EXISTS purchases
(
	uid text,
	samplename text,
	image text,
	quantity integer,
	id INTEGER,
	date date default CURRENT_DATE not null
);
INSERT INTO users VALUES(11,'hahahaha','hamza12345','hamza','suhail','testing@hotmail.com');
INSERT INTO shirts VALUES(1,'SAMPLE','sample0.jpg',89.0,1,89.0,'casual','shirt');
INSERT INTO shirts VALUES(2,'SAMPLE1','sample1.jpg',89.0,0,89.0,'formal','shirt');
INSERT INTO shirts VALUES(3,'SAMPLE2','sample2.jpg',79.0,1,69.0,'formal','shirt');
INSERT INTO shirts VALUES(4,'SAMPLE3','sample3.jpg',89.0,0,89.0,'casual','shirt');
INSERT INTO shirts VALUES(5,'SAMPLE4','sample4.jpg',79.0,0,79.0,'casual','shirt');
INSERT INTO shirts VALUES(6,'SAMPLE5','sample5.jpg',79.0,0,79.0,'formal','shirt');
INSERT INTO shirts VALUES(12,'SAMPLESHOE','sampleshoe.jpg',79.0,1,69.0,'casual','shoe');
INSERT INTO shirts VALUES(13,'SAMPLESHOE1','sampleshoe1.jpg',79.0,0,79.0,'casual','shoe');
INSERT INTO shirts VALUES(14,'SAMPLESHOE2','sampleshoe2.jpg',79.0,1,69.0,'casual','shoe');
INSERT INTO shirts VALUES(15,'SAMPLESHOE3','sampleshoe3.jpg',79.0,0,79.0,'casual','shoe');
INSERT INTO shirts VALUES(16,'SAMPLESHOE4','sampleshoe4.jpg',79.0,0,79.0,'formal','shoe');
INSERT INTO shirts VALUES(17,'SAMPLESHOE5','sampleshoe5.jpg',79.0,1,69.0,'casual','shoe');
INSERT INTO shirts VALUES(23,'SAMPLEPANT','samplepant.jpg',79.0,1,59.0,'casual','pant');
INSERT INTO shirts VALUES(24,'SAMPLEPANT1','samplepant1.jpg',79.0,0,79.0,'casual','pant');
INSERT INTO shirts VALUES(25,'SAMPLEPANT2','samplepant2.jpg',79.0,1,69.0,'casual','pant');
INSERT INTO shirts VALUES(26,'SAMPLEPANT3','samplepant3.jpg',59.0,0,59.0,'casual','pant');
INSERT INTO shirts VALUES(27,'SAMPLEPANT4','samplepant4.jpg',69.0,0,69.0,'casual','pant');
INSERT INTO cart VALUES('samplepant.jpg','SAMPLEPANT',1,59.0,59.0,23);
INSERT INTO purchases VALUES('7','Juventus','juv.jpg',1,22,'2018-12-13');
INSERT INTO purchases VALUES('8','Argentina','argentina.png',2,1,'2018-12-13');
INSERT INTO purchases VALUES('8','FC Barcelona','fcb.jpg',1,20,'2018-12-13');
INSERT INTO purchases VALUES('8','FC Barcelona','fcb.jpg',1,20,'2018-12-13');
INSERT INTO purchases VALUES('1','Argentina','argentina.png',1,1,'2018-12-13');
INSERT INTO purchases VALUES('8','Colombia','colombia.jpg',2,9,'2018-12-13');
INSERT INTO purchases VALUES('8','FC Barcelona','fcb.jpg',1,20,'2018-12-13');
INSERT INTO purchases VALUES('8','Belgium','belgium.png',1,8,'2018-12-13');
INSERT INTO purchases VALUES('8','Colombia','colombia.jpg',1,9,'2018-12-13');
INSERT INTO purchases VALUES('10','Argentina','argentina.png',1,1,'2018-12-25');
INSERT INTO purchases VALUES('10','FC Barcelona','fcb.jpg',1,20,'2018-12-25');
INSERT INTO purchases VALUES('11','Brazil','brasil.jpg',1,2,'2020-12-18');
INSERT INTO purchases VALUES('11','SAMPLEPANT','samplepant.jpg',1,23,'2020-12-19');
INSERT INTO sqlite_sequence VALUES('users',11);
INSERT INTO sqlite_sequence VALUES('shirts',27);
