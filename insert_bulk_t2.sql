USE CasinoManagementSystemDB_T2;
GO

TRUNCATE TABLE stg.Aktywacja_Promocji;
BULK INSERT stg.Aktywacja_Promocji
FROM 'C:\Projekty\data\Aktywacja_Promocji_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Gra;
BULK INSERT stg.Gra
FROM 'C:\Projekty\data\Gra_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Gracz;
BULK INSERT stg.Gracz
FROM 'C:\Projekty\data\Gracz_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Informacje_o_graczach;
BULK INSERT stg.Informacje_o_graczach
FROM 'C:\Projekty\data\Informacje_o_graczach_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Kasyno;
BULK INSERT stg.Kasyno
FROM 'C:\Projekty\data\Kasyno_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Katalog_promocji;
BULK INSERT stg.Katalog_promocji
FROM 'C:\Projekty\data\Katalog_promocji_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Pracownik;
BULK INSERT stg.Pracownik
FROM 'C:\Projekty\data\Pracownik_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Promocja;
BULK INSERT stg.Promocja
FROM 'C:\Projekty\data\Promocja_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Sesja_gry;
BULK INSERT stg.Sesja_gry
FROM 'C:\Projekty\data\Sesja_gry_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Wizyta;
BULK INSERT stg.Wizyta
FROM 'C:\Projekty\data\Wizyta_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

TRUNCATE TABLE stg.Zakup;
BULK INSERT stg.Zakup
FROM 'C:\Projekty\data\Zakup_T2.csv'
WITH (
    FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '\n', CODEPAGE = '65001', TABLOCK
);
GO

PRINT '*** Zakoñczono ³adowanie danych T2. ***';