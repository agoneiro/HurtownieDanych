import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta

# KONFIGURACJA
NUM_GRACZY = 10000
NUM_PRACOWNIKOW = 50
NUM_PROMOCJI = 20
NUM_WIZYT_T1 = 150000
NUM_WIZYT_T2 = 100000
NUM_SESJI_FAKTU_T1 = 600000
NUM_SESJI_FAKTU_T2 = 400000  # To sa Fact Rows - lacznie max 1,000,000 rekordów
START_DATE_T1 = datetime(2024, 1, 1)
END_DATE_T1 = datetime(2024, 6, 30)
START_DATE_T2 = datetime(2025, 7, 1)
END_DATE_T2 = datetime(2025, 9, 30)
FAKER = Faker('pl_PL')


def generate_datetime(start, end):
    return start + timedelta(seconds=random.randint(0, int((end - start).total_seconds())))


def generate_data():

    # 1. KASYNO
    kasyna = pd.DataFrame({
        'Id_kasyna': [1, 2, 3, 4, 5, 6],
        'Miasto': ['Warszawa', 'Kraków', 'Gdańsk', 'Wrocław', 'Białogard', 'Poznań']
    })

    # 2. GRA
    gry = pd.DataFrame({
        'Id_gry': range(1, 7),
        'Nazwa_gry': ['Ruletka Americana', 'Blackjack 21', 'Poker Texas', 'Automat MegaWin', 'Automat Classic777',
                      'Automat Jackpot'],
        'Kategoria': ['Stołowa', 'Stołowa', 'Stołowa', 'Automat', 'Automat', 'Automat']
    })

    # 3. PROMOCJA (CMS i CSV)
    promocje_cms = pd.DataFrame({
        'Id_promocji': range(1, NUM_PROMOCJI + 1),
        'Typ_promocji': np.random.choice(['Okresowa', 'Powitalna', 'Stała', 'Specjalna', 'Inna'], size=NUM_PROMOCJI),
        'Czy_aktywna': np.random.randint(0, 2, size=NUM_PROMOCJI)
    })
    promocje_csv = pd.DataFrame({
        'Numer identyfikacyjny promocji': promocje_cms['Id_promocji'],
        'Typ promocji': promocje_cms['Typ_promocji'],
        'Opis promocji': [FAKER.catch_phrase() for _ in range(NUM_PROMOCJI)],
        'Data rozpoczęcia promocji': [generate_datetime(START_DATE_T1 - timedelta(days=365), START_DATE_T1) for _ in
                                      range(NUM_PROMOCJI)],
        'Data zakończenia promocji': [generate_datetime(END_DATE_T2, END_DATE_T2 + timedelta(days=365)) for _ in
                                      range(NUM_PROMOCJI)],
        'Wymagany status członkostwa': np.random.choice(['Standard', 'Silver', 'Gold'], size=NUM_PROMOCJI)
    })

    # 4. PRACOWNIK (dla T1 i T2)
    pracownicy = pd.DataFrame({
        'Id_pracownika': range(1, NUM_PRACOWNIKOW + 1),
        'Imie': [FAKER.first_name() for _ in range(NUM_PRACOWNIKOW)],
        'Nazwisko': [FAKER.last_name() for _ in range(NUM_PRACOWNIKOW)],
        'Stanowisko': np.random.choice(['Krupier', 'Kasjer', 'Menadżer', 'Inne'], size=NUM_PRACOWNIKOW),
        'FK_Kasyno': np.random.choice(kasyna['Id_kasyna'], size=NUM_PRACOWNIKOW)
    })

    return kasyna, gry, promocje_cms, promocje_csv, pracownicy


