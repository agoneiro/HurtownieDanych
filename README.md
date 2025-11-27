# ♠️ Królewskie Kasyno: System Hurtowni Danych (BI)

Ten projekt stanowi kompleksowe wdrożenie analitycznego systemu Business Intelligence (BI), obejmujące proces ETL oraz budowę kostki OLAP w oparciu o dane operacyjne kasyna.

## 🎯 Cel Projektu

Głównym celem jest transformacja danych transakcyjnych z systemu źródłowego na ustrukturyzowany, zoptymalizowany pod kątem zapytań analitycznych model hurtowni danych, wspierający analizę procesów biznesowych związanych z **sesjami gry** i **wizytami klientów**.

---

## Struktura repozytorium
```
├── data_generator/                 # KOD GENERATORA DANYCH
├── data_sources/                   # PLIKI ŹRÓDŁA DANYCH
├── data_warehouse/                 # PROJEKT ETL I OLAP 
│   ├── CasinoAnalysisServices/
│   ├── CasinoETL/   
│   └── etl_scripts/
└── docs/                            # DOKUMENTACJA 
```
---
## 🧑‍💻 Autorzy

Ten projekt został zrealizowany przez:

* **[Ostap Lozovyy](https://github.com/agoneiro)**
* **[Patryk Lewandowski](https://github.com/PatrykColo)**