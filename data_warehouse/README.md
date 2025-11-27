# Hurtownia danych

Moduł `data_warehouse` zawiera wszystkie definicje struktur docelowej hurtowni danych oraz powiązane projekty Visual Studio, które realizują proces **ETL** i analitykę OLAP.

---

## Zawartość katalogu

* `CasinoAnalysisServices.sln` - Plik rozwiązania Visual Studio, dzielącego się na dwa projekty:
    - `CasinoAnalysisService` - zawiera m.in. definicję kostki OLAP.
    - `CasinoETL` - umożliwia ETL (Extract, Transform, Load)
* `etl_scripts/` - folder zawierający skrypty ETL dla wszystkich faktów i wymiarów
* `data_warehouse_schema.sql` - skrypt tworzący strukturę hurtowni danych