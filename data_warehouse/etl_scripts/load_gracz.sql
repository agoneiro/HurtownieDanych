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
FROM 'C:\Projekty\data\Informacje_o_graczach_T2.csv' 
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

DECLARE @CurrentDate DATE = GETDATE();

;WITH SourceData AS (
    SELECT 
        sql.Id_gracza AS BK_gracza,
        -- POPRAWKA 1: Używamy ISNULL do bezpiecznej konkatenacji
        CAST(ISNULL(csv.[Imię gracza], '') + ' ' + ISNULL(csv.[Nazwisko gracza], '') AS VARCHAR(80)) AS Pelne_Imie,
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
        
        -- POPRAWKA 2: Używamy liczb całkowitych (DATEDIFF(MONTH) zwraca INT)
        CASE 
            WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 6 THEN 'Nowy' 
            WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 12 THEN 'Początkujący' 
            WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 36 THEN 'Lojalny'
            WHEN DATEDIFF(MONTH, csv.[Data dołączenia], @CurrentDate) < 60 THEN 'Stały klient'
            ELSE 'Weteran' 
        END AS Staz_Czlonkostwa

    FROM CasinoManagementSystemDB.dbo.Gracz sql
    -- UŻYWAMY INNER JOIN, ŻEBY POBRAĆ TYLKO GRACZY, KTÓRZY ISTNIEJĄ W OBU ŹRÓDŁACH
    INNER JOIN #CSV_Gracz_Temp csv ON sql.Id_gracza = csv.[Numer identyfikacyjny gracza]
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
        ISNULL(t.Miasto, '') <> s.Miasto OR
        ISNULL(t.Status_Czlonkostwa, '') <> s.Status_Czlonkostwa OR
        ISNULL(t.Kategoria_Wiekowa, '') <> s.Kategoria_Wiekowa 
) AS AllChanges;

-- Aplikowanie zmian
BEGIN TRANSACTION;
    UPDATE t
    SET IsCurrent = 0
    FROM dbo.Gracz t
    JOIN #Changes c ON t.BK_gracza = c.BK_gracza
    WHERE c.MERGE_ACTION = 'UPDATE' AND t.IsCurrent = 1;

    INSERT INTO dbo.Gracz (
        BK_gracza, Pelne_Imie, Plec, Miasto, 
        Status_Czlonkostwa, Kategoria_Wiekowa, Staz_Czlonkostwa, IsCurrent
    )
    SELECT 
        BK_gracza, Pelne_Imie, Plec, Miasto, 
        Status_Czlonkostwa, Kategoria_Wiekowa, Staz_Czlonkostwa, 1
    FROM #Changes;
COMMIT TRANSACTION;

DROP TABLE #CSV_Gracz_Temp;
DROP TABLE #Changes;
SET NOCOUNT OFF;