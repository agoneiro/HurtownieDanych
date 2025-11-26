CREATE OR ALTER VIEW vETL_Dim_Kasyno AS
SELECT
    Id_kasyna AS BK_Kasyna,
    Miasto
FROM CasinoManagementSystemDB.dbo.Kasyno;
GO

MERGE INTO dbo.Kasyno AS Target
USING vETL_Dim_Kasyno AS Source
ON Target.BK_Kasyna = Source.BK_Kasyna
WHEN MATCHED AND (Target.Miasto <> Source.Miasto) THEN
    UPDATE SET Target.Miasto = Source.Miasto
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BK_Kasyna, Miasto) 
    VALUES (Source.BK_Kasyna, Source.Miasto);
