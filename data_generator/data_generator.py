import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta
import os

NUM_GRACZY_T1 = 10000
NUM_NOWYCH_GRACZY_T2 = 1000

NUM_PRACOWNIKOW = 50
NUM_PROMOCJI = 20
NUM_WIZYT_T1 = 200000
NUM_WIZYT_T2 = 100000
NUM_SESJI_FAKTU_T1 = 800000
NUM_SESJI_FAKTU_T2 = 400000
START_DATE_T1 = datetime(2024, 1, 1)
END_DATE_T1 = datetime(2024, 6, 30)
START_DATE_T2 = datetime(2025, 7, 1)
END_DATE_T2 = datetime(2025, 9, 30)
FAKER = Faker('pl_PL')


def generate_datetime(start, end):
    return start + timedelta(seconds=random.randint(0, int((end - start).total_seconds())))

def generate_data():
    kasyna = pd.DataFrame({
        'Id_kasyna': [1, 2, 3, 4, 5, 6],
        'Miasto': ['Warszawa', 'Kraków', 'Gdańsk', 'Wrocław', 'Białogard', 'Poznań']
    })

    gry = pd.DataFrame({
        'Id_gry': range(1, 7),
        'Nazwa_gry': ['Ruletka', 'Blackjack', 'Poker Texas Holdem', 'Automat MegaWin', 'Automat Classic777',
                      'Automat Jackpot'],
        'Kategoria': ['Stołowa', 'Stołowa', 'Stołowa', 'Automat', 'Automat', 'Automat']
    })

    promocje_cms = pd.DataFrame({
        'Id_promocji': range(1, NUM_PROMOCJI + 1),
        'Typ_promocji': np.random.choice(['Okresowa', 'Powitalna', 'Stała', 'Specjalna', 'Inna'], size=NUM_PROMOCJI),
        'Czy_aktywna': np.random.randint(0, 2, size=NUM_PROMOCJI)
    })
    promocje_excel = pd.DataFrame({
        'Numer identyfikacyjny promocji': promocje_cms['Id_promocji'],
        'Typ promocji': promocje_cms['Typ_promocji'],
        'Opis promocji': [FAKER.catch_phrase() for _ in range(NUM_PROMOCJI)],
        'Data rozpoczęcia promocji': [generate_datetime(START_DATE_T1 - timedelta(days=365), START_DATE_T1) for _ in
                                      range(NUM_PROMOCJI)],
        'Data zakończenia promocji': [generate_datetime(END_DATE_T2, END_DATE_T2 + timedelta(days=365)) for _ in
                                      range(NUM_PROMOCJI)],
        'Wymagany status członkostwa': np.random.choice(['Standard', 'Silver', 'Gold'], size=NUM_PROMOCJI)
    })

    pracownicy = pd.DataFrame({
        'Id_pracownika': range(1, NUM_PRACOWNIKOW + 1),
        'Imie': [FAKER.first_name() for _ in range(NUM_PRACOWNIKOW)],
        'Nazwisko': [FAKER.last_name() for _ in range(NUM_PRACOWNIKOW)],
        'Stanowisko': np.random.choice(['Krupier', 'Kasjer', 'Menadżer', 'Inne'], size=NUM_PRACOWNIKOW),
        'FK_Kasyno': np.random.choice(kasyna['Id_kasyna'], size=NUM_PRACOWNIKOW)
    })

    return kasyna, gry, promocje_cms, promocje_excel, pracownicy

def generate_players(num_players, start_id=1, join_date_start=START_DATE_T1 - timedelta(days=730),
                     join_date_end=START_DATE_T1):

    ids = range(1, num_players + 1)
    plcie = np.random.choice(['M', 'K'], size=num_players)
    imiona = [FAKER.first_name_male() if p == 'M' else FAKER.first_name_female() for p in plcie]
    nazwiska = [FAKER.last_name_male() if p == 'M' else FAKER.last_name_female() for p in plcie]

    gracze_cms = pd.DataFrame({
        'Id_gracza': ids,
        'Imie': imiona,
        'Nazwisko': nazwiska
    })

    statusy = np.random.choice(['Standard', 'Silver', 'Gold', 'VIP'], size=num_players, p=[0.5, 0.3, 0.15, 0.05])

    gracze_excel = pd.DataFrame({
        'Numer identyfikacyjny gracza': gracze_cms['Id_gracza'],
        'Imię gracza': gracze_cms['Imie'],
        'Nazwisko gracza': gracze_cms['Nazwisko'],
        'Płeć': plcie,
        'Data urodzenia': [FAKER.date_of_birth(minimum_age=18, maximum_age=80).strftime('%Y-%m-%d') for _ in
                           range(num_players)],
        'Data dołączenia': [
            generate_datetime(join_date_start, join_date_end).strftime('%Y-%m-%d %H:%M:%S') for _ in
            range(num_players)],
        'Miasto zamieszkania': [FAKER.city() for _ in range(num_players)],
        'Status członkostwa': statusy
    })

    return gracze_cms, gracze_excel

