CREATE OR ALTER VIEW vETL_Fact_Sesja_Gry AS
SELECT
    -- Wyliczenie miar
    s.Kwota_postawiona,
    s.Kwota_koncowa,
    s.Liczba_rund,
    DATEDIFF(MINUTE, s.Data_rozpoczecia, s.Data_zakonczenia) AS Dlugosc_Sesji,
    (s.Kwota_koncowa - s.Kwota_postawiona) AS Bilans_Gracza,

    -- Klucze obce (Lookup do wymiarów)
    g.ID_gry AS FK_Gra, -- Zak³adam, ¿e ID gry w hurtowni odpowiada ID w Ÿródle lub Gra nie ma SCD
    w.ID_Wizyty AS FK_Wizyta,
    p.ID_pracownika AS FK_Pracownik,
    
    -- Wymiar Czasu i Daty (Rozpoczêcie)
    d_start.ID_Daty AS FK_Data_Rozpoczecia,
    t_start.ID_Czasu AS FK_Czas_Rozpoczecia,
    
    -- Wymiar Czasu i Daty (Zakoñczenie)
    d_end.ID_Daty AS FK_Data_Zakonczenia,
    t_end.ID_Czasu AS FK_Czas_Zakonczenia

FROM CasinoManagementSystemDB.dbo.Sesja_gry s

LEFT JOIN Casino_DataWarehouse.dbo.Gra g ON s.FK_Gra = g.ID_gry 

LEFT JOIN Casino_DataWarehouse.dbo.Wizyta w ON s.FK_Wizyta = w.BK_Wizyty

LEFT JOIN Casino_DataWarehouse.dbo.Pracownik p ON s.FK_Pracownik = p.BK_pracownika AND p.IsCurrent = 1 --TODO BK PRACOWNIK BO SCD2

LEFT JOIN Casino_DataWarehouse.dbo.Data d_start ON CAST(s.Data_rozpoczecia AS DATE) = d_start.PelnaData
LEFT JOIN Casino_DataWarehouse.dbo.Czas t_start ON DATEPART(HOUR, s.Data_rozpoczecia) = t_start.Godzina 
                                               AND DATEPART(MINUTE, s.Data_rozpoczecia) = t_start.Minuta
                                               AND DATEPART(SECOND, s.Data_rozpoczecia) = t_start.Sekunda

LEFT JOIN Casino_DataWarehouse.dbo.Data d_end ON CAST(s.Data_zakonczenia AS DATE) = d_end.PelnaData
LEFT JOIN Casino_DataWarehouse.dbo.Czas t_end ON DATEPART(HOUR, s.Data_zakonczenia) = t_end.Godzina 
                                             AND DATEPART(MINUTE, s.Data_zakonczenia) = t_end.Minuta
                                             AND DATEPART(SECOND, s.Data_zakonczenia) = t_end.Sekunda;
GO

INSERT INTO Casino_DataWarehouse.dbo.Sesja_Gry (
    Kwota_postawiona,
    Kwota_koncowa,
    Liczba_rund,
    FK_Gra,
    FK_Wizyta,
    FK_Pracownik,
    FK_Data_Rozpoczecia,
    FK_Czas_Rozpoczecia,
    FK_Data_Zakonczenia,
    FK_Czas_Zakonczenia,
    Dlugosc_Sesji,
    Bilans_Gracza
)
SELECT 
    Kwota_postawiona,
    Kwota_koncowa,
    Liczba_rund,
    FK_Gra,
    FK_Wizyta,
    FK_Pracownik,
    FK_Data_Rozpoczecia,
    FK_Czas_Rozpoczecia,
    FK_Data_Zakonczenia,
    FK_Czas_Zakonczenia,
    Dlugosc_Sesji,
    Bilans_Gracza
FROM vETL_Fact_Sesja_Gry src
WHERE NOT EXISTS (
    SELECT 1 
    FROM Casino_DataWarehouse.dbo.Sesja_Gry s1 
    WHERE s1.FK_Wizyta = src.FK_Wizyta 
      AND s1.FK_Data_Rozpoczecia = src.FK_Data_Rozpoczecia
      AND s1.FK_Czas_Rozpoczecia = src.FK_Czas_Rozpoczecia
      AND s1.FK_Gra = src.FK_Gra
);