def generate_players(num_players):

    # T1
    gracze_cms = pd.DataFrame({
        'Id_gracza': range(1, num_players + 1),
        'Imie': [FAKER.first_name() for _ in range(num_players)],
        'Nazwisko': [FAKER.last_name() for _ in range(num_players)]
    })

    statusy = np.random.choice(['Standard', 'Silver', 'Gold', 'VIP'], size=num_players, p=[0.5, 0.3, 0.15, 0.05])

    # Informacje o graczach (CSV/Excel) dla T1
    gracze_csv = pd.DataFrame({
        'Numer identyfikacyjny gracza': gracze_cms['Id_gracza'],
        'Imię gracza': gracze_cms['Imie'],
        'Nazwisko gracza': gracze_cms['Nazwisko'],
        'Płeć': np.random.choice(['M', 'K'], size=num_players),
        'Data urodzenia': [FAKER.date_of_birth(minimum_age=18, maximum_age=80).strftime('%Y-%m-%d') for _ in
                           range(num_players)],
        'Data dołączenia': [
            generate_datetime(START_DATE_T1 - timedelta(days=730), START_DATE_T1).strftime('%Y-%m-%d %H:%M:%S') for _ in
            range(num_players)],
        'Miasto zamieszkania': [FAKER.city() for _ in range(num_players)],
        'Status członkostwa': statusy
    })

    return gracze_cms, gracze_csv


def generate_visits_and_sessions(start_date, end_date, num_visits, num_sessions, players_id, kasyna_id, gry_id,
                                 pracownicy_id, promocje_cms, initial_visit_id=1, initial_session_id=1):
    """Generuje Wizyty, Sesje Gry, Zakupy i Aktywacje Promocji."""

    # Inicjalizacja list
    wizyty_data, sesje_data, zakupy_data, aktywacje_data = [], [], [], []
    current_session_id = initial_session_id

    for i in range(num_visits):
        wizyta_id = initial_visit_id + i
        wejscie = generate_datetime(start_date, end_date)

        # Wyjście musi być później niż wejście (od 30 min do 10 godzin)
        wyjscie = wejscie + timedelta(minutes=random.randint(30, 600))

        # Losowanie gracza i kasyna
        gracz_id = np.random.choice(players_id)
        kasyno_id = np.random.choice(kasyna_id)

        wizyty_data.append({
            'Id_wizyty': wizyta_id,
            'Data_wejscia': wejscie.strftime('%Y-%m-%d %H:%M:%S'),
            'Data_wyjscia': wyjscie.strftime('%Y-%m-%d %H:%M:%S'),
            'FK_Gracz': gracz_id,
            'FK_Kasyno': kasyno_id
        })

        # Generowanie Sesji Gry (1 do 10 sesji na wizytę, średnio 4)
        num_sessions_in_visit = random.choices(range(1, 11), weights=[10, 8, 6, 5, 4, 3, 2, 1, 1, 1], k=1)[0]

        for _ in range(num_sessions_in_visit):
            if current_session_id > num_sessions:
                break  # Limit sesji osiągnięty

            rozpoczecie = generate_datetime(wejscie, wyjscie - timedelta(minutes=10))
            zakonczenie = generate_datetime(rozpoczecie + timedelta(minutes=10), wyjscie)

            # Losowanie cech sesji
            gra_id = np.random.choice(gry_id)
            pracownik_id = np.random.choice(pracownicy_id)

            kwota_postawiona = round(random.uniform(100, 5000), 2)
            # Wynik końcowy (zysk/strata kasyna)
            kwota_koncowa = round(kwota_postawiona * random.uniform(0.7, 1.3), 2)

            sesje_data.append({
                'Id_sesji': current_session_id,
                'Data_rozpoczecia': rozpoczecie.strftime('%Y-%m-%d %H:%M:%S'),
                'Data_zakonczenia': zakonczenie.strftime('%Y-%m-%d %H:%M:%S'),
                'Kwota_postawiona': kwota_postawiona,
                'Kwota_koncowa': kwota_koncowa,
                'Liczba_rund': random.randint(10, 300),
                'FK_Gra': gra_id,
                'FK_Wizyta': wizyta_id,
                'FK_Pracownik': pracownik_id
            })
            current_session_id += 1

        # Generowanie Zakupów (0 do 3 na wizytę, np. jedzenie, napoje, żetony)
        if random.random() < 0.6:  # 60% szans na zakup
            for _ in range(random.randint(1, 3)):
                zakupy_data.append({
                    'Id_zakupu': len(zakupy_data) + 1,
                    'Data_zakupu': generate_datetime(wejscie, wyjscie).strftime('%Y-%m-%d %H:%M:%S'),
                    'Kwota': round(random.uniform(5, 500), 2),
                    'FK_Wizyta': wizyta_id
                })

        # Generowanie Aktywacji Promocji (0 lub 1 na wizytę)
        if random.random() < 0.3:  # 30% szans na aktywację promocji
            promocja_id = np.random.choice(promocje_cms['Id_promocji'])
            aktywacje_data.append({
                'Id_aktywacji': len(aktywacje_data) + 1,
                'Data_aktywacji': generate_datetime(wejscie, wyjscie).strftime('%Y-%m-%d %H:%M:%S'),
                'FK_Wizyta': wizyta_id,
                'FK_Promocja': promocja_id
            })

    # Konwersja do DataFrame
    df_wizyty = pd.DataFrame(wizyty_data)
    df_sesje = pd.DataFrame(sesje_data)
    df_zakupy = pd.DataFrame(zakupy_data)
    df_aktywacje = pd.DataFrame(aktywacje_data)

    # Resetowanie indeksów dla Id_zakupu i Id_aktywacji
    if not df_zakupy.empty:
        df_zakupy['Id_zakupu'] = range(1, len(df_zakupy) + 1)
    if not df_aktywacje.empty:
        df_aktywacje['Id_aktywacji'] = range(1, len(df_aktywacje) + 1)

    return df_wizyty, df_sesje, df_zakupy, df_aktywacje


