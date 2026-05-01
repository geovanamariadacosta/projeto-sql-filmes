-- Cria o banco
CREATE DATABASE db_filmes
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

-- Usa o banco
USE db_filmes;

-- Cria a tabela de gêneros (ação, comédia, etc)
CREATE TABLE Generos (
  id_genero INT AUTO_INCREMENT PRIMARY KEY,
  nome_genero VARCHAR(40) NOT NULL
);

-- Cria a tabela principal dos filmes
CREATE TABLE Filmes (
  id_filme INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(150) NOT NULL,
  ano INT,
  duracao_min INT,
  id_genero INT,
  sinopse TEXT,
  FOREIGN KEY (id_genero) REFERENCES Generos(id_genero)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Cria a tabela dos atores
CREATE TABLE Atores (
  id_ator INT AUTO_INCREMENT PRIMARY KEY,
  nome_ator VARCHAR(120) NOT NULL,
  data_nasc DATE,
  nacionalidade VARCHAR(50)
);

-- Cria a tabela que liga os filmes e atores (elenco)
CREATE TABLE Elenco (
  id_filme INT NOT NULL,
  id_ator INT NOT NULL,
  papel VARCHAR(100),
  PRIMARY KEY (id_filme, id_ator),
  FOREIGN KEY (id_filme) REFERENCES Filmes(id_filme)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_ator) REFERENCES Atores(id_ator)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insere alguns gêneros
INSERT INTO Generos (nome_genero) VALUES
('Ação'),
('Comédia'),
('Drama'),
('Ficção Científica'),
('Terror');

-- Insere alguns filmes
INSERT INTO Filmes (titulo, ano, duracao_min, id_genero, sinopse) VALUES
('Vingadores: Ultimato', 2019, 181, 1, 'Os heróis se unem para reverter o estalo de Thanos.'),
('Homem-Aranha: Sem Volta Para Casa', 2021, 148, 1, 'Peter pede ajuda ao Doutor Estranho e causa um caos multiversal.'),
('Interestelar', 2014, 169, 4, 'Um grupo de astronautas tenta salvar a humanidade através de um buraco de minhoca.'),
('Corra!', 2017, 104, 5, 'Um suspense psicológico sobre racismo e manipulação.'),
('O Lobo de Wall Street', 2013, 180, 2, 'A história real de um corretor que enriqueceu com fraudes.'),
('Titanic', 1997, 195, 3, 'Um romance trágico a bordo do navio mais famoso do mundo.'),
('It: A Coisa', 2017, 135, 5, 'Um grupo de amigos enfrenta um palhaço demoníaco.'),
('Pantera Negra', 2018, 134, 1, 'T’Challa retorna a Wakanda para assumir o trono.'),
('Oppenheimer', 2023, 180, 3, 'A história do criador da bomba atômica.'),
('A Chegada', 2016, 116, 4, 'Uma linguista tenta se comunicar com alienígenas.'),
('Clube da Luta', 1999, 139, 3, 'Um homem cria um clube secreto de luta.'),
('Divertida Mente', 2015, 95, 2, 'As emoções de uma garota ganham vida dentro da sua mente.'),
('Matrix', 1999, 136, 4, 'Um hacker descobre que o mundo é uma simulação.'),
('A Freira', 2018, 96, 5, 'Um padre e uma noviça enfrentam uma entidade demoníaca.'),
('Os Caça-Fantasmas', 1984, 105, 2, 'Um grupo de cientistas caça fantasmas em Nova York.');

-- Insere alguns atores
INSERT INTO Atores (nome_ator, data_nasc, nacionalidade) VALUES
('Leonardo DiCaprio', '1974-11-11', 'Americano'),
('Scarlett Johansson', '1984-11-22', 'Americana'),
('Matthew McConaughey', '1969-11-04', 'Americano'),
('Daniel Kaluuya', '1989-02-24', 'Britânico'),
('Tom Holland', '1996-06-01', 'Britânico'),
('Chadwick Boseman', '1976-11-29', 'Americano'),
('Keanu Reeves', '1964-09-02', 'Canadense'),
('Amy Adams', '1974-08-20', 'Americana');

-- Liga os atores aos filmes (elenco)
INSERT INTO Elenco (id_filme, id_ator, papel) VALUES
(1, 2, 'Viúva Negra'),
(1, 5, 'Homem-Aranha'),
(2, 5, 'Peter Parker'),
(3, 3, 'Cooper'),
(4, 4, 'Chris'),
(5, 1, 'Jordan Belfort'),
(6, 1, 'Jack Dawson'),
(7, 4, 'Mike Hanlon'),
(8, 6, 'Pantera Negra'),
(9, 3, 'Oppenheimer'),
(10, 8, 'Louise Banks'),
(11, 1, 'Narrador'),
(12, 8, 'Alegria'),
(13, 7, 'Neo'),
(14, 4, 'Padre Burke'),
(15, 7, 'Caça-Fantasma');

-- Testes
- 1) Ver todos os filmes (tabela Filmes)
SELECT * FROM Filmes;

-- 2) Mostrar filmes com o nome do gênero (mostra FILMES mesmo sem gênero)
SELECT Filmes.id_filme, Filmes.titulo, Generos.nome_genero
FROM Filmes
LEFT JOIN Generos ON Filmes.id_genero = Generos.id_genero
ORDER BY Filmes.id_filme;

-- 3) Mostrar o elenco: qual ator está em qual filme e qual papel
SELECT Filmes.titulo, Atores.nome_ator, Elenco.papel
FROM Elenco
JOIN Filmes ON Elenco.id_filme = Filmes.id_filme
JOIN Atores ON Elenco.id_ator = Atores.id_ator
ORDER BY Filmes.titulo, Atores.nome_ator;

-- 4) Quantos filmes tem por gênero (contagem) — inclui gêneros sem filmes
SELECT Generos.nome_genero, COUNT(Filmes.id_filme) AS total_filmes
FROM Generos
LEFT JOIN Filmes ON Filmes.id_genero = Generos.id_genero
GROUP BY Generos.id_genero, Generos.nome_genero
ORDER BY total_filmes DESC;

-- 5) Filme(s) mais longo(s)
SELECT titulo, duracao_min
FROM Filmes
WHERE duracao_min = (SELECT MAX(duracao_min) FROM Filmes);