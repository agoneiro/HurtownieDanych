CREATE OR ALTER PROCEDURE dbo.LoadPracownik
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CurrentDate DATE = GETDATE();

    WITH SourceData AS (
        SELECT 
            p.Id_pracownika AS BK_Pracownika,
            CAST(p.Imie + ' ' + p.Nazwisko AS VARCHAR(80)) AS Pelne_Imie,
            p.Stanowisko AS Stanowisko
        FROM CasinoManagementSystemDB.dbo.Pracownik p
    )
    
    -- Wykrywanie zmian
    SELECT * INTO #Changes FROM (
        SELECT 
            'INSERT' AS MERGE_ACTION,
            s.BK_Pracownika, s.Pelne_Imie, s.Stanowisko
        FROM SourceData s
        LEFT JOIN dbo.Pracownik t ON s.BK_Pracownika = t.BK_Pracownika AND t.IsCurrent = 1
        WHERE t.ID_pracownika IS NULL
            
        UNION ALL
            
        SELECT 
            'UPDATE' AS MERGE_ACTION,
            s.BK_Pracownika, s.Pelne_Imie, s.Stanowisko
        FROM SourceData s
        JOIN dbo.Pracownik t ON s.BK_Pracownika = t.BK_Pracownika AND t.IsCurrent = 1
        WHERE 
            t.Pelne_Imie <> s.Pelne_Imie OR
            t.Stanowisko <> s.Stanowisko
    ) AS AllChanges

    -- Aplikowanie zmian
    BEGIN TRANSACTION;
        -- Ustawianie IsCurrent = 0 na starych
        UPDATE t
        SET IsCurrent = 0
        FROM dbo.Pracownik t
        JOIN #Changes c ON t.BK_Pracownika = c.BK_Pracownika
        WHERE c.MERGE_ACTION = 'UPDATE' AND t.IsCurrent = 1;

        -- Wstawianie nowych
        INSERT INTO dbo.Pracownik (
            BK_Pracownika, Pelne_Imie, Stanowisko, IsCurrent
        )
        SELECT 
            BK_Pracownika, Pelne_Imie, Stanowisko, 1
        FROM #Changes;
    COMMIT TRANSACTION;

    -- Usunięcie tymczasowych tabel
    DROP TABLE #Changes;
    SET NOCOUNT OFF;
END;