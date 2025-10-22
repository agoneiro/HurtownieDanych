USE CasinoManagementSystemDB;
GO


CREATE TABLE Gracz (
    Id_gracza INT PRIMARY KEY IDENTITY(1,1), 
    Imie VARCHAR(40),
    Nazwisko VARCHAR(40)
);


CREATE TABLE Gra (
    Id_gry INT PRIMARY KEY IDENTITY(1,1),
    Nazwa_gry VARCHAR(40),
    Kategoria VARCHAR(20) CHECK (Kategoria IN ('Sto³owa', 'Automat'))
);


CREATE TABLE Promocja (
    Id_promocji INT PRIMARY KEY IDENTITY(1,1), 
    Typ_promocji VARCHAR(40) CHECK (Typ_promocji IN ('Okresowa', 'Powitalna', 'Sta³a', 'Specjalna', 'Inna')),
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
    Stanowisko VARCHAR(30) CHECK (Stanowisko IN ('Krupier', 'Kasjer', 'Menad¿er', 'Inne')),
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