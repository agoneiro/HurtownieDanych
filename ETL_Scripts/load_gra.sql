CREATE OR ALTER VIEW vETL_Dim_Gra AS
SELECT
    Id_gry AS BK_Gry,
    Nazwa_gry,
    Kategoria
FROM CasinoManagementSystemDB.dbo.Gra;
GO

MERGE INTO dbo.Gra AS Target
USING vETL_Dim_Gra AS Source
ON Target.BK_Gry = Source.BK_Gry
WHEN MATCHED AND (Target.Nazwa_gry <> Source.Nazwa_gry OR Target.Kategoria <> Source.Kategoria) THEN
    UPDATE SET 
        Target.Nazwa_gry = Source.Nazwa_gry,
        Target.Kategoria = Source.Kategoria
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BK_Gry, Nazwa_gry, Kategoria) 
    VALUES (Source.BK_Gry, Source.Nazwa_gry, Source.Kategoria);
