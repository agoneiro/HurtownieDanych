# Data Generator

Moduł `data_generator` odpowiada za generowanie przykładowych danych do źródeł. Dane są tworzone na podstawie skryptu `data_generator.py`, a następnie zapisywane w folderze `data/`. Repozytorium zawiera już przykładowe wygenerowane pliki.

---

## Struktura folderu
```
data_generator/
├── data_generator.py # Skrypt generujący dane
├── requirements.txt # Wymagane biblioteki do uruchomienia generatora
└── data/ # Folder z wygenerowanymi danymi (przykładowe już w repo)
```

---

## Uruchamianie generatora

### 1. Instalacja zależności

W katalogu `data_generator` wykonaj:

```bash
pip install -r requirements.txt
```

### 2. Uruchomienie generatora

```bash
python data_generator.py
```

Po uruchomieniu dane zostaną automatycznie zapisane w folderze data/.