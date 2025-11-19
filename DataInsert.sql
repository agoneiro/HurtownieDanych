
INSERT INTO dbo.Kasyno (Miasto) VALUES 
('Warszawa'), 
('Kraków'), 
('Gdañsk');

INSERT INTO dbo.Gra (Nazwa_gry, Kategoria) VALUES 
('Blackjack Pro', 'Karciana'), 
('Roulette Supreme', 'Sto³owa'), 
('Sizzling Hot', 'Slot');


INSERT INTO dbo.Pracownik (Pelne_imie, Stanowisko) VALUES 
('Jan Kowalski', 'Krupier'), 
('Anna Nowak', 'Krupier'), 
('Marek Wiœniewski', 'Manager Sali');

INSERT INTO dbo.Gracz (BK_gracza, Pelne_imie, Plec, Miasto, Status_Czlonkostwa, Kategoria_Wiekowa, Staz_Czlonkostwa) VALUES
('KARTA1001', 'Adam Cichy', 'M', 'Warszawa', 'Z³oty', '30-40', 120),
('KARTA1002', 'Ewa B¹k', 'K', 'Radom', 'Srebrny', '20-30', 45);


INSERT INTO dbo.Promocja (Typ_promocji, Czy_aktywna) VALUES 
('Darmowe Drinki', 1), 
('Podwojenie depozytu', 1), 
('Bonus 50 PLN', 0);

INSERT INTO dbo.Data (ID_Daty, PelnaData, Rok, Miesiac, NazwaMiesiaca, DzienTygodnia, NazwaDniaTygodnia, CzyWeekend) VALUES
(20241020, '2024-10-20', 2024, 10, 'PaŸdziernik', 7, 'Niedziela', 1),
(20241021, '2024-10-21', 2024, 10, 'PaŸdziernik', 1, 'Poniedzia³ek', 0);


INSERT INTO dbo.Czas (ID_Czasu, Pelny_Czas, Godzina, Minuta, Sekunda, Pora_Dnia) VALUES
(203000, '20:30:00', 20, 30, 0, 'Wieczór'),
(204500, '20:45:00', 20, 45, 0, 'Wieczór'),
(221500, '22:15:00', 22, 15, 0, 'Noc'),
(235900, '23:59:00', 23, 59, 0, 'Noc');

INSERT INTO dbo.Wizyta (Dlugosc_Wizyty, Czy_Zakup, FK_Data_Wejscia, FK_Czas_Wejscia, FK_Data_Wyjscia, FK_Czas_Wyjscia, FK_Gracz, FK_Kasyno)
VALUES
(149, 1, 20241020, 203000, 20241020, 235900, 1, 1); 

INSERT INTO dbo.Sesja_Gry (Kwota_postawiona, Kwota_koncowa, Liczba_rund, Dlugosc_Sesji, FK_Gra, FK_Pracownik, FK_Data_Rozpoczecia, FK_Czas_Rozpoczecia, FK_Data_Zakonczenia, FK_Czas_Zakonczenia, FK_Wizyta)
VALUES
(500.00, 750.00, 20, 90, 1, 1, 20241020, 204500, 20241020, 221500, 1); 

INSERT INTO dbo.Aktywacja_Promocji (FK_Wizyta, FK_Promocja)
VALUES
(1, 1); -- ID Wizyta=1, ID Promocja=1