def create_t2_changes(df_players_csv_t1):
    """Tworzy zmiany w wymiarach dla migawki T2 (SCD Type 2)."""

    df_players_csv_t2 = df_players_csv_t1.copy()

    # 1. Zmiana wymiaru: Status członkostwa gracza (SCD Type 2) - Zmiana statusu dla losowo wybranych 1000 graczy
    players_to_change = random.sample(df_players_csv_t2['Numer identyfikacyjny gracza'].tolist(), 1000)

    for player_id in players_to_change:
        # Znajdź obecny status
        current_status = df_players_csv_t2.loc[
            df_players_csv_t2['Numer identyfikacyjny gracza'] == player_id, 'Status członkostwa'].iloc[0]
        new_status = 'VIP' if current_status == 'Gold' else 'Gold'

        # Zaktualizuj rekord w T2
        df_players_csv_t2.loc[
            df_players_csv_t2['Numer identyfikacyjny gracza'] == player_id, 'Status członkostwa'] = new_status

    print(f"-> Zmiana Statusu Członkostwa dla 1000 graczy dla T2.")

    # 2. Zmiana w Pracownikach CMS (zmiana Stanowiska)
    # Ta zmiana zostanie uwzględniona poprzez modyfikację DataFrame 'pracownicy' przed generowaniem nowych sesji T2

    return df_players_csv_t2


def save_dataframes(data_dict, suffix):
    for name, df in data_dict.items():
        if not df.empty:
            file_path = f"data/{name}_{suffix}.csv"
            df.to_csv(file_path, index=False, sep=';', encoding='utf-8')
            print(f"Zapisano: {file_path} z {len(df):,} wierszami.")


