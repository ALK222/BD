-- ===================================================
-- Authors: Alejandro Barrachina, Clara Fernandez
-- Description: act_6
-- ===================================================

-- Nombre de los clubes que tienen entre 20000 y 70000 socios (ambos incluidos)
SELECT Nombre
FROM Club
WHERE Num_Socios >= 20000 AND Num_Socios <= 70000;


-- CIF y sede de los clubes cuyo nombre contiene la \sql{'u'} min�scula
SELECT CIF, Sede
FROM Club 
WHERE Nombre LIKE '%u%';


-- Nombre de los �rbitros que han arbitrado alg�n empate
SELECT Nombre
FROM Enfrenta NATURAL JOIN Persona
WHERE GolesLocal = GolesVisitante;


-- Ramas (sin repeticiones) de los patrocinadores que financian a clubes de m�s de 50000 socios
SELECT DISTINCT Rama
FROM Financia F JOIN Club C ON F.CIF_C = C.CIF
     JOIN Patrocinador P ON F.CIF_P = P.CIF
WHERE C.Num_Socios > 50000;


-- NIF y nombre (sin repeticiones) de las personas que han asistido a alguna victoria local
SELECT DISTINCT P.NIF, Nombre
FROM Enfrenta E JOIN Asiste A USING(CIF_local, CIF_visitante)
     JOIN Persona P ON A.NIF = P.NIF
WHERE E.GolesLocal > E.GolesVisitante;


-- Nombre de las personas que no son jugadores
(SELECT NIF, Nombre
 FROM Persona)
MINUS
(SELECT NIF, Nombre
 FROM Jugador NATURAL JOIN Persona);


-- Por cada partido ganado por el club local, nombre de los clubes enfrentados y resultado.
-- Los resultados deben aparecer ordenados de m�s a menos goles locales, en caso de igualdad
-- de m�s a menos goles visitantes, y en caso de resultados iguales por nombre de club
-- local descendente
SELECT CL.Nombre AS ClubLocal, GolesLocal, GolesVisitante, CV.Nombre AS ClubVisitante
FROM Enfrenta E JOIN Club CL ON E.CIF_local = CL.CIF
     JOIN Club CV ON CIF_visitante = CV.CIF
WHERE E.GolesLocal > E.GolesVisitante
ORDER BY GolesLocal DESC, GolesVisitante DESC, ClubLocal DESC;


-- Nombre de los clubes que han ganado todos sus partidos como local (y han jugado al menos uno)
(SELECT Nombre -- Clubes que han ganado como locales
 FROM Enfrenta E JOIN Club C ON E.CIF_local = C.CIF
 WHERE GolesLocal > GolesVisitante)
MINUS
(SELECT Nombre -- Clubes que han empatado o perdido como locales
 FROM Enfrenta E JOIN Club C ON E.CIF_local = C.CIF
 WHERE GolesLocal <= GolesVisitante);
 
 
-- Nombre (sin repeticiones) de los clubes arbitrados por el �rbitro de nombre 'Velasco Carballo'
(SELECT C.Nombre -- Clubes locales pitados por 'Velasco Carballo'
FROM Enfrenta E NATURAL JOIN Persona P
     JOIN Club C ON E.CIF_local = C.CIF
WHERE P.Nombre = 'Velasco Carballo')
UNION
(SELECT C.Nombre -- Clubes visitantes pitados por 'Velasco Carballo'
FROM Enfrenta E NATURAL JOIN Persona P
     JOIN Club C ON E.CIF_visitante = C.CIF
WHERE P.Nombre = 'Velasco Carballo');

-- Otra alternativa
SELECT DISTINCT C.Nombre
FROM Enfrenta E NATURAL JOIN Persona P
     JOIN Club C ON (E.CIF_visitante = C.CIF OR E.CIF_local = C.CIF)
WHERE P.Nombre = 'Velasco Carballo';


-- Asistentes (NIF y nombre) a partidos que son jugadores o �rbitros
(SELECT NIF, Nombre 
 FROM Asiste NATURAL JOIN Persona)
INTERSECT 
( SELECT NIF, Nombre
  FROM Jugador NATURAL JOIN Persona
 UNION  
  SELECT NIF, Nombre
  FROM Arbitro NATURAL JOIN Persona
);


-- N�mero de jugadores de cada club (usando su CIF)
SELECT CIF, COUNT(*) AS NumJugadores
FROM Jugador
GROUP BY CIF;


-- N�mero de jugadores de cada club (usando su CIF y nombre de club)
SELECT CIF, Nombre, COUNT(*) AS NumJugadores
FROM Jugador NATURAL JOIN Club
GROUP BY CIF, Nombre;


-- Altura m�nima, altura m�xima y promedio de altura de los jugadores cuyo nombre contiene una 'e' o una 'E'
SELECT MIN(Altura), MAX(Altura), ROUND(AVG(Altura), 4)
FROM Jugador NATURAL JOIN Persona
WHERE Nombre LIKE '%e%' OR Nombre LIKE '%E%';
-- Otra alternativa ser�a: WHERE UPPER(Nombre) LIKE '%E%';


-- NIF y nombre de las personas que han asistido a *exactamente una* victoria local
SELECT P.NIF, Nombre
FROM Enfrenta E JOIN Asiste A USING(CIF_local, CIF_visitante)
     JOIN Persona P ON (A.NIF = P.NIF)
WHERE GolesLocal > GolesVisitante
GROUP BY P.NIF, Nombre
HAVING COUNT(*) = 1;


