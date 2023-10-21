create database medconnect;
drop database medconnect;
use medconnect;

create table Hospital(
idHospital int primary key auto_increment,
nomeFantasia varchar(45) not null,
CNPJ char(14) not null,
razaoSocial varchar(45) not null,
sigla varchar(45) not null,
responsavelLegal varchar(45) not null,
fkHospitalSede int, constraint fkHospitalSede foreign Key (fkHospitalSede) references Hospital(idHospital)
);

SELECT * FROM Hospital;

create table EscalonamentoFuncionario(
idEscalonamento int primary key auto_increment,
cargo varchar(45) not null,
prioridade int not null
);

create table Funcionarios(
idFuncionarios int auto_increment,
nome varchar(45) not null,
email varchar(45) not null,
CPF varchar(15) not null,
telefone varchar(15) not null,
senha varchar(45) not null,
fkHospital int, constraint fkHospital foreign key (fkHospital) references Hospital(idHospital),
constraint pkCompostaFuncionariosHospital primary key(idFuncionarios, fkHospital),
fkEscalonamento int, constraint fkEscalonamento foreign key (fkEscalonamento) references EscalonamentoFuncionario(idEscalonamento)
);

SELECT * FROM funcionarios;

create table statusRobo(
idStatus int primary key auto_increment,
nome varchar(45) not null
);

create table RoboCirurgiao(
idRobo int primary key auto_increment,
modelo varchar(45) not null,
fabricacao VARCHAR(45) not null,
idProcess VARCHAR(45),
fkStatus int, constraint fkStatus foreign key (fkStatus) references statusRobo(idStatus),
fkHospital INT, 
constraint fkHospitalRobo foreign key (fkHospital) references Hospital(idHospital)
);

SELECT * FROM Funcionarios;

CREATE TABLE associado (
idAssociado INT PRIMARY KEY auto_increment,
email VARCHAR(45),
fkEscalonamentoFuncionario INT,
constraint fkEscalonamentoFunc foreign key (fkEscalonamentoFuncionario) references EscalonamentoFuncionario(idEscalonamento),
fkHospital INT, 
constraint fkHospitalAssociado foreign key (fkHospital) references Hospital(idHospital)
);

create table SalaCirurgiao(
idSala int auto_increment,
numero varchar(5) not null,
fkHospitalSala int, constraint fkHospitalSala foreign key(fkHospitalSala) references hospital(idHospital),
fkRoboSala int, constraint fkRoboSala foreign key(fkRoboSala) references robocirurgiao(idRobo),
constraint pkCompostaSalaCirurgiao primary key(idSala, fkHospitalSala, fkRoboSala)
);

create table categoriaCirurgia (
idCategoria int primary key auto_increment,
niveisPericuloridade varchar(45) not null
);


create table cirurgia (
idCirurgia int not null,
fkRoboCirurgia int, constraint fkRoboCirurgia foreign key (fkRoboCirurgia) references RoboCirurgiao(idRobo),
dataHorario DATETIME not null,
fkCategoria int, constraint fkCategoria foreign key (fkCategoria) references categoriaCirurgia(idCategoria)
);

create table Metrica(
idMetrica INT PRIMARY KEY auto_increment,
alerta DOUBLE,
urgente DOUBLE,
critico DOUBLE,
tipo_dado VARCHAR(50)
);

INSERT INTO metrica (alerta, urgente, critico, tipo_dado) VALUES
(0.60, 0.70, 0.80, "Porcentagem de Uso"),
(0.901, 0.93, 0.95, "Porcentagem de Uso"),
(0.70, 0.80, 0.90, "Porcentagem de Uso");


create table categoriaComponente(
idCategoriaComponente int primary key auto_increment,
nome varchar(45) not null
);