def main():

    # Generowanie Wymiarów
    kasyna, gry, promocje_cms, promocje_csv, pracownicy_t1 = generate_data()
    gracze_cms_t1, gracze_csv_t1 = generate_players(NUM_GRACZY)

    # GENEROWANIE DANYCH T1
    print("\n--- GENEROWANIE DANYCH T1 (600,000 SESJI) ---")
    wizyty_t1, sesje_t1, zakupy_t1, aktywacje_t1 = generate_visits_and_sessions(
        START_DATE_T1, END_DATE_T1, NUM_WIZYT_T1, NUM_SESJI_FAKTU_T1,
        gracze_cms_t1['Id_gracza'], kasyna['Id_kasyna'], gry['Id_gry'], pracownicy_t1['Id_pracownika'], promocje_cms
    )

    data_t1 = {
        # CMS
        'Kasyno': kasyna, 'Gra': gry, 'Promocja': promocje_cms,
        'Pracownik': pracownicy_t1, 'Gracz': gracze_cms_t1,
        'Wizyta': wizyty_t1, 'Sesja_gry': sesje_t1,
        'Zakup': zakupy_t1, 'Aktywacja_Promocji': aktywacje_t1,
        # Excel/CSV
        'Informacje_o_graczach': gracze_csv_t1, 'Katalog_promocji': promocje_csv
    }

    # Zapis T1
    save_dataframes(data_t1, 'T1')

    # GENEROWANIE DANYCH T2
    print("\n--- GENEROWANIE DANYCH T2 (1,000,000 SESJI ŁĄCZNIE) ---")

    # 1. Tworzenie zmian w wymiarach dla T2

    # Zmiana w Pracowniku (CMS) - Zmiana Stanowiska Pracownika ('Kasjer' na 'Starszy Kasjer') dla T2
    pracownicy_t2 = pracownicy_t1.copy()
    pracownicy_t2.loc[pracownicy_t2['Stanowisko'] == 'Kasjer', 'Stanowisko'] = 'Starszy Kasjer'

    # Zmiana w Graczu (CSV) - Zmiana Statusu Członkostwa
    gracze_csv_t2 = create_t2_changes(gracze_csv_t1)

    # 2. Generowanie NOWYCH Faktów (T2 add-on)
    # Obliczanie ID dla nowych wierszy, aby były kontynuacją T1
    initial_visit_id_t2 = wizyty_t1['Id_wizyty'].max() + 1 if not wizyty_t1.empty else 1
    initial_session_id_t2 = sesje_t1['Id_sesji'].max() + 1 if not sesje_t1.empty else 1

    wizyty_t2_add, sesje_t2_add, zakupy_t2_add, aktywacje_t2_add = generate_visits_and_sessions(
        START_DATE_T2, END_DATE_T2, NUM_WIZYT_T2, NUM_SESJI_FAKTU_T1 + NUM_SESJI_FAKTU_T2,
        # Użyj sumy sesji jako limitu
        gracze_cms_t1['Id_gracza'], kasyna['Id_kasyna'], gry['Id_gry'], pracownicy_t2['Id_pracownika'], promocje_cms,
        initial_visit_id=initial_visit_id_t2, initial_session_id=initial_session_id_t2
    )

    # 3. Złączenie danych T1 + T2 add-on
    data_t2 = {
        # Wymiary T1 ze zmianami
        'Kasyno': kasyna, 'Gra': gry, 'Promocja': promocje_cms,
        'Pracownik': pracownicy_t2,  # Zmieniony wymiar
        'Gracz': gracze_cms_t1,  # Niezmienny, bo klucz biznesowy jest ten sam
        'Informacje_o_graczach': gracze_csv_t2,  # Zmieniony wymiar CSV
        'Katalog_promocji': promocje_csv,

        # Fakty = T1 + T2 add-on
        'Wizyta': pd.concat([wizyty_t1, wizyty_t2_add]),
        'Sesja_gry': pd.concat([sesje_t1, sesje_t2_add]),
        'Zakup': pd.concat([zakupy_t1, zakupy_t2_add]),
        'Aktywacja_Promocji': pd.concat([aktywacje_t1, aktywacje_t2_add])
    }

    # Zapis T2
    save_dataframes(data_t2, 'T2')

    print("\n--- GENEROWANIE ZAKOŃCZONE ---")
    print(f"Łączna liczba rekordów Sesja_gry w T2: {len(data_t2['Sesja_gry']):,}")


if __name__ == '__main__':
    # Stworzenie folderu dla plików
    import os

    if not os.path.exists('data'):
        os.makedirs('data')

    main()
