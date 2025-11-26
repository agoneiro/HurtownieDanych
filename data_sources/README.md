# Źródła danych

Folder `data_sources` zawiera źródła danych wykorzystywane w projekcie hurtowni danych, zarówno w postaci plików opisujących strukturę danych nierelacyjnych, jak i skryptów SQL do tworzenia oraz zasilania relacyjnej bazy danych.

---

## Zawartość

### 1. Schematy źródła nierelacyjnego
- **Informacje_o_graczach_schema.csv** – schemat nierelacyjnego źródła danych dotyczącego informacji o graczach.  
- **Katalog_promocji_schema.csv** – schemat nierelacyjnego źródła danych opisującego katalog promocji.

### 2. Folder `database/`
Zawiera skrypty SQL umożliwiające przygotowanie oraz wypełnienie relacyjnej bazy danych:

- **database_schema.sql** – skrypt tworzący strukturę bazy danych.  
- **insert_bulk_t1.sql** – skrypt wstawiający dane z pierwszego snapshota.  
- **insert_bulk_t2.sql** – skrypt wstawiający dane z drugiego snapshota.
