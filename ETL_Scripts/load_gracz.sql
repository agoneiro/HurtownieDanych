CREATE OR ALTER VIEW vETL_Dim_Gracz AS
SELECT
    Id_gracza AS BK_gracza,
    (Imie + ' ' + Nazwisko) AS Pelne_imie,
    
    CAST('Kraków' AS NVARCHAR(100)) AS Miasto,
    CAST('Standard' AS NVARCHAR(50)) AS Status_Czlonkostwa,
    CAST('18-28' AS NVARCHAR(50)) AS Kategoria_Wiekowa,
    0 AS Staz_Czlonkostwa

FROM CasinoManagementSystemDB.dbo.Gracz;
GO

MERGE INTO dbo.Gracz AS Target
USING vETL_Dim_Gracz AS Source
ON Target.BK_gracza = Source.BK_gracza

WHEN MATCHED AND (
       Target.Pelne_imie <> Source.Pelne_imie
    OR Target.Miasto <> Source.Miasto
    OR Target.Status_Czlonkostwa <> Source.Status_Czlonkostwa
    OR Target.Kategoria_Wiekowa <> Source.Kategoria_Wiekowa
    OR Target.Staz_Czlonkostwa <> Source.Staz_Czlonkostwa
) THEN
    UPDATE SET 
        Target.Pelne_imie = Source.Pelne_imie,
        Target.Miasto = Source.Miasto,
        Target.Status_Czlonkostwa = Source.Status_Czlonkostwa,
        Target.Kategoria_Wiekowa = Source.Kategoria_Wiekowa,
        Target.Staz_Czlonkostwa = Source.Staz_Czlonkostwa,
        Target.IsCurrent = 1

WHEN NOT MATCHED BY TARGET THEN
    INSERT (BK_gracza, Pelne_imie, Miasto, Status_Czlonkostwa, Kategoria_Wiekowa, Staz_Czlonkostwa, IsCurrent) 
    VALUES (Source.BK_gracza, Source.Pelne_imie, Source.Miasto, Source.Status_Czlonkostwa, Source.Kategoria_Wiekowa, Source.Staz_Czlonkostwa, 1);