CREATE OR ALTER VIEW vETL_Dim_Promocja AS
SELECT
    Id_promocji AS BK_Promocji, 
    Typ_promocji,
    Czy_aktywna
FROM CasinoManagementSystemDB.dbo.Promocja;
GO

MERGE INTO dbo.Promocja AS Target
USING vETL_Dim_Promocja AS Source
ON Target.BK_Promocji = Source.BK_Promocji
WHEN MATCHED AND (Target.Typ_promocji <> Source.Typ_promocji OR Target.Czy_aktywna <> Source.Czy_aktywna) THEN
    UPDATE SET 
        Target.Typ_promocji = Source.Typ_promocji,
        Target.Czy_aktywna = Source.Czy_aktywna
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BK_Promocji, Typ_promocji, Czy_aktywna) 
    VALUES (Source.BK_Promocji, Source.Typ_promocji, Source.Czy_aktywna);