create table componentes(
idComponentes int primary key auto_increment,
nome varchar(45) not null,
unidade varchar(10),
descricaoAdd varchar(45),
fkCategoriaComponente int, constraint fkCategoriaComponente foreign key (fkCategoriaComponente) references categoriaComponente(idCategoriaComponente),
fkMetrica INT, 
constraint frkMetrica foreign key (fkMetrica) references Metrica(idMetrica)
);

INSERT INTO categoriaComponente VALUES
(1, "CPU"),
(2, "Memória RAM"),
(3, "Disco"),
(4, "Rede");


INSERT INTO componentes (nome, unidade, fkCategoriaComponente, fkMetrica) 
VALUES ('Porcentagem da CPU', "%", 1, 1),
("Velocidade da CPU", "GHz", 1, null),
("Tempo no sistema da CPU", "s", 1, null),
("Processos da CPU", null, 1, null);

SELECT * FROM componentes;
-- Inserir Memória RAM
INSERT INTO componentes (nome, unidade, fkCategoriaComponente, fkMetrica) 
VALUES ('Porcentagem da Memoria', '%', 2, 2),
('Total da Memoria', 'GB', 2, null),
('Uso da Memoria', 'GB', 2, null),
('Porcentagem da Memoria Swap', '%',2,null);
TRUNCATE TABLE componentes;

-- Inserir Disco
INSERT INTO componentes (nome, unidade, fkCategoriaComponente, fkMetrica) 
VALUES ('Porcentagem do Disco', '%', 3, 3);

-- Inserir Rede
INSERT INTO componentes (nome, descricaoAdd, fkCategoriaComponente) 
VALUES ('Rede', 'Conexao da Rede', 4);

create table Registros (
idRegistro int auto_increment,
fkRoboRegistro int , 
constraint fkRoboRegistro foreign key (fkRoboRegistro) references  RoboCirurgiao(idRobo),
constraint pkCompostaRegistro primary key(idRegistro, fkRoboRegistro),
HorarioDado datetime not null,
dado Double not null,
fkComponente int, 
constraint fkComponente foreign key (fkComponente) references componentes(idComponentes)
);

create table Alerta(
idAlerta INT PRIMARY KEY auto_increment,
tipo_alerta VARCHAR(15),
fkRegistro INT,
constraint frkRegistro foreign key (fkRegistro) references Registros(idRegistro),
fkRobo INT,
constraint frkRobo foreign key (fkRobo) references Registros(fkRoboRegistro)
);

INSERT INTO Registros VALUES 
(null, 1, now(), 0.98, 1),
(null, 1, now(), 0.6, 1),
(null, 1, now(), 0.7, 1);

SELECT * FROM RoboCirurgiao;
SELECT * FROM Alerta;
SELECT * FROM Metrica;
TRUNCATE TABLE Alerta;

DROP TRIGGER criarAlerta;
DELIMITER //
CREATE TRIGGER criarAlerta
AFTER INSERT ON Registros
FOR EACH ROW 
BEGIN
DECLARE id_metrica INT;
    DECLARE v_alerta DOUBLE;
    DECLARE v_urgente DOUBLE;
    DECLARE v_critico DOUBLE;
    
    SELECT fkMetrica FROM componentes 
    WHERE NEW.fkComponente = idComponentes
    INTO id_metrica;
    
    
    SELECT alerta, urgente, critico
    INTO v_alerta, v_urgente, v_critico
    FROM Metrica
    WHERE idMetrica = id_metrica;
    
     IF NEW.dado >= v_critico THEN
        INSERT INTO Alerta (tipo_alerta, fkRegistro, fkRobo)
        VALUES ("critico", NEW.idRegistro, NEW.fkRoboRegistro);
     ELSEIF NEW.dado >= v_urgente THEN
        INSERT INTO Alerta (tipo_alerta, fkRegistro, fkRobo)
        VALUES ("urgente", NEW.idRegistro, NEW.fkRoboRegistro);
	 ELSEIF NEW.dado >= v_alerta THEN
        INSERT INTO Alerta (tipo_alerta, fkRegistro, fkRobo)
        VALUES ("alerta", NEW.idRegistro, NEW.fkRoboRegistro);
     END IF;
	   
