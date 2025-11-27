CREATE OR ALTER VIEW vETL_Fact_Wizyta AS
SELECT
    s.Id_wizyty AS BK_Wizyty,
    k.Id_kasyna as FK_Kasyno,
    g.ID_gracza as FK_Gracz,
    d_in.ID_Daty as FK_Data_Wejscia,
    d_out.ID_Daty as FK_Data_Wyjscia,
    t_in.ID_Czasu as FK_Czas_Wejscia,
    t_out.ID_Czasu as FK_Czas_Wyjscia,
    DATEDIFF(SECOND, s.Data_wejscia, s.Data_wyjscia) AS Dlugosc_Wizyty,
    CASE 
        WHEN EXISTS (SELECT 1 FROM CasinoManagementSystemDB.dbo.Zakup z WHERE z.FK_Wizyta = s.Id_wizyty) 
        THEN 1 
        ELSE 0 
    END AS Czy_Zakup
FROM CasinoManagementSystemDB.dbo.Wizyta s
LEFT JOIN Casino_DataWarehouse.dbo.Kasyno k ON s.FK_Kasyno = k.BK_Kasyna
LEFT JOIN Casino_DataWarehouse.dbo.Gracz g ON s.FK_Gracz = g.BK_gracza AND g.IsCurrent = 1
LEFT JOIN Casino_DataWarehouse.dbo.Data d_in ON CAST(s.Data_wejscia AS DATE) = d_in.PelnaData
LEFT JOIN Casino_DataWarehouse.dbo.Data d_out ON CAST(s.Data_wyjscia AS DATE) = d_out.PelnaData
LEFT JOIN Casino_DataWarehouse.dbo.Czas t_in ON DATEPART(HOUR, s.Data_wejscia) = t_in.Godzina 
                        AND DATEPART(MINUTE, s.Data_wejscia) = t_in.Minuta
                        AND DATEPART(SECOND, s.Data_wejscia) = t_in.Sekunda
LEFT JOIN Casino_DataWarehouse.dbo.Czas t_out ON DATEPART(HOUR, s.Data_wyjscia) = t_out.Godzina 
                        AND DATEPART(MINUTE, s.Data_wyjscia) = t_out.Minuta
                        AND DATEPART(SECOND, s.Data_wyjscia) = t_out.Sekunda

GO

INSERT INTO Casino_DataWarehouse.dbo.Wizyta (
    BK_Wizyty,
    FK_Gracz, 
    FK_Kasyno, 
    FK_Data_Wejscia, 
    FK_Czas_Wejscia, 
    FK_Data_Wyjscia, 
    FK_Czas_Wyjscia, 
    Dlugosc_Wizyty, 
    Czy_Zakup
)SELECT 
    BK_Wizyty,
    FK_Gracz, 
    FK_Kasyno, 
    FK_Data_Wejscia, 
    FK_Czas_Wejscia, 
    FK_Data_Wyjscia, 
    FK_Czas_Wyjscia, 
    Dlugosc_Wizyty, 
    Czy_Zakup
FROM vETL_Fact_Wizyta src
WHERE NOT EXISTS(
    SELECT 1
    FROM Casino_DataWarehouse.dbo.Wizyta w1
    WHERE w1.BK_Wizyty = src.BK_Wizyty
);