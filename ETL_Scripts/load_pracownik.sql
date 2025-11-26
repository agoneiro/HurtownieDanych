CREATE OR ALTER VIEW vETL_Dim_Pracownik AS
SELECT
    Id_pracownika AS BK,
    (Imie + ' ' + Nazwisko) AS Pelne_imie,
    Stanowisko
FROM CasinoManagementSystemDB.dbo.Pracownik;
GO

MERGE INTO dbo.Pracownik AS Target
USING vETL_Dim_Pracownik AS Source
ON Target.BK_Pracownika = Source.BK

WHEN MATCHED AND (
       Target.Pelne_imie <> Source.Pelne_imie 
    OR Target.Stanowisko <> Source.Stanowisko
) THEN
    UPDATE SET 
        Target.Pelne_imie = Source.Pelne_imie,
        Target.Stanowisko = Source.Stanowisko,
        Target.IsCurrent = 1

WHEN NOT MATCHED BY TARGET THEN
    INSERT (BK_Pracownika, Pelne_imie, Stanowisko, IsCurrent) 
    VALUES (Source.BK, Source.Pelne_imie, Source.Stanowisko, 1);