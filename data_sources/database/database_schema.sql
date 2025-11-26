USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CasinoManagementSystemDB')
BEGIN
    CREATE DATABASE [CasinoManagementSystemDB];
END
GO

USE CasinoManagementSystemDB;
GO

IF OBJECT_ID('dbo.Aktywacja_Promocji', 'U') IS NOT NULL DROP TABLE dbo.Aktywacja_Promocji;
IF OBJECT_ID('dbo.Sesja_gry', 'U') IS NOT NULL DROP TABLE dbo.Sesja_gry;
IF OBJECT_ID('dbo.Zakup', 'U') IS NOT NULL DROP TABLE dbo.Zakup;
IF OBJECT_ID('dbo.Wizyta', 'U') IS NOT NULL DROP TABLE dbo.Wizyta;
IF OBJECT_ID('dbo.Pracownik', 'U') IS NOT NULL DROP TABLE dbo.Pracownik;
IF OBJECT_ID('dbo.Gracz', 'U') IS NOT NULL DROP TABLE dbo.Gracz;
IF OBJECT_ID('dbo.Gra', 'U') IS NOT NULL DROP TABLE dbo.Gra;
IF OBJECT_ID('dbo.Promocja', 'U') IS NOT NULL DROP TABLE dbo.Promocja;
IF OBJECT_ID('dbo.Kasyno', 'U') IS NOT NULL DROP TABLE dbo.Kasyno;

GO

CREATE TABLE Gracz (
    Id_gracza INT PRIMARY KEY IDENTITY(1,1), 
    Imie VARCHAR(40),
    Nazwisko VARCHAR(40)
);

CREATE TABLE Gra (
    Id_gry INT PRIMARY KEY IDENTITY(1,1),
    Nazwa_gry VARCHAR(40),
    Kategoria VARCHAR(20) CHECK (Kategoria IN ('Stołowa', 'Automat'))
);

CREATE TABLE Promocja (
    Id_promocji INT PRIMARY KEY IDENTITY(1,1), 
    Typ_promocji VARCHAR(40) CHECK (Typ_promocji IN ('Okresowa', 'Powitalna', 'Stała', 'Specjalna', 'Inna')),
    Czy_aktywna BIT
);

CREATE TABLE Kasyno (
    Id_kasyna INT PRIMARY KEY IDENTITY(1,1), 
    Miasto VARCHAR(40)
);

CREATE TABLE Pracownik (
    Id_pracownika INT PRIMARY KEY IDENTITY(1,1), 
    Imie VARCHAR(40),
    Nazwisko VARCHAR(40),
    Stanowisko VARCHAR(30),
    FK_Kasyno INT,
    FOREIGN KEY (FK_Kasyno) REFERENCES Kasyno(Id_kasyna)
);

CREATE TABLE Wizyta (
    Id_wizyty INT PRIMARY KEY IDENTITY(1,1), 
    Data_wejscia DATETIME,
    Data_wyjscia DATETIME,
    FK_Gracz INT,
    FK_Kasyno INT,
    FOREIGN KEY (FK_Gracz) REFERENCES Gracz(Id_gracza),
    FOREIGN KEY (FK_Kasyno) REFERENCES Kasyno(Id_kasyna)
);

CREATE TABLE Zakup (
    Id_zakupu INT PRIMARY KEY IDENTITY(1,1), 
    Data_zakupu DATETIME,
    Kwota DECIMAL(10, 2),
    FK_Wizyta INT,
    FOREIGN KEY (FK_Wizyta) REFERENCES Wizyta(Id_wizyty)
);

CREATE TABLE Sesja_gry (
    Id_sesji INT PRIMARY KEY IDENTITY(1,1),
    Data_rozpoczecia DATETIME,
    Data_zakonczenia DATETIME,
    Kwota_postawiona DECIMAL(10, 2),
    Kwota_koncowa DECIMAL(10, 2),
    Liczba_rund INT,
    FK_Gra INT,
    FK_Wizyta INT,
    FK_Pracownik INT,
    FOREIGN KEY (FK_Gra) REFERENCES Gra(Id_gry),
    FOREIGN KEY (FK_Wizyta) REFERENCES Wizyta(Id_wizyty),
    FOREIGN KEY (FK_Pracownik) REFERENCES Pracownik(Id_pracownika)
);

CREATE TABLE Aktywacja_Promocji (
    Id_aktywacji INT PRIMARY KEY IDENTITY(1,1),
    Data_aktywacji DATETIME,
    FK_Wizyta INT,
    FK_Promocja INT,
    FOREIGN KEY (FK_Wizyta) REFERENCES Wizyta(Id_wizyty),
    FOREIGN KEY (FK_Promocja) REFERENCES Promocja(Id_promocji)
);
GO