-- N�mero de partidos arbitrados por cada �rbitro (un �rbitro solo debe aparecer si ha pitado al menos un partido o m�s). 
-- De cada �rbitro necesito obtener el NIF y el nombre
-- Los �rbitros deben aparecer de mayor a menor n�mero de partidos arbitrados
SELECT NIF, Nombre, COUNT(*) AS PartidosPitados
FROM Enfrenta NATURAL JOIN Persona
GROUP BY NIF, Nombre
ORDER BY PartidosPitados DESC;


-- N�mero de partidos arbitrados por cada �rbitro, donde los �rbitros que no han pitado ning�n partido deben aparecer
-- con un 0. De cada �rbitro quiero obtener su NIF y nombre
WITH 
  NIFArbitrosNoPitan(NIF) AS (
    (SELECT NIF FROM Arbitro) MINUS (SELECT NIF FROM Enfrenta)
  ),
  ArbitrosNoPitan(NIF, Nombre, PartidosPitados) AS (
    SELECT NIF, Nombre, 0 AS PartidosPitados 
    FROM NIFArbitrosNoPitan NATURAL JOIN Persona
  ),
  ArbitrosPitan(NIF,Nombre,PartidosPitados) AS (
    SELECT NIF, Nombre, COUNT(*) AS PartidosPitados
    FROM Enfrenta NATURAL JOIN Persona
    GROUP BY NIF, Nombre
  )
(SELECT * FROM ArbitrosPitan) UNION (SELECT * FROM ArbitrosNoPitan);


-- Por cada club con financiaci�n, promedio de las cantidades recibidas y n�mero de ellas
SELECT C.CIF, C.Nombre, AVG(Cantidad) AS Promedio, COUNT(*) AS TotalFinanciaciones
FROM Financia F JOIN Club C ON F.CIF_C = C.CIF
GROUP BY C.CIF, C.Nombre;


-- Por cada club con financiaci�n, cantidad total que reciben, ordenado de mayor a menor
SELECT C.CIF, C.Nombre, SUM(Cantidad) AS SumaFinanciaciones
FROM Financia F JOIN Club C ON F.CIF_C = C.CIF
GROUP BY C.CIF, C.Nombre
ORDER BY Total DESC;


-- Clubes (CIF) con m�s de 1 jugador
SELECT CIF
FROM Jugador
GROUP BY CIF
HAVING COUNT(*) > 1;


-- Por cada club y patrocinador, n�mero de jugadores de dicho club a los que patrocinan
-- Los resultados deben mostrarse por orden ascendente de club, y luego por n�mero
-- descendente de n�mero de jugadores patrocinados 
SELECT J.CIF AS Club, P.CIF AS Patrocinador, COUNT(*) AS NumJugPatrocinados
FROM Patrocina P JOIN Jugador J ON P.NIF = J.NIF
GROUP BY P.CIF, J.CIF
ORDER BY J.CIF, NumJugPatrocinados DESC;

--consulta anidada 1
SELECT PERSONA.NIF, PERSONA.NOMBRE
FROM PERSONA JOIN JUGADOR ON PERSONA.NIF = JUGADOR.NIF
WHERE JUGADOR.NIF != ALL (SELECT NIF FROM PATROCINA);

--CONSULTA ANIDADA 2
SELECT CLUB.CIF, CLUB.NOMBRE
FROM CLUB
WHERE CLUB.CIF != ALL (SELECT CIF_C FROM FINANCIA);

--CONSULTA ANIDADA 3
SELECT CLUB.CIF
FROM CLUB 
WHERE CLUB.CIF != ALL (SELECT CIF FROM JUGADOR);

--CONSULTA ANIDADA 4
SELECT PERSONA.NOMBRE, PERSONA.NIF
FROM PERSONA JOIN ARBITRO ON PERSONA.NIF = ARBITRO.NIF
WHERE ARBITRO.NIF != ALL (SELECT NIF FROM ENFRENTA);

--CONSULTA ANIDADA 5
SELECT DISTINCT CLUB.NOMBRE
FROM CLUB JOIN JUGADOR ON CLUB.CIF = JUGADOR.CIF
WHERE EXISTS (SELECT NIF FROM PERSONA WHERE NOMBRE != '%e%' OR NOMBRE != '%E%');

--CONSULTA ANIDADA 6
SELECT PERSONA.NIF, PERSONA.NOMBRE
FROM PERSONA
WHERE NOT EXISTS (
(SELECT CIF_LOCAL , CIF_VISITANTE
FROM Club CLOC JOIN ENFRENTA ON CLOC.CIF = CIF_LOCAL JOIN CLUB CV ON CV.CIF =  CIF_VISITANTE
WHERE CLOC.Nombre = 'Real Madrid CF' OR CV.NOMBRE = 'Real Madrid CF')
MINUS
(SELECT CIF_LOCAL, CIF_VISITANTE
FROM ASISTE
WHERE NIF =PERSONA.NIF )
);

--VISTA 1
CREATE VIEW AlturaMedia(CLUB.CIF, CLUB.NOMBRE, ALTURAMEDIA) AS
SELECT CLUB.CIF, CLUB.NOMBRE, AVG(JUGADOR.ALTURA) AS ALTURAMEDIA
FROM CLUB JOIN JUGADOR ON (CLUB.CIF = JUGADOR.CIF)
GROUP BY CLUB.CIF, CLUB.NOMBRE
WITH READ ONLY;
