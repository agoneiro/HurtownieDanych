CREATE OR ALTER PROCEDURE dbo.LoadGraczCSV
AS
BEGIN
    SET NOCOUNT ON;

    -- Tabela tymczasowa
    CREATE TABLE #CSV_Gracz_Temp (
        [Numer identyfikacyjny gracza] INT,
        [Imię gracza] VARCHAR(40),
        [Nazwisko gracza] VARCHAR(40),
        [Płeć] VARCHAR(1),
        [Data urodzenia] DATE,
        [Data dołączenia] DATE,
        [Miasto zamieszkania] VARCHAR(40),
        [Status członkostwa] VARCHAR(10)
    );
    
    -- Wczytanie CSV
    BULK INSERT #CSV_Gracz_Temp
    FROM 'C:\Projekty\data\Informacje_o_graczach_T1.csv' 
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        FIRSTROW = 2,
        CODEPAGE = '65001'
    );

    DECLARE @CurrentDate DATE = GETDATE();

    WITH SourceData AS (
        SELECT 
            sql.Id_gracza AS BK_gracza,
            CAST(csv.[Imię gracza] + ' ' + csv.[Nazwisko gracza] AS VARCHAR(80)) AS Pelne_Imie,
            LEFT(csv.[Płeć], 1) AS Plec,
            csv.[Miasto zamieszkania] AS Miasto,
            csv.[Status członkostwa] AS Status_Czlonkostwa,
            
            CASE 
                WHEN DATEDIFF(YEAR, csv.[Data urodzenia], @CurrentDate) <= 25 THEN '18-25 lat'
                WHEN DATEDIFF(YEAR, csv.[Data urodzenia], @CurrentDate) <= 35 THEN '26-35 lat'
                WHEN DATEDIFF(YEAR, csv.[Data urodzenia], @CurrentDate) <= 45 THEN '36-45 lat'
                WHEN DATEDIFF(YEAR, csv.[Data urodzenia], @CurrentDate) <= 60 THEN '46-60 lat'
                ELSE '61+ lat' 
            END AS Kategoria_Wiekowa,
            
            CASE 
                WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 0.5 THEN 'Nowy' 
                WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 1 THEN 'Początkujący' 
                WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 3 THEN 'Lojalny'
                WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 5 THEN 'Stały klient'
                ELSE 'Weteran' 
            END AS Staz_Czlonkostwa

        FROM CasinoManagementSystemDB.dbo.Gracz sql
        JOIN #CSV_Gracz_Temp csv ON sql.Id_gracza = csv.[Numer identyfikacyjny gracza]
    )

    -- Wykrywanie zmian
    SELECT * INTO #Changes FROM (
        SELECT 
            'INSERT' AS MERGE_ACTION,
            s.BK_gracza, s.Pelne_Imie, s.Plec, s.Miasto, 
            s.Status_Czlonkostwa, s.Kategoria_Wiekowa, s.Staz_Czlonkostwa
        FROM SourceData s
        LEFT JOIN dbo.Gracz t ON s.BK_gracza = t.BK_gracza AND t.IsCurrent = 1
        WHERE t.ID_gracza IS NULL
        
        UNION ALL
        
        SELECT 
            'UPDATE' AS MERGE_ACTION,
            s.BK_gracza, s.Pelne_Imie, s.Plec, s.Miasto, 
            s.Status_Czlonkostwa, s.Kategoria_Wiekowa, s.Staz_Czlonkostwa
        FROM SourceData s
        JOIN dbo.Gracz t ON s.BK_gracza = t.BK_gracza AND t.IsCurrent = 1
        WHERE 
            t.Pelne_Imie <> s.Pelne_Imie OR
            t.Miasto <> s.Miasto OR
            t.Status_Czlonkostwa <> s.Status_Czlonkostwa OR
            t.Kategoria_Wiekowa <> s.Kategoria_Wiekowa OR
            t.Staz_Czlonkostwa <> s.Staz_Czlonkostwa
    ) AS AllChanges;

    -- Aplikowanie zmian
    BEGIN TRANSACTION;
        -- Ustawianie IsCurrent = 0 na starych
        UPDATE t
        SET IsCurrent = 0
        FROM dbo.Gracz t
        JOIN #Changes c ON t.BK_gracza = c.BK_gracza
        WHERE c.MERGE_ACTION = 'UPDATE' AND t.IsCurrent = 1;

        -- Wstawianie nowych
        INSERT INTO dbo.Gracz (
            BK_gracza, Pelne_Imie, Plec, Miasto, 
            Status_Czlonkostwa, Kategoria_Wiekowa, Staz_Czlonkostwa, IsCurrent
        )
        SELECT 
            BK_gracza, Pelne_Imie, Plec, Miasto, 
            Status_Czlonkostwa, Kategoria_Wiekowa, Staz_Czlonkostwa, 1
        FROM #Changes;
    COMMIT TRANSACTION;

    -- Usunięcie tymczasowych tabel
    DROP TABLE #CSV_Gracz_Temp;
    DROP TABLE #Changes;
    SET NOCOUNT OFF;
END;