USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Casino_DataWarehouse')
BEGIN
    CREATE DATABASE [Casino_DataWarehouse];
END
GO

USE Casino_DataWarehouse;
GO

IF OBJECT_ID('dbo.Aktywacja_Promocji', 'U') IS NOT NULL DROP TABLE dbo.Aktywacja_Promocji;
IF OBJECT_ID('dbo.Sesja_Gry', 'U') IS NOT NULL DROP TABLE dbo.Sesja_Gry;
IF OBJECT_ID('dbo.Wizyta', 'U') IS NOT NULL DROP TABLE dbo.Wizyta;
IF OBJECT_ID('dbo.Gracz', 'U') IS NOT NULL DROP TABLE dbo.Gracz;
IF OBJECT_ID('dbo.Gra', 'U') IS NOT NULL DROP TABLE dbo.Gra;
IF OBJECT_ID('dbo.Promocja', 'U') IS NOT NULL DROP TABLE dbo.Promocja;
IF OBJECT_ID('dbo.Kasyno', 'U') IS NOT NULL DROP TABLE dbo.Kasyno;
IF OBJECT_ID('dbo.Pracownik', 'U') IS NOT NULL DROP TABLE dbo.Pracownik;
IF OBJECT_ID('dbo.Data', 'U') IS NOT NULL DROP TABLE dbo.Data;
IF OBJECT_ID('dbo.Czas', 'U') IS NOT NULL DROP TABLE dbo.Czas;
GO

CREATE TABLE Data (
    ID_Daty INT NOT NULL PRIMARY KEY, 
    PelnaData DATE NOT NULL,
    Rok INT NOT NULL,
    Miesiac INT NOT NULL,
    NazwaMiesiaca VARCHAR(20) NOT NULL,
    DzienTygodnia INT NOT NULL,
    NazwaDniaTygodnia VARCHAR(20) NOT NULL,
    CzyWeekend BIT NOT NULL
);

CREATE TABLE Czas (
    ID_Czasu INT NOT NULL PRIMARY KEY,
    Pelny_Czas TIME NOT NULL,
    Godzina INT NOT NULL,
    Minuta INT NOT NULL,
    Sekunda INT NOT NULL,
    Pora_Dnia VARCHAR(50) NOT NULL
);

CREATE TABLE Gracz (
    ID_gracza INT PRIMARY KEY IDENTITY(1,1), 
    BK_gracza INT,
    Pelne_Imie VARCHAR(80),
    Plec VARCHAR(1),
    Miasto VARCHAR(40),
    Status_Czlonkostwa VARCHAR(10),
    Kategoria_Wiekowa VARCHAR(10),
    Staz_Czlonkostwa VARCHAR(20),
    IsCurrent BIT
);

CREATE TABLE Gra (
    ID_gry INT PRIMARY KEY IDENTITY(1,1),
    Nazwa_gry VARCHAR(40),
    Kategoria VARCHAR(20) CHECK (Kategoria IN ('Stołowa', 'Automat'))
);

CREATE TABLE Promocja (
    ID_promocji INT PRIMARY KEY IDENTITY(1,1), 
    BK_Promocji INT,
    Typ_promocji VARCHAR(40) CHECK (Typ_promocji IN ('Okresowa', 'Powitalna', 'Stała', 'Specjalna', 'Inna')),
    Czy_aktywna BIT
);

CREATE TABLE Kasyno (
    ID_kasyna INT PRIMARY KEY IDENTITY(1,1), 
    BK_Kasyna INT,
    Miasto VARCHAR(40)
);

CREATE TABLE Pracownik (
    ID_pracownika INT PRIMARY KEY IDENTITY(1,1), 
    BK_Pracownika INT,
    Pelne_Imie VARCHAR(80),
    Stanowisko VARCHAR(30),
    IsCurrent BIT
);

CREATE TABLE Wizyta (
    ID_Wizyty INT PRIMARY KEY IDENTITY(1,1), 
    BK_Wizyty INT,
    FK_Data_Wejscia INT FOREIGN KEY REFERENCES Data(Id_daty),
    FK_Czas_Wejscia INT FOREIGN KEY REFERENCES Czas(Id_czasu),
    FK_Data_Wyjscia INT FOREIGN KEY REFERENCES Data(Id_daty),
    FK_Czas_Wyjscia INT FOREIGN KEY REFERENCES Czas(Id_czasu),
    FK_Gracz INT FOREIGN KEY REFERENCES Gracz(Id_gracza),
    FK_Kasyno INT FOREIGN KEY REFERENCES Kasyno(Id_kasyna),
    Dlugosc_Wizyty INT,
    Czy_Zakup BIT NOT NULL DEFAULT 0
);

CREATE TABLE Sesja_Gry (
    Kwota_postawiona DECIMAL(10, 2),
    Kwota_koncowa DECIMAL(10, 2),
    Liczba_rund INT,

    FK_Gra INT FOREIGN KEY (FK_Gra) REFERENCES Gra(Id_gry),
    FK_Wizyta INT  FOREIGN KEY (FK_Wizyta) REFERENCES Wizyta(Id_wizyty),
    FK_Pracownik INT FOREIGN KEY (FK_Pracownik) REFERENCES Pracownik(Id_pracownika),
    
    FK_Data_Rozpoczecia INT FOREIGN KEY REFERENCES Data(Id_daty),
    FK_Czas_Rozpoczecia INT FOREIGN KEY REFERENCES Czas(Id_czasu),
    FK_Data_Zakonczenia INT FOREIGN KEY REFERENCES Data(Id_daty),
    FK_Czas_Zakonczenia INT FOREIGN KEY REFERENCES Czas(Id_czasu),

    Dlugosc_Sesji INT,
    Bilans_Gracza INT
);

CREATE TABLE Aktywacja_Promocji (
    FK_Wizyta INT FOREIGN KEY (FK_Wizyta) REFERENCES Wizyta(Id_wizyty),
    FK_Promocja INT FOREIGN KEY (FK_Promocja) REFERENCES Promocja(Id_promocji)
);
GO