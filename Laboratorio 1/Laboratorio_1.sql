-- ===================================================
-- Authors: Alejandro Barrachina, Clara Fernandez
-- Description: act_3
-- ===================================================

CREATE TABLE Club(
    CIF CHAR(9) PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL UNIQUE,
    Sede VARCHAR2(100) UNIQUE NOT NULL,
    NumSocios NUMBER NOT NULL
);

CREATE TABLE Patrocinador(
    CIF CHAR(9) PRIMARY KEY,
    NomPat VARCHAR2(50) NOT NULL UNIQUE,
    Rama VARCHAR2(20) NOT NULL,
    Eslogan VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Persona(
    NIF CHAR(9) PRIMARY KEY,
    Nombre VARCHAR2(100) NOT NULL
);

CREATE TABLE Jugador(
    NIF CHAR(9) REFERENCES Persona(NIF) PRIMARY KEY,
    Altura NUMBER NOT NULL,
    CIF CHAR(9) REFERENCES Club(CIF) NOT NULL
);

CREATE TABLE Arbitro(
    NIF CHAR(9) REFERENCES Persona(NIF) PRIMARY KEY,
    Colegio VARCHAR(50) NOT NULL,
    Fecha_Colegiatura DATE NOT NULL
);

CREATE TABLE Patrocina(
    NIF CHAR(9) REFERENCES Jugador(NIF),
    CIF CHAR(9) REFERENCES Patrocinador(CIF),
    Cantidad NUMBER NOT NULL,
    
    CONSTRAINT dosClavesPatrocina PRIMARY KEY (NIF, CIF) 
);
CREATE TABLE Financia(
    CIF_P CHAR(9) REFERENCES Patrocinador(CIF),
    CIF_C CHAR(9) REFERENCES Club(CIF),
    Cantidad NUMBER NOT NULL,
    
    CONSTRAINT dosClavesFinancia PRIMARY KEY (CIF_P, CIF_C)
);

CREATE TABLE Enfrenta(
    CIF_L CHAR(9) REFERENCES Club(CIF),
    CIF_V CHAR(9) REFERENCES Club(CIF),
    Resultado VARCHAR2(10) NOT NULL,
    Fecha DATE NOT NULL,
    NIF CHAR(9) REFERENCES Arbitro(NIF) NOT NULL,
    
    CONSTRAINT dosClavesEnfrenta PRIMARY KEY (CIF_L, CIF_V)
);

CREATE TABLE Asiste(
    NIF CHAR(9) REFERENCES Persona(NIF),
    CIF_L CHAR(9),
    CIF_V CHAR(9),
    
    FOREIGN KEY(CIF_L, CIF_V) REFERENCES Enfrenta(CIF_L, CIF_V),
    
    CONSTRAINT tresClaves PRIMARY KEY (NIF, CIF_L, CIF_V)
);
