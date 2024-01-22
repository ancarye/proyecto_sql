
-- se escoge la base de datos con la que se trabajara la cual es una base relacionada a los jugadores y estadisticas de la NBA
USE nba;

-- Se ve como se conforma cada tabla de la base de datos para poder definir la llave primaria
show tables;

describe games;
describe players;
describe games_details;
describe teams;
describe ranking;

-- se ajusta los valores de algunas tablas para que pasen de text a vachar o valores de texto a año

alter table games change column GAME_STATUS_TEXT GAME_STATUS_TEXT VARCHAR(50);
alter table games_details change column TEAM_ABBREVIATION TEAM_ABBREVIATION VARCHAR(5);
alter table games_details change column TEAM_CITY TEAM_CITY VARCHAR(30);
alter table games_details change column PLAYER_NAME PLAYER_NAME VARCHAR(50);
alter table games_details change column NICKNAME NICKNAME VARCHAR(50);
alter table games_details change column START_POSITION START_POSITION VARCHAR(5);
alter table games_details change column COMMENT COMMENT VARCHAR(50);
alter table players change column PLAYER_NAME PLAYER_NAME varchar(50);
alter table ranking change column LEAGUE_ID LEAGUE_ID varchar(50);
alter table ranking change column STANDINGSDATE STANDINGSDATE date;
alter table ranking change column CONFERENCE CONFERENCE varchar(30);
alter table ranking change column TEAM TEAM varchar(30);
alter table ranking change column HOME_RECORD HOME_RECORD varchar(10);
alter table ranking change column ROAD_RECORD ROAD_RECORD varchar(15);
alter table ranking change column ROAD_RECORD ROAD_RECORD varchar(15);
alter table ranking change column RETURNTOPLAY RETURNTOPLAY varchar(15);
alter table teams change column MIN_YEAR MIN_YEAR year;
alter table teams change column MAX_YEAR MAX_YEAR year;
alter table teams change column ABBREVIATION ABBREVIATION VARCHAR(25);
alter table teams change column NICKNAME NICKNAME VARCHAR(25);
alter table teams change column YEARFOUNDED YEARFOUNDED year;
alter table teams change column CITY CITY VARCHAR(30);
alter table teams change column ARENA ARENA VARCHAR(100);
alter table teams change column ARENACAPACITY ARENACAPACITY VARCHAR(10);
alter table teams change column OWNER OWNER VARCHAR(60);
alter table teams change column GENERALMANAGER GENERALMANAGER VARCHAR(80);
alter table teams change column HEADCOACH HEADCOACH VARCHAR(80);
alter table teams change column DLEAGUEAFFILIATION DLEAGUEAFFILIATION VARCHAR(80);

-- se define de gameId es la llave primaria y llaves foraneas
ALTER TABLE games
ADD PRIMARY KEY (GAME_ID);

-- no se pudo definir esta llave primaria por que vienen datos duplicados ya que se separa a cada jugador por temporada y por ende 
-- se duplica el PLAYER_ID
ALTER TABLE players
ADD PRIMARY KEY (PLAYER_ID);

-- se agrega la llave primaria en la tabla teams sobre la columna TEAM_ID
ALTER TABLE teams
ADD PRIMARY KEY (TEAM_ID);

-- se agregan las llaves foraneas que se identificaron 
ALTER TABLE games
ADD FOREIGN KEY (TEAM_ID_home) REFERENCES teams(TEAM_ID);

ALTER TABLE games
ADD FOREIGN KEY (TEAM_ID_away) REFERENCES teams(TEAM_ID);

ALTER TABLE games_details
ADD FOREIGN KEY (TEAM_ID) REFERENCES teams(TEAM_ID);

ALTER TABLE players
ADD FOREIGN KEY (TEAM_ID) REFERENCES teams(TEAM_ID);


ALTER TABLE ranking
ADD FOREIGN KEY (TEAM_ID) REFERENCES teams(TEAM_ID);


-- se hacen consultas basicas
select * from games;

