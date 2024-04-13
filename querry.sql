-- Query 1: ZnajdŸ lekarzy, którzy obs³ugiwali co najmniej trzy ró¿ne gatunki zwierz¹t
-- Scenariusz: Klinika weterynaryjna chce weryfikowaæ umiejêtnoœci i doœwiadczenie swoich lekarzy. 
-- Szukaj¹ lekarzy, którzy obs³ugiwali co najmniej trzy ró¿ne gatunki zwierz¹t. 

SELECT Weterynarz.PESEL, Weterynarz.Imie AS Weterynarz_Imie, Weterynarz.Nazwisko AS Weterynarz_Nazwisko
FROM Weterynarz
JOIN Wizyta ON Weterynarz.PESEL = Wizyta.PESEL_weterynarza
JOIN Zwierze ON Wizyta.ID_zwierzecia = Zwierze.ID
GROUP BY Weterynarz.PESEL, Weterynarz.Imie, Weterynarz.Nazwisko
HAVING COUNT(DISTINCT Zwierze.Gatunek) >= 3;


-- Query 2: Zapytanie: Podaj datê szczepienia o nazwie „Nosówka” 
-- dla zwierzêcia o danym ID zwiêkszon¹ o 3 lata (bêdzie to pierwszy termin kiedy mo¿na zaszczepiæ ponownie zwierzê).
-- Scenariusz: Istniej¹ szczepienia cykliczne dla zwierz¹t, tzn. takie, które wykonuje siê co 3 lata. Weterynarz chce sprawdziæ, kiedy ostatni 
-- raz wykonane zosta³o dla danego zwierzêcia szczepienie przeciwko wirusowi nosówki, by wyznaczyæ termin kolejnego szczepienia. 

SELECT Zwierze.ID, Zwierze.Imie AS Zwierze_Imie, DATEADD(YEAR, 3, MAX(Szczepienia.Data_szczepienia)) AS Nastêpne_Szczepienie
FROM Zwierze
JOIN Szczepienia ON Zwierze.ID = Szczepienia.ID_zwierzecia
WHERE  Szczepienia.Nazwa_Szczepienia = 'Nosówka' AND
	Zwierze.ID IN (
	SELECT ID_zwierzecia
    FROM Szczepienia
    WHERE Szczepienia.Nazwa_Szczepienia = 'Nosówka' AND Szczepienia.Data_szczepienia IS NOT NULL
    GROUP BY ID_zwierzecia)
GROUP BY Zwierze.ID, Zwierze.Imie, Szczepienia.Data_szczepienia
ORDER BY Nastêpne_Szczepienie ASC;


-- Query 3: Zwróæ dane do wys³ania listu (godnoœæ, miejscowoœæ, ulica, numer domu, kod pocztowy) dla w³aœcicieli zwierz¹t 
-- jeœli ich zwierzê nie ma aktualnego szczepienia "Nosówka" zrobionego w ci¹gu ostatnich 3 lat. 
-- Nawet je¿eli osoba ma kilka zwierz¹t to musi dostaæ tylko jeden list.
-- Scenariusz: Istniej¹ szczepienia cykliczne dla zwierz¹t, tzn. takie, które wykonuje siê co 3 lata. 
-- Administrator lecznicy wysy³a przypomnienie o potrzebie powtórnego szczepienia.

SELECT DISTINCT
       Wlasciciel.Imie AS Wlasciciel_Imie, 
	   Wlasciciel.Nazwisko AS Wlasciciel_Nazwisko, 
       Wlasciciel.Miejscowosc AS Miejscowosc, 
       Wlasciciel.Ulica AS Ulica, 
       Wlasciciel.Numer_domu AS Numer_Domu, 
       Wlasciciel.Kod_pocztowy AS Kod_Pocztowy
FROM Wlasciciel
JOIN Zwierze ON Wlasciciel.PESEL = Zwierze.PESEL_wlasciciela
LEFT JOIN Szczepienia ON Zwierze.ID = Szczepienia.ID_zwierzecia AND Szczepienia.Nazwa_Szczepienia = 'Nosówka' AND Szczepienia.Data_szczepienia >= DATEADD(YEAR, -3, GETDATE())
WHERE Szczepienia.ID_szczepienia IS NULL
ORDER BY Wlasciciel.Imie;


-- Query 4: Zwróæ miejscowoœci, gdzie najczêœciej diagnozowano grypê w ci¹gu ostatnich 3 miesiêcy
-- Scenariusz: Wybuch³a epidemia grypy. Aby móc ostrzec okolicznych w³aœcicieli zwierz¹t, szukane jest miejsce,
-- w którym w ostatnim czasie wykryto najwiêksz¹ iloœæ wyst¹pieñ tej choroby.

