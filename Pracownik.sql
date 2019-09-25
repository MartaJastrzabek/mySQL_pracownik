CREATE SCHEMA pracownicy;

-- 1.Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE pracownik (
	id INT auto_increment PRIMARY KEY,
    imie VARCHAR (50),
    nazwisko VARCHAR (50),
    wyplata INT (6),
    data_urodzenia DATE,
    stanowisko VARCHAR (50)
);

-- 2. Wstawia do tabeli co najmniej 6 pracowników

INSERT INTO pracownik (imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES ('Jan', 'Kowalski', 5000, '1985-08-14', 'Manager'),
		('Zofia', 'Nowacka', 15000, '1965-01-01', 'Dyrektor'),
		('Aldona', 'Zawadzka', 4200, '1982-10-20', 'Sprzedawca'),
		('Leon', 'Kozioł', 4000, '1990-05-17', 'Sprzedawca'),
		('Andrzej', 'Nowak', 4500, '1981-06-12', 'Serwisant'),
		('Mariusz', 'Kowal', 3800, '1991-02-25', 'Kierowca');

-- 3. Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku

SELECT * FROM pracownik
ORDER BY nazwisko;

-- 4. Pobiera pracowników na wybranym stanowisku

SELECT * FROM pracownik
WHERE stanowisko = 'sprzedawca';

-- 5. Pobiera pracowników, którzy mają co najmniej 30 lat

SELECT * FROM pracownik
WHERE 30 <= (ABS(TIMESTAMPDIFF(YEAR, NOW(), data_urodzenia)));

-- 6. Zwiększa wypłatę pracowników na wybranym stanowisku o 10%

UPDATE pracownik
SET wyplata  = wyplata + (wyplata * 0.1)
WHERE stanowisko = 'dyrektor';

-- 7. Usuwa najmłodszego pracownika

-- Error Code: 1093. You can't specify target table 'pracownik' for update in FROM clause
DELETE FROM pracownik
WHERE data_urodzenia = (SELECT MAX(data_urodzenia) FROM pracownik);

-- Ten sposób działa
DELETE FROM pracownik
ORDER BY data_urodzenia DESC
LIMIT 1;

-- 8. Usuwa tabelę pracownik

DROP TABLE pracownik;

-- 9. Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
	id_stanowiska INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_stanowiska VARCHAR (50),
    opis VARCHAR (200),
    wyplata INT (6)
);

-- 10. Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)

CREATE TABLE adres (
	id INT AUTO_INCREMENT PRIMARY KEY,
    id_pracownika INT(6),
	ulica_nr_domu_mieszkania VARCHAR (50),
    kod_pocztowy VARCHAR(6),
    miejscowosc VARCHAR(50)
);

-- 11. Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres

CREATE TABLE pracownik(
	id_pracownika INT(6) AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR (50),
    nazwisko VARCHAR (50),
    id_stanowiska INT (6)
);

SELECT * FROM pracownik p
JOIN stanowisko s ON p.id_stanowiska = s.id_stanowiska
JOIN adres a ON p.id_pracownika = a.id_pracownika;

-- 12. Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)

INSERT INTO pracownik (imie, nazwisko, id_stanowiska)
VALUES ('Jan', 'Kowalski', 3), 
		('Zofia', 'Nowak', 1), 
		('Stefan', 'Górski', 2), 
		('Mariola', 'Zawadzka', 2), 
		('Celina', 'Kowalik', 5);

INSERT INTO stanowisko (id_stanowiska, nazwa_stanowiska, opis, wyplata)
VALUES (1, 'IT SUPPORT', 'Rozwiązywanie problemów IT' , 3500), 
		(2, 'Obsługa klienta', 'Kontakty z klientami' , 3200), 
		(3, 'Manager', 'Zarządzanie pracownikami', 5000), 
		(4, 'Księgowy', 'Prowadzenie księgowości firmy', 4000), 
		(5, 'Kierowca', 'Dostawa zamówień', 3100);

INSERT INTO adres (id_pracownika, ulica_nr_domu_mieszkania, kod_pocztowy, miejscowosc)
VALUES (1, 'Nowowiejska 5/2', '53-687', 'Wrocław'),
		(2, 'Krakowska 22', '53-687', 'Wrocław'),
		(3, 'Smocza 14', '23-677', 'Krakow'),
		(4, 'Kacza 7', '45-748', 'Wrocław'),
		(5, 'Chabrowa 87', '53-654', 'Wroclaw');
   
-- 13. Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)

SELECT 
	p.imie, 
	p.nazwisko, 
	a.ulica_nr_domu_mieszkania, 
	a.kod_pocztowy, 
	a.miejscowosc, 
	s.nazwa_stanowiska 
FROM pracownik p
JOIN adres a ON p.id_pracownika = a.id_pracownika
JOIN stanowisko s ON p.id_stanowiska = s.id_stanowiska;

-- 14. Oblicza sumę wypłat dla wszystkich pracowników w firmie

SELECT SUM(wyplata) FROM pracownik p
JOIN stanowisko s ON p.id_stanowiska = s.id_stanowiska;

-- 15. Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)

SELECT * FROM pracownik p
JOIN adres a ON p.id_pracownika = a.id_pracownika
WHERE kod_pocztowy = '53-687';