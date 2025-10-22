USE CasinoManagementSystemDB_T2;
GO

BULK INSERT Aktywacja_Promocji
FROM 'C:\Projekty\data\Aktywacja_Promocji_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Gra
FROM 'C:\Projekty\data\Gra_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Gracz
FROM 'C:\Projekty\data\Gracz_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Kasyno
FROM 'C:\Projekty\data\Kasyno_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Pracownik
FROM 'C:\Projekty\data\Pracownik_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Promocja
FROM 'C:\Projekty\data\Promocja_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Sesja_gry
FROM 'C:\Projekty\data\Sesja_gry_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Wizyta
FROM 'C:\Projekty\data\Wizyta_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

BULK INSERT Zakup
FROM 'C:\Projekty\data\Zakup_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO
