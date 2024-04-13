-- Query 1: Znajd� lekarzy, kt�rzy obs�ugiwali co najmniej trzy r�ne gatunki zwierz�t
-- Scenariusz: Klinika weterynaryjna chce weryfikowa� umiej�tno�ci i do�wiadczenie swoich lekarzy. 
-- Szukaj� lekarzy, kt�rzy obs�ugiwali co najmniej trzy r�ne gatunki zwierz�t. 

SELECT Weterynarz.PESEL, Weterynarz.Imie AS Weterynarz_Imie, Weterynarz.Nazwisko AS Weterynarz_Nazwisko
FROM Weterynarz
JOIN Wizyta ON Weterynarz.PESEL = Wizyta.PESEL_weterynarza
JOIN Zwierze ON Wizyta.ID_zwierzecia = Zwierze.ID
GROUP BY Weterynarz.PESEL, Weterynarz.Imie, Weterynarz.Nazwisko
HAVING COUNT(DISTINCT Zwierze.Gatunek) >= 3;


-- Query 2: Zapytanie: Podaj dat� szczepienia o nazwie �Nos�wka� 
-- dla zwierz�cia o danym ID zwi�kszon� o 3 lata (b�dzie to pierwszy termin kiedy mo�na zaszczepi� ponownie zwierz�).
-- Scenariusz: Istniej� szczepienia cykliczne dla zwierz�t, tzn. takie, kt�re wykonuje si� co 3 lata. Weterynarz chce sprawdzi�, kiedy ostatni 
-- raz wykonane zosta�o dla danego zwierz�cia szczepienie przeciwko wirusowi nos�wki, by wyznaczy� termin kolejnego szczepienia. 

SELECT Zwierze.ID, Zwierze.Imie AS Zwierze_Imie, DATEADD(YEAR, 3, MAX(Szczepienia.Data_szczepienia)) AS Nast�pne_Szczepienie
FROM Zwierze
JOIN Szczepienia ON Zwierze.ID = Szczepienia.ID_zwierzecia
WHERE  Szczepienia.Nazwa_Szczepienia = 'Nos�wka' AND
	Zwierze.ID IN (
	SELECT ID_zwierzecia
    FROM Szczepienia
    WHERE Szczepienia.Nazwa_Szczepienia = 'Nos�wka' AND Szczepienia.Data_szczepienia IS NOT NULL
    GROUP BY ID_zwierzecia)
GROUP BY Zwierze.ID, Zwierze.Imie, Szczepienia.Data_szczepienia
ORDER BY Nast�pne_Szczepienie ASC;


-- Query 3: Zwr�� dane do wys�ania listu (godno��, miejscowo��, ulica, numer domu, kod pocztowy) dla w�a�cicieli zwierz�t 
-- je�li ich zwierz� nie ma aktualnego szczepienia "Nos�wka" zrobionego w ci�gu ostatnich 3 lat. 
-- Nawet je�eli osoba ma kilka zwierz�t to musi dosta� tylko jeden list.
-- Scenariusz: Istniej� szczepienia cykliczne dla zwierz�t, tzn. takie, kt�re wykonuje si� co 3 lata. 
-- Administrator lecznicy wysy�a przypomnienie o potrzebie powt�rnego szczepienia.

SELECT DISTINCT
       Wlasciciel.Imie AS Wlasciciel_Imie, 
	   Wlasciciel.Nazwisko AS Wlasciciel_Nazwisko, 
       Wlasciciel.Miejscowosc AS Miejscowosc, 
       Wlasciciel.Ulica AS Ulica, 
       Wlasciciel.Numer_domu AS Numer_Domu, 
       Wlasciciel.Kod_pocztowy AS Kod_Pocztowy
FROM Wlasciciel
JOIN Zwierze ON Wlasciciel.PESEL = Zwierze.PESEL_wlasciciela
LEFT JOIN Szczepienia ON Zwierze.ID = Szczepienia.ID_zwierzecia AND Szczepienia.Nazwa_Szczepienia = 'Nos�wka' AND Szczepienia.Data_szczepienia >= DATEADD(YEAR, -3, GETDATE())
WHERE Szczepienia.ID_szczepienia IS NULL
ORDER BY Wlasciciel.Imie;


-- Query 4: Zwr�� miejscowo�ci, gdzie najcz�ciej diagnozowano gryp� w ci�gu ostatnich 3 miesi�cy
-- Scenariusz: Wybuch�a epidemia grypy. Aby m�c ostrzec okolicznych w�a�cicieli zwierz�t, szukane jest miejsce,
-- w kt�rym w ostatnim czasie wykryto najwi�ksz� ilo�� wyst�pie� tej choroby.

SELECT Wlasciciel.Miejscowosc, COUNT(DISTINCT Historie_Chorob.ID_wizyty) AS Liczba_Wystapien
FROM Wizyta
JOIN Zwierze ON Wizyta.ID_zwierzecia = Zwierze.ID
JOIN Wlasciciel ON Zwierze.PESEL_wlasciciela = Wlasciciel.PESEL
JOIN Historie_Chorob ON Wizyta.ID_wizyty = Historie_Chorob.ID_wizyty
JOIN Choroby ON Historie_Chorob.ID_choroby = Choroby.ID_choroby
WHERE Choroby.Nazwa_Choroby = 'Grypa' AND Wizyta.Data_wizyty >= DATEADD(MONTH, -3, GETDATE())
GROUP BY Wlasciciel.Miejscowosc
ORDER BY Liczba_Wystapien DESC;


-- Query 5: Zwr�� list� rodzaj�w bada� posortowanych po ilo�ci odbytych bada�. 
-- Scenariusz: W�a�ciciel chce kupi� nowe sprz�ty do wykonywania bada�. Zastanawia si�, kt�ry sprz�t jest najcz�ciej 
-- wykorzystywany (kt�re badania s� najcz�ciej wykonywane). 

SELECT Rodzaje_badan.Nazwa_Badania, COUNT(Badania.ID_wykonanego_badania) AS Liczba_Wykonanych_Testow
FROM Rodzaje_badan
JOIN Badania ON Rodzaje_badan.ID_badania = Badania.ID_badania
GROUP BY Rodzaje_badan.Nazwa_Badania
ORDER BY Liczba_Wykonanych_Testow DESC;


-- Query 6: Zwr�� 5 w�a�cicieli, kt�rych zwierz�ta odby�y najwi�ksz� ilo�� wizyt (je�li jest wi�cej ni� jedno liczymy ��czn� ilo��).
-- Scenariusz: Zarz�d kliniki postanowi� wprowadzi� karty sta�ego klienta. Zostan� one przyznane 5 w�a�cicielom, 
-- kt�rych zwierz�ta odby�y w sumie najwi�ksz� liczb� wizyt.

DROP VIEW IF EXISTS TopOwners;
GO
CREATE VIEW TopOwners
	(Imie, Nazwisko, Liczba_wizyt) 
	AS SELECT TOP 5 Wlasciciel.Imie, Wlasciciel.Nazwisko, COUNT(DISTINCT B.ID_wizyty) AS Liczba_Wizyt
	FROM Wlasciciel
	JOIN Zwierze Z ON Wlasciciel.PESEL = Z.PESEL_wlasciciela
	JOIN Wizyta B ON Z.ID = B.ID_zwierzecia
	GROUP BY Wlasciciel.Imie, Wlasciciel.Nazwisko
	ORDER BY Liczba_Wizyt DESC;
GO
SELECT * FROM TopOwners;


-- Query 7: Znajd� lek o najwi�kszej liczbie przypisa�, przy czym recepty nie mog� by� starsze ni� rok.
-- Scenariusz: Klinika chce podj�� wsp�prac� z firm� farmaceutyczn�. Wsp�praca ma polega� na tym, �e weterynarze przypisywa� b�d� lek danej firmy,
-- a nie firmy konkurencyjnej (tylko wtedy, gdy b�dzie to niezb�dne), dlatego te� szuka najcz�ciej przypisywanego leku.

DROP VIEW IF EXISTS MostPrescribedMedicine;
GO
CREATE VIEW MostPrescribedMedicine 
	(ID_Leku, Nazwa_Leku, Liczba_Przypisan)
	AS SELECT Leki.ID_leku, Leki.Nazwa_Leku, COUNT(Przypisane_leki.ID_przypisanego_leku) AS Liczba_Przypisan
	FROM Leki
	JOIN Przypisane_leki ON Leki.ID_leku = Przypisane_leki.ID_leku
	JOIN Wizyta ON Przypisane_leki.ID_wizyty = Wizyta.ID_wizyty
	WHERE EXISTS (
			SELECT 1
			FROM Przypisane_leki
			WHERE Przypisane_leki.ID_leku = Leki.ID_leku AND Wizyta.Data_wizyty >= DATEADD(MONTH, -12, GETDATE()))
	GROUP BY Leki.ID_leku, Leki.Nazwa_Leku;
GO
SELECT TOP 1 ID_Leku, Nazwa_Leku, Liczba_Przypisan
FROM MostPrescribedMedicine
ORDER BY Liczba_Przypisan DESC;


-- Query 8: Policz wyst�pienia jednakowego dawkowania Magnezu przypisanych podczas wizyt ps�w.
-- Scenariusz: Niedo�wiadczony weterynarz chce przypisa� Magnez, ale nie wie jak� nale�y przydzieli� dawk�.
-- Chce on wyszuka� dla danego leku dawk�, kt�ra by�a najcz�ciej przypisywana psom.

SELECT Przypisane_leki.Ilosc, COUNT(Przypisane_leki.ID_przypisanego_leku) AS Liczba_Przepisanych_Lekow
FROM Przypisane_leki
JOIN Leki ON Przypisane_leki.ID_leku = Leki.ID_leku
WHERE Leki.Nazwa_Leku = 'Magnez' AND Przypisane_leki.Ilosc IS NOT NULL
GROUP BY Przypisane_leki.Ilosc
ORDER BY Liczba_Przepisanych_Lekow DESC;


-- Query 9: Nale�y znale�� ID zwierz�cia, dla kt�rego Imie_w�a�ciciela zaczyna si� na 'A', Nazwisko_w�a�ciciela zaczyna si� na 'No', 
-- a ID zwierz�cia zawiera w sobie fragment '6127'
-- Scenariusz: Weterynarz zala� kaw� kartk�, kt�ra zawiera�a dane zwierz�cia i jego w�a�ciciela (nie zd��y� jeszcze wprowadzi� danych do systemu). 
-- Jedyne fragmenty danych, jakie nie rozmaza�y si� to: "Imie w�a�ciciela: A", "Nazwisko w�a�ciciela: No", "Id_zwierz�cia: 6127"

SELECT Zwierze.ID AS ID_zwierz�cia
FROM Zwierze
JOIN Wlasciciel ON Zwierze.PESEL_wlasciciela = Wlasciciel.PESEL
WHERE 
    LEFT(Wlasciciel.Imie, 1) = 'A'
    AND LEFT(Wlasciciel.Nazwisko, 2) = 'No'
    AND Zwierze.ID LIKE '%6127%';
