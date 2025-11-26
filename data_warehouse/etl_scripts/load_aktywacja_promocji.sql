CREATE OR ALTER VIEW vETL_Fact_Aktywacja_Promocji AS
SELECT
    w.ID_Wizyty AS FK_Wizyta,
    p.ID_promocji AS FK_Promocja
FROM CasinoManagementSystemDB.dbo.Aktywacja_Promocji src
LEFT JOIN Casino_DataWarehouse.dbo.Wizyta w ON src.FK_Wizyta = w.BK_Wizyty
LEFT JOIN Casino_DataWarehouse.dbo.Promocja p ON src.FK_Promocja = p.BK_Promocji;
GO

INSERT INTO Casino_DataWarehouse.dbo.Aktywacja_Promocji (
    FK_Wizyta,
    FK_Promocja
)
SELECT 
    FK_Wizyta,
    FK_Promocja
FROM vETL_Fact_Aktywacja_Promocji src
WHERE FK_Wizyta IS NOT NULL AND FK_Promocja IS NOT NULL
AND NOT EXISTS (
    SELECT 1 
    FROM Casino_DataWarehouse.dbo.Aktywacja_Promocji t
    WHERE t.FK_Wizyta = src.FK_Wizyta 
      AND t.FK_Promocja = src.FK_Promocja
);