END;
//
DELIMITER ;


INSERT INTO Hospital (nomeFantasia, CNPJ, razaoSocial, sigla, responsavelLegal, fkHospitalSede) 
VALUES ('Hospital ABC', '12345678901234', 'ABC Ltda', 'HABC', 'João da Silva', NULL);

INSERT INTO Hospital (nomeFantasia, CNPJ, razaoSocial, sigla, responsavelLegal, fkHospitalSede) 
VALUES ('Hospital Eistein', '12325678901234', 'Eistein Ltda', 'HABC', 'João da Silva', NULL);

INSERT INTO EscalonamentoFuncionario (cargo, prioridade) 
VALUES ('Atendente', 1);

INSERT INTO EscalonamentoFuncionario (cargo, prioridade) 
VALUES ('Engenheiro De Noc', 2);

INSERT INTO EscalonamentoFuncionario (cargo, prioridade) 
VALUES ('Admin', 3);

SELECT * FROM escalonamentoFuncionario;

INSERT INTO Funcionarios (nome, email, CPF, telefone, senha, fkHospital, fkEscalonamento) 
VALUES ('Kayky', 'kayky@abc.com', '12345678901', '987654321', '123456', 1, 1),
('Gabriel', 'gabriel@email.com', '12345678901', '987654321', '123456', 1, 2),
('Maria Souza', 'maria@example.com', '12345678901', '987654321', 'senha123', 1, 3);

SELECT * FROM Funcionarios;
SELECT * FROM associado;

INSERT INTO associado VALUES (null, "erick@email.com", 1, 1);

INSERT INTO statusRobo (nome) 
VALUES ('Ativo');


INSERT INTO RoboCirurgiao (modelo, fabricacao, fkStatus, fkHospital, idProcess) 
VALUES ('Modelo A', '2023-09-12', 1,1, "B2532B6");

select * from RoboCirurgiao;
INSERT INTO SalaCirurgiao (numero, fkHospitalSala, fkRoboSala) 
VALUES ('101', 1, 1);

INSERT INTO categoriaCirurgia (niveisPericuloridade) 
VALUES ('Alto');

INSERT INTO cirurgia (idCirurgia, fkRoboCirurgia, dataHorario, fkCategoria) 
VALUES (1, 1, '2023-09-15 14:00:00', 1);

INSERT INTO registros VALUES (NULL, 1, "2024-10-15 21:00:02", 10, 1);
INSERT INTO registros VALUES (NULL, 1, "2024-10-15 21:00:02", 20, 1);

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE c.nome = 'Rede';

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
JOIN categoriacomponente t on c.fkCategoriaComponente = t.idCategoriaComponente
WHERE t.idCategoriaComponente = 1;

SELECT r.*
        FROM Registros r
        JOIN componentes c ON r.fkComponente = c.idComponentes
        JOIN categoriacomponente t on c.fkCategoriaComponente = t.idCategoriaComponente
        WHERE t.idCategoriaComponente = 1
        AND r.fkRoboRegistro = 1
                    order by r.idRegistro desc limit 7;

TRUNCATE TABLE Registros;

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
 JOIN categoriacomponente t on c.fkCategoriaComponente = t.idCategoriaComponente
        WHERE t.idCategoriaComponente = 2;


SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
 JOIN categoriacomponente t on c.fkCategoriaComponente = t.idCategoriaComponente
        WHERE t.idCategoriaComponente = 3;

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes;

SELECT r.idRegistro, r.HorarioDado, r.dado, c.nome
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
 JOIN categoriacomponente t on c.fkCategoriaComponente = t.idCategoriaComponente;

SELECT r.idRegistro, r.HorarioDado, r.dado, c.nome
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
LIMIT 7;

-- SELECT COM TABELA TEMPORÁRIA PARA PEGAR OS ÚLTIMOS 7 REGISTROS DE CADA COMPONENTE