-- se hace una busqueda de la suma de las anotaciones realizadas por los equipos de casa por cada partido de la temporada
-- agrupado por el TEAM_ID_home y ordenados por temporadas de manera ascendente.
SELECT TEAM_ID_home,SEASON,SUM(PTS_home) AS anotaciones_totales
from games GROUP BY TEAM_ID_home,SEASON ORDER BY SEASON ASC;

-- De la tabla games_details se busca a los 20 jugadores con mas anotaciones y se ordenan de manera descendente.
select PLAYER_NAME, SUM(PTS) AS TOTAL_PUNTOS
FROM games_details GROUP BY PLAYER_NAME 
ORDER BY TOTAL_PUNTOS DESC limit 20;

-- Se buscan los partidos por temporada donde los puntos de casa sean menores o iguales a 70 y que los puntos de visitantes sean mayotres o iguales a 100
select game_ID  as PARTIDO,SEASON as TEMPORADA,PTS_home AS PUNTOS_CASA ,PTS_away AS PUNTOS_VISITANTE
from games WHERE PTS_home <=70 and PTS_away  >= 100
ORDER BY TEMPORADA ASC;
-- se busca dentro de la tabla game details el query donde se haye jugadores que sean de "Detroit o que tengan por nombre Lebron James sin importar la ciudad que tengan rebotes iguales a 5
select TEAM_CITY,PLAYER_NAME,REB FROM games_details WHERE TEAM_CITY = "Detroit" OR  PLAYER_NAME = "Lebron James" OR REB = 5;

-- Se busca exclusivamente los equipos de la tabla games_details que tengan las puntiaciones mas altas 
SELECT TEAM_ABBREVIATION,MAX(PTS) AS PUNTUACION_MAXIMA FROM games_details 
WHERE TEAM_ABBREVIATION 
IN ("SAS","GSW","NYK","CHA") 
group by TEAM_ABBREVIATION ORDER BY PUNTUACION_MAXIMA DESC;

-- se hace una subconsulta donde se busque los puntos por jugador sean menores y mayores al promedio de los puntos de todos los puntos anotados
-- teniendo en cuenta que el primedio de anotaciones es de 9.77.
SELECT AVG(PTS) FROM games_details;
SELECT PLAYER_NAME,PTS FROM games_details WHERE PTS > (SELECT AVG(PTS) FROM games_details)ORDER BY PTS DESC;
SELECT PLAYER_NAME,PTS FROM games_details WHERE PTS < (SELECT AVG(PTS) FROM games_details)ORDER BY PTS DESC;

-- Esta consulta se utilizo para encontra los duplicados que no nos permitieron asignar una llave primaria 

SELECT * FROM games where game_id like '%22000007%';



-- esta consulta nos ayuda a encotrar a todos los jugadores cuyo apellido sea Jordan usando like
SELECT * FROM players where PLAYER_NAME like '%Jordan%';

-- joins
SELECT * from games g 
JOIN games_details gd ON g.GAME_ID = gd.GAME_ID 
WHERE PLAYER_NAME = "Klay Thompson";

SELECT SEASON, TEAM_CITY, PLAYER_NAME,AST from games g 
JOIN games_details gd ON g.GAME_ID = gd.GAME_ID 
WHERE AST < 5;


-- vista de equipos donde se ve lso rebotes y los putos anotaods por los jugaodresde de cada equipo 
create view equipos as(select gd.GAME_ID,gd.TEAM_ABBREVIATION,gd.PLAYER_NAME,g.REB_home,g.PTS_home from games g 
join games_details gd on
gd.GAME_ID = g.GAME_ID);

-- vista de rebotes y asistencias por jugador y ciudad
create view rebotes as(select gd.GAME_ID,gd.TEAM_CITY,gd.PLAYER_NAME,g.REB_home,g.REB_away,gd.AST from games g 
join games_details gd on
gd.GAME_ID = g.GAME_ID);


SELECT * from equipos;
SELECT * FROM rebotes;


