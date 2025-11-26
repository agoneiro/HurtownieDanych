CREATE OR ALTER VIEW vETL_Dim_Gra AS
SELECT
    Nazwa_gry,
    Kategoria
FROM CasinoManagementSystemDB.dbo.Gra;
GO

MERGE INTO dbo.Gra AS Target
USING vETL_Dim_Gra AS Source
ON Target.Nazwa_gry = Source.Nazwa_gry
WHEN MATCHED AND (Target.Kategoria <> Source.Kategoria) THEN
    UPDATE SET 
        Target.Kategoria = Source.Kategoria
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Nazwa_gry, Kategoria) 
    VALUES (Source.Nazwa_gry, Source.Kategoria);