def generate_visits_and_sessions(start_date, end_date, num_visits, num_sessions, players_id, kasyna_id, gry_id,
                                 pracownicy_id, promocje_cms, initial_visit_id=1, initial_session_id=1):

    wizyty_data, sesje_data, zakupy_data, aktywacje_data = [], [], [], []
    current_session_id = initial_session_id

    session_limit = NUM_SESJI_FAKTU_T1 + NUM_SESJI_FAKTU_T2
    if initial_session_id > NUM_SESJI_FAKTU_T1:
        session_limit = NUM_SESJI_FAKTU_T1 + NUM_SESJI_FAKTU_T2

    for i in range(num_visits):
        wizyta_id = initial_visit_id + i
        wejscie = generate_datetime(start_date, end_date)

        wyjscie = wejscie + timedelta(minutes=random.randint(30, 600))
        gracz_id = np.random.choice(players_id)
        kasyno_id = np.random.choice(kasyna_id)

        wizyty_data.append({
            'Id_wizyty': wizyta_id,
            'Data_wejscia': wejscie.strftime('%Y-%m-%d %H:%M:%S'),
            'Data_wyjscia': wyjscie.strftime('%Y-%m-%d %H:%M:%S'),
            'FK_Gracz': gracz_id,
            'FK_Kasyno': kasyno_id
        })

        num_sessions_in_visit = random.choices(range(1, 11), weights=[10, 8, 6, 5, 4, 3, 2, 1, 1, 1], k=1)[0]

        for _ in range(num_sessions_in_visit):
            if current_session_id > num_sessions:
                break

            rozpoczecie = generate_datetime(wejscie, wyjscie - timedelta(minutes=10))
            zakonczenie = generate_datetime(rozpoczecie + timedelta(minutes=10), wyjscie)

            gra_id = np.random.choice(gry_id)
            pracownik_id = np.random.choice(pracownicy_id)

            kwota_postawiona = round(random.uniform(100, 5000), 2)
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

        if random.random() < 0.6:
            for _ in range(random.randint(1, 3)):
                zakupy_data.append({
                    'Id_zakupu': len(zakupy_data) + 1,
                    'Data_zakupu': generate_datetime(wejscie, wyjscie).strftime('%Y-%m-%d %H:%M:%S'),
                    'Kwota': round(random.uniform(5, 500), 2),
                    'FK_Wizyta': wizyta_id
                })

        if random.random() < 0.3:
            promocja_id = np.random.choice(promocje_cms['Id_promocji'])
            aktywacje_data.append({
                'Id_aktywacji': len(aktywacje_data) + 1,
                'Data_aktywacji': generate_datetime(wejscie, wyjscie).strftime('%Y-%m-%d %H:%M:%S'),
                'FK_Wizyta': wizyta_id,
                'FK_Promocja': promocja_id
            })

    df_wizyty = pd.DataFrame(wizyty_data)
    df_sesje = pd.DataFrame(sesje_data)
    df_zakupy = pd.DataFrame(zakupy_data)
    df_aktywacje = pd.DataFrame(aktywacje_data)

    if not df_zakupy.empty:
        df_zakupy['Id_zakupu'] = range(1, len(df_zakupy) + 1)
    if not df_aktywacje.empty:
        df_aktywacje['Id_aktywacji'] = range(1, len(df_aktywacje) + 1)

    return df_wizyty, df_sesje, df_zakupy, df_aktywacje