SELECT Wlasciciel.Miejscowosc, COUNT(DISTINCT Historie_Chorob.ID_wizyty) AS Liczba_Wystapien
FROM Wizyta
JOIN Zwierze ON Wizyta.ID_zwierzecia = Zwierze.ID
JOIN Wlasciciel ON Zwierze.PESEL_wlasciciela = Wlasciciel.PESEL
JOIN Historie_Chorob ON Wizyta.ID_wizyty = Historie_Chorob.ID_wizyty
JOIN Choroby ON Historie_Chorob.ID_choroby = Choroby.ID_choroby
WHERE Choroby.Nazwa_Choroby = 'Grypa' AND Wizyta.Data_wizyty >= DATEADD(MONTH, -3, GETDATE())
GROUP BY Wlasciciel.Miejscowosc
ORDER BY Liczba_Wystapien DESC;


-- Query 5: Zwróæ listê rodzajów badañ posortowanych po iloœci odbytych badañ. 
-- Scenariusz: W³aœciciel chce kupiæ nowe sprzêty do wykonywania badañ. Zastanawia siê, który sprzêt jest najczêœciej 
-- wykorzystywany (które badania s¹ najczêœciej wykonywane). 

SELECT Rodzaje_badan.Nazwa_Badania, COUNT(Badania.ID_wykonanego_badania) AS Liczba_Wykonanych_Testow
FROM Rodzaje_badan
JOIN Badania ON Rodzaje_badan.ID_badania = Badania.ID_badania
GROUP BY Rodzaje_badan.Nazwa_Badania
ORDER BY Liczba_Wykonanych_Testow DESC;


-- Query 6: Zwróæ 5 w³aœcicieli, których zwierzêta odby³y najwiêksz¹ iloœæ wizyt (jeœli jest wiêcej ni¿ jedno liczymy ³¹czn¹ iloœæ).
-- Scenariusz: Zarz¹d kliniki postanowi³ wprowadziæ karty sta³ego klienta. Zostan¹ one przyznane 5 w³aœcicielom, 
-- których zwierzêta odby³y w sumie najwiêksz¹ liczbê wizyt.

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


-- Query 7: ZnajdŸ lek o najwiêkszej liczbie przypisañ, przy czym recepty nie mog¹ byæ starsze ni¿ rok.
-- Scenariusz: Klinika chce podj¹æ wspó³pracê z firm¹ farmaceutyczn¹. Wspó³praca ma polegaæ na tym, ¿e weterynarze przypisywaæ bêd¹ lek danej firmy,
-- a nie firmy konkurencyjnej (tylko wtedy, gdy bêdzie to niezbêdne), dlatego te¿ szuka najczêœciej przypisywanego leku.

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


-- Query 8: Policz wyst¹pienia jednakowego dawkowania Magnezu przypisanych podczas wizyt psów.
-- Scenariusz: Niedoœwiadczony weterynarz chce przypisaæ Magnez, ale nie wie jak¹ nale¿y przydzieliæ dawkê.
-- Chce on wyszukaæ dla danego leku dawkê, która by³a najczêœciej przypisywana psom.

SELECT Przypisane_leki.Ilosc, COUNT(Przypisane_leki.ID_przypisanego_leku) AS Liczba_Przepisanych_Lekow
FROM Przypisane_leki
JOIN Leki ON Przypisane_leki.ID_leku = Leki.ID_leku
WHERE Leki.Nazwa_Leku = 'Magnez' AND Przypisane_leki.Ilosc IS NOT NULL
GROUP BY Przypisane_leki.Ilosc
ORDER BY Liczba_Przepisanych_Lekow DESC;


-- Query 9: Nale¿y znaleŸæ ID zwierzêcia, dla którego Imie_w³aœciciela zaczyna siê na 'A', Nazwisko_w³aœciciela zaczyna siê na 'No', 
-- a ID zwierzêcia zawiera w sobie fragment '6127'
-- Scenariusz: Weterynarz zala³ kaw¹ kartkê, która zawiera³a dane zwierzêcia i jego w³aœciciela (nie zd¹¿y³ jeszcze wprowadziæ danych do systemu). 
-- Jedyne fragmenty danych, jakie nie rozmaza³y siê to: "Imie w³aœciciela: A", "Nazwisko w³aœciciela: No", "Id_zwierzêcia: 6127"

SELECT Zwierze.ID AS ID_zwierzêcia
FROM Zwierze
JOIN Wlasciciel ON Zwierze.PESEL_wlasciciela = Wlasciciel.PESEL
WHERE 
    LEFT(Wlasciciel.Imie, 1) = 'A'
    AND LEFT(Wlasciciel.Nazwisko, 2) = 'No'
    AND Zwierze.ID LIKE '%6127%';
