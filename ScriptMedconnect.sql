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

create table statusRobo(
idStatus int primary key auto_increment,
nome varchar(45) not null
);

create table RoboCirurgiao(
idRobo int primary key auto_increment,
modelo varchar(45) not null,
fabricacao varchar(45) not null,
fkStatus int, constraint fkStatus foreign key (fkStatus) references statusRobo(idStatus)
);

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

create table componentes(
idComponentes int primary key auto_increment,
nome varchar(45) not null,
modelo varchar(45) not null,
identificacaoComponente varchar(60) not null,
descricaoAdd varchar(45)
);

INSERT INTO componentes (nome, modelo, identificacaoComponente) 
VALUES ('CPU', 'Modelo da CPU', 'ID da CPU');

-- Inserir Memória RAM
INSERT INTO componentes (nome, modelo, identificacaoComponente) 
VALUES ('Memória RAM', 'Modelo da RAM', 'ID da RAM');

-- Inserir Disco
INSERT INTO componentes (nome, modelo, identificacaoComponente) 
VALUES ('Disco', 'Modelo do Disco', 'ID do Disco');

-- Inserir Rede
INSERT INTO componentes (nome, modelo, identificacaoComponente) 
VALUES ('Rede', 'Modelo da Rede', 'ID da Rede');

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
VALUES ('Kayky', 'kayky@abc.com', '123.456.789-01', '987654321', '123456', 1, 1);

INSERT INTO Funcionarios (nome, email, CPF, telefone, senha, fkHospital, fkEscalonamento) 
VALUES ('Danilo', 'daniloo@email.com', '125.456.789-01', '987654321', '123456', 1, 2);

INSERT INTO Funcionarios (nome, email, CPF, telefone, senha, fkHospital, fkEscalonamento) 
VALUES ('Maria Souza', 'maria@example.com', '123.456.789-01', '987654321', 'senha123', 1, 3);

INSERT INTO associado VALUES (null, "erick@email.com", 1, 1);

SELECT * FROM Funcionarios;
SELECT * FROM associado;a

SELECT * FROM Funcionarios f 
JOIN EscalonamentoFuncionario e ON f.fkEscalonamento = e.idEscalonamento
WHERE f.email = 'erick@email.com' AND f.senha = '123456';

INSERT INTO statusRobo (nome) 
VALUES ('Ativo');


INSERT INTO RoboCirurgiao (modelo, fabricacao, fkStatus) 
VALUES ('Modelo A', '2023-09-12', 1);


INSERT INTO SalaCirurgiao (numero, fkHospitalSala, fkRoboSala) 
VALUES ('101', 1, 1);


INSERT INTO categoriaCirurgia (niveisPericuloridade) 
VALUES ('Alto');


INSERT INTO cirurgia (idCirurgia, fkRoboCirurgia, dataHorario, fkCategoria) 
VALUES (1, 1, '2023-09-15 14:00:00', 1);

select*from registros;

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE c.nome = 'Rede';

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE c.nome = 'cpu';

SELECT r.*
        FROM Registros r
        JOIN componentes c ON r.fkComponente = c.idComponentes
        WHERE c.nome = 'cpu'
        AND r.fkRoboRegistro = 1
                    order by r.idRegistro desc limit 7;

TRUNCATE TABLE Registros;

SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE c.nome = 'memoria RAM';


SELECT r.*
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes
WHERE c.nome = 'disco';

SELECT r.idRegistro, r.HorarioDado, r.dado, c.nome
FROM Registros r
JOIN componentes c ON r.fkComponente = c.idComponentes;