def create_t2_changes(df_players_csv_t1):
    df_players_csv_t2 = df_players_csv_t1.copy()

    players_to_change = random.sample(df_players_csv_t2['Numer identyfikacyjny gracza'].tolist(), 1000)

    for player_id in players_to_change:
        current_status = df_players_csv_t2.loc[
            df_players_csv_t2['Numer identyfikacyjny gracza'] == player_id, 'Status członkostwa'].iloc[0]
        if current_status == 'Gold':
            new_status = 'VIP'
        elif current_status == 'VIP':
            new_status = 'Gold'
        elif current_status == 'Standard':
            new_status = 'Silver'
        else:
            new_status = 'Standard'

        df_players_csv_t2.loc[
            df_players_csv_t2['Numer identyfikacyjny gracza'] == player_id, 'Status członkostwa'] = new_status

    print(f"-> Zmiana Statusu Członkostwa dla 1000 graczy dla T2.")

    return df_players_csv_t2

def save_dataframes(data_dict, suffix):
    for name, df in data_dict.items():
        if not df.empty:
            excel_dfs = ['Informacje_o_graczach', 'Katalog_promocji']

            if name in excel_dfs:
                file_path = f"data/{name}_{suffix}.xlsx"
                df.to_excel(file_path, index=False)
                print(f"Zapisano: {file_path} (EXCEL) z {len(df):,} wierszami.")
            else:
                file_path = f"data/{name}_{suffix}.csv"
                df.to_csv(file_path, index=False, sep=';', encoding='utf-8')
                print(f"Zapisano: {file_path} (CSV) z {len(df):,} wierszami.")

def main():
    kasyna, gry, promocje_cms, promocje_excel, pracownicy_t1 = generate_data()
    gracze_cms_t1, gracze_excel_t1 = generate_players(NUM_GRACZY_T1)

    print("\nGENEROWANIE DANYCH T1")
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
        # Excel
        'Informacje_o_graczach': gracze_excel_t1, 'Katalog_promocji': promocje_excel
    }

    # Zapis T1
    save_dataframes(data_t1, 'T1')

    print("\nGENEROWANIE DANYCH T2")

    pracownicy_t2 = pracownicy_t1.copy()
    pracownicy_t2.loc[pracownicy_t2['Stanowisko'] == 'Kasjer', 'Stanowisko'] = 'Starszy Kasjer'

    gracze_csv_base_t2 = create_t2_changes(gracze_excel_t1)

    last_player_id = gracze_cms_t1['Id_gracza'].max()
    gracze_cms_new, gracze_excel_new = generate_players(
        NUM_NOWYCH_GRACZY_T2,
        start_id=last_player_id + 1,
        join_date_start=START_DATE_T2,
        join_date_end=END_DATE_T2
    )

    gracze_cms_t2 = pd.concat([gracze_cms_t1, gracze_cms_new], ignore_index=True)
    gracze_excel_t2 = pd.concat([gracze_csv_base_t2, gracze_excel_new], ignore_index=True)

    initial_visit_id_t2 = wizyty_t1['Id_wizyty'].max() + 1 if not wizyty_t1.empty else 1
    initial_session_id_t2 = sesje_t1['Id_sesji'].max() + 1 if not sesje_t1.empty else 1

    wizyty_t2_add, sesje_t2_add, zakupy_t2_add, aktywacje_t2_add = generate_visits_and_sessions(
        START_DATE_T2, END_DATE_T2, NUM_WIZYT_T2, NUM_SESJI_FAKTU_T1 + NUM_SESJI_FAKTU_T2,
        gracze_cms_t2['Id_gracza'],
        kasyna['Id_kasyna'], gry['Id_gry'], pracownicy_t2['Id_pracownika'], promocje_cms,
        initial_visit_id=initial_visit_id_t2, initial_session_id=initial_session_id_t2
    )

    data_t2 = {
        'Kasyno': kasyna, 'Gra': gry, 'Promocja': promocje_cms,
        'Pracownik': pracownicy_t2,
        'Gracz': gracze_cms_t2,
        'Informacje_o_graczach': gracze_excel_t2,
        'Katalog_promocji': promocje_excel,


        'Wizyta': pd.concat([wizyty_t1, wizyty_t2_add], ignore_index=True),
        'Sesja_gry': pd.concat([sesje_t1, sesje_t2_add], ignore_index=True),
        'Zakup': pd.concat([zakupy_t1, zakupy_t2_add], ignore_index=True),
        'Aktywacja_Promocji': pd.concat([aktywacje_t1, aktywacje_t2_add], ignore_index=True)
    }

    # Zapis T2
    save_dataframes(data_t2, 'T2')

    print("\nGENEROWANIE ZAKOŃCZONE")


if __name__ == '__main__':
    if not os.path.exists('data'):
        os.makedirs('data')

    main()