WITH LinhasComponentes AS (
  SELECT
    r.idRegistro,
    DATE_FORMAT(r.HorarioDado, '%d/%m/%Y') AS HorarioFormatado,
    r.dado,
    t.idCategoriaComponente AS categoriaComponente,
    ROW_NUMBER() OVER (PARTITION BY c.nome ORDER BY r.idRegistro DESC) AS linha_num
  FROM Registros r
  JOIN componentes c ON r.fkComponente = c.idComponentes
   JOIN categoriacomponente t on c.fkCategoriaComponente = t.idCategoriaComponente
  WHERE r.fkRoboRegistro = 1
)
SELECT
  idRegistro,
  HorarioFormatado,
  dado,
  categoriaComponente
FROM LinhasComponentes WHERE linha_num <= 7;

WITH LinhasComponentes AS (
  SELECT
    r.idRegistro,
    DATE_FORMAT(r.HorarioDado, '%d/%m/%Y') AS HorarioFormatado,
    r.dado,
    c.nome AS nomeComponente,
    ROW_NUMBER() OVER (PARTITION BY c.nome ORDER BY r.idRegistro DESC) AS linha_num
  FROM Registros r
  JOIN componentes c ON r.fkComponente = c.idComponentes
  WHERE r.fkRoboRegistro = 1
)
SELECT
  idRegistro,
  HorarioFormatado,
  dado,
  nomeComponente
FROM LinhasComponentes WHERE linha_num <= 7;

-- dados de Dia Opcao 1
WITH LinhasComponentes AS (
  SELECT
    r.HorarioDado,
    r.dado,
    c.nome AS nomeComponente
  FROM Registros r
  JOIN componentes c ON r.fkComponente = c.idComponentes
  WHERE r.fkRoboRegistro = 1
    AND HorarioDado >= NOW() - INTERVAL 24 HOUR
)
SELECT
  DATE_FORMAT(HorarioDado, '%d/%m/%Y %H') as HorarioFormatado,
  round(AVG(dado),2) AS media_dado,
  nomeComponente
FROM LinhasComponentes
GROUP BY DATE_FORMAT(HorarioDado, '%d/%m/%Y %H'), nomeComponente;

-- dados de Dia Opcao 2
SELECT
  DATE_FORMAT(HorarioDado, '%d/%m/%Y %H') as HorarioFormatado,
  round(AVG(dado),2) AS media_dado,
  c.nome AS nomeComponente
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE r.fkRoboRegistro = 1
AND HorarioDado >= NOW() - INTERVAL 24 HOUR AND HorarioDado <= NOW()
GROUP BY DATE_FORMAT(HorarioDado, '%d/%m/%Y %H'), nomeComponente
ORDER BY HorarioFormatado;

-- dados de Mes Opcao 1
SELECT
  DATE_FORMAT(HorarioDado, '%d/%m/%Y') as HorarioFormatado,
  round(AVG(dado),2) AS media_dado,
  c.nome AS nomeComponente
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE r.fkRoboRegistro = 1
AND HorarioDado >= NOW() - INTERVAL 30 DAY AND HorarioDado <= NOW()
GROUP BY DATE_FORMAT(HorarioDado, '%d/%m/%Y'), nomeComponente
ORDER BY HorarioFormatado  
LIMIT 90;

-- dados de Ano Opcao 1
SELECT
  DATE_FORMAT(HorarioDado, '%m/%Y') as HorarioFormatado,
  round(AVG(dado),2) AS dado,
  c.nome AS nomeComponente
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE r.fkRoboRegistro = 1
AND HorarioDado >= NOW() - INTERVAL 1 YEAR AND HorarioDado <= NOW()
GROUP BY DATE_FORMAT(HorarioDado, '%m/%Y'), nomeComponente
ORDER BY HorarioFormatado  
LIMIT 36;

INSERT INTO Registros VALUES(NULL, 1, "2023-11-21 21:56:02", 20.5, 1);




  
