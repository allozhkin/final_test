DROP DATABASE IF EXISTS Human_friends;
CREATE DATABASE Human_friends;

USE Human_friends;

ALTER DATABASE Human_friends CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS Types_animals;
CREATE TABLE Types_animals (
	id_type INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   	type_animals VARCHAR(120)
);

INSERT INTO Types_animals(id_type, type_animals) VALUES 
('1', 'домашнее животное'), 
('2', 'вьючное животное');


DROP TABLE IF EXISTS Cats;
CREATE TABLE Cats (
	id_animal INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_id INT UNSIGNED NOT NULL,
   	name VARCHAR(50),
   	command TEXT,
   	birth_date DATE,
   	FOREIGN KEY (type_id) REFERENCES Types_animals(id_type)
);

INSERT INTO Cats (id_animal, type_id, name, command, birth_date) VALUES
('1', '1','Барсик', 'подать лапу, голос', '2020-08-01'),
('2', '1', 'Макс', 'прыжок, сидеть', '2015-06-10');

DROP TABLE IF EXISTS Dogs;
CREATE TABLE Dogs (
	id_animal INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_id INT UNSIGNED NOT NULL,
   	name VARCHAR(50),
   	command TEXT,
   	birth_date DATE,
   	FOREIGN KEY (type_id) REFERENCES Types_animals(id_type)
);

INSERT INTO Dogs (id_animal, type_id, name, command, birth_date) VALUES
('1', '1','Мухтар', 'подать лапу, сидеть, лежать, фас', '2010-07-23'),
('2', '1', 'Джек', 'лежать, сидеть', '2021-05-11');

DROP TABLE IF EXISTS Hamsters;
CREATE TABLE Hamsters (
	id_animal INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_id INT UNSIGNED NOT NULL,
   	name VARCHAR(50),
   	command TEXT,
   	birth_date DATE,
   	FOREIGN KEY (type_id) REFERENCES Types_animals(id_type)
);

INSERT INTO Hamsters (id_animal, type_id, name, command, birth_date) VALUES
('1', '1', 'Хома', 'бегать, вставать на задние лапки', '2022-10-01'),
('2', '1', 'Луша', 'не обучен', '2023-01-13');

DROP TABLE IF EXISTS Horses;
CREATE TABLE Horses (
	id_animal INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_id INT UNSIGNED NOT NULL,
   	name VARCHAR(50),
   	command TEXT,
   	birth_date DATE,
   	FOREIGN KEY (type_id) REFERENCES Types_animals(id_type)
);

INSERT INTO Horses (id_animal, type_id, name, command, birth_date) VALUES
('1', '2','Марго', 'вперед, стой, шагом, рысь, хоп', '2017-08-01'),
('2', '2','Ричард', 'вперед, стой, шагом, рысь, хоп', '2015-10-24');

DROP TABLE IF EXISTS Camels;
CREATE TABLE Camels (
	id_animal INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_id INT UNSIGNED NOT NULL,
   	name VARCHAR(50),
   	command TEXT,
   	birth_date DATE,
   	FOREIGN KEY (type_id) REFERENCES Types_animals(id_type)
);

INSERT INTO Camels (id_animal, type_id, name, command, birth_date) VALUES
('1', '2','Бил', 'стоять, иди, вперед', '2010-09-01');


DROP TABLE IF EXISTS Donkeys;
CREATE TABLE Donkeys (
	id_animal INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type_id INT UNSIGNED NOT NULL,
   	name VARCHAR(50),
   	command TEXT,
   	birth_date DATE,
   	FOREIGN KEY (type_id) REFERENCES Types_animals(id_type)
);

INSERT INTO Donkeys (id_animal, type_id, name, command, birth_date) VALUES
('1', '2','Иа', 'вперед, стой', '2013-07-11'),
('2', '2','Ранч', 'вперед, стой', '2012-10-28');

DELETE FROM Camels; -- удалили верблюдов

-- Объеденение лошадей и ослов в одну таблицу
SELECT id_animal, 'лошадь' AS kind_animals, type_id, name, command, birth_date
FROM horses
UNION ALL
SELECT id_animal, 'осёл' AS kind_animals, type_id, name, command, birth_date
FROM Donkeys;

DROP VIEW IF EXISTS Animals;
CREATE VIEW Animals AS SELECT id_type, type_animals, kind_animals, id_animal, name, command, birth_date 
FROM (
	SELECT ta.id_type, ta.type_animals, 'кошка' AS kind_animals, c.id_animal, c.name, c.command, c.birth_date
	FROM types_animals ta
	JOIN cats c ON ta.id_type = c.type_id
	
	UNION ALL
	
	SELECT ta.id_type, ta.type_animals,'собака' AS kind_animals, d.id_animal, d.name, d.command, d.birth_date 
	FROM types_animals ta
	JOIN dogs d ON ta.id_type = d.type_id
	
	UNION ALL
	SELECT ta.id_type, ta.type_animals,'хомяк' AS kind_animals, h.id_animal, h.name, command, h.birth_date 
	FROM types_animals ta
	JOIN hamsters h ON ta.id_type = h.type_id
	
	UNION ALL
	
	SELECT ta.id_type, ta.type_animals,'лошадь' AS kind_animals, hor.id_animal, hor.name, hor.command, hor.birth_date 
	FROM types_animals ta
	JOIN horses hor ON ta.id_type = hor.type_id
	
	UNION ALL
	
	SELECT ta.id_type, ta.type_animals,'верблюд' AS kind_animals, cam.id_animal, cam.name, cam.command, cam.birth_date 
	FROM types_animals ta
	JOIN camels cam ON ta.id_type = cam.type_id
	
	UNION ALL
	
	SELECT ta.id_type, ta.type_animals,'осёл' AS kind_animals, don.id_animal, don.name, don.command, don.birth_date 
	FROM types_animals ta
	JOIN donkeys don ON ta.id_type = don.type_id
) all_animals;

-- SELECT * FROM Animals;


DROP VIEW IF EXISTS pets;
CREATE VIEW pets AS (
SELECT 
	id_type, type_animals, kind_animals, 
	id_animal, name, command, birth_date  
FROM animals
WHERE id_type = 1
);

DROP VIEW IF EXISTS pack_animals;
CREATE VIEW pack_animals AS (
SELECT 
	id_type, type_animals, kind_animals, 
	id_animal, name, command, birth_date  
FROM animals
WHERE id_type = 2
);


DROP VIEW IF EXISTS young_animals;
CREATE VIEW young_animals AS (
SELECT 
	id_type, type_animals, kind_animals, 
	id_animal, name, command, birth_date, 
	TIMESTAMPDIFF(MONTH, birth_date, NOW()) AS age  
FROM animals
WHERE TIMESTAMPDIFF(MONTH, birth_date, NOW()) > 12 AND TIMESTAMPDIFF(MONTH, birth_date, NOW()) < 37
);

-- SELECT * FROM young_animals;