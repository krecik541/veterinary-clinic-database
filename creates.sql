DROP TABLE IF EXISTS Historie_Chorob, Przypisane_leki, Badania, Leki, Rodzaje_badan, Choroby, Wizyta, Weterynarz, Szczepienia, Zwierze, Wlasciciel;
CREATE TABLE Wlasciciel (
	Imie NVARCHAR(20) CHECK (Imie LIKE N'[A-Z•∆ £—”åèØ]%' AND (Imie NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø]%') AND LEN(Imie) BETWEEN 2 AND 20) NOT NULL,
	Nazwisko NVARCHAR(25) CHECK (Nazwisko LIKE N'[A-Z•∆ £—”åèØ]%' AND (Nazwisko NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø\-]%') AND LEN(Nazwisko) BETWEEN 2 AND 25) NOT NULL,
	Nr_Telefonu VARCHAR(9) CHECK (LEN(Nr_Telefonu) = 9 AND Nr_Telefonu NOT LIKE '%[^0-9]%'),
    Adres_email NVARCHAR(50) CHECK (Adres_email LIKE '%@%.%' AND LEN(Adres_email) BETWEEN 6 AND 50),
    PESEL CHAR(11) PRIMARY KEY CHECK (PESEL NOT LIKE '%[^0-9]%' AND LEN(PESEL) = 11),
    Miejscowosc NVARCHAR(40) CHECK (Miejscowosc LIKE N'[A-Z•∆ £—”åèØ]%' AND (Miejscowosc NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø\-]%') and LEN(Miejscowosc) BETWEEN 3 AND 40),
    Ulica NVARCHAR(255),
    Numer_domu NVARCHAR(10) CHECK (Numer_domu LIKE '%[0-9A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø/]%' AND LEN(Numer_domu) BETWEEN 1 AND 10),
    Kod_pocztowy VARCHAR(6) CHECK (Kod_pocztowy LIKE '[0-9][0-9]-[0-9][0-9][0-9]')
);

CREATE TABLE Zwierze (
    ID CHAR(15) PRIMARY KEY CHECK (LEN(ID) = 15),
    Imie NVARCHAR(20) CHECK (Imie LIKE N'[A-Z•∆ £—”åèØ]%' AND (Imie NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø]%') AND LEN(Imie) BETWEEN 2 AND 20),
    Data_urodzenia DATE NOT NULL,
    Gatunek VARCHAR(25) CHECK (Gatunek LIKE N'[A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø]%' AND (Gatunek NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø ]%') AND LEN(Gatunek) BETWEEN 3 AND 25) NOT NULL,
    Rasa VARCHAR(25) CHECK (Rasa LIKE N'[A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø]%' AND (Rasa NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø ]%') AND LEN(Rasa) BETWEEN 2 AND 25) NOT NULL,
    Plec CHAR(1) CHECK (Plec IN ('M', 'Ø')),
    PESEL_wlasciciela CHAR(11) NOT NULL,
    FOREIGN KEY (PESEL_wlasciciela) REFERENCES Wlasciciel(PESEL)
);

CREATE TABLE Weterynarz (
    PESEL VARCHAR(11) PRIMARY KEY CHECK (PESEL NOT LIKE '%[^0-9]%' AND LEN(PESEL) = 11),
    Imie NVARCHAR(20) CHECK (Imie LIKE N'[A-Z•∆ £—”åèØ]%' AND (Imie NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø]%') AND LEN(Imie) BETWEEN 2 AND 20) NOT NULL,
    Nazwisko NVARCHAR(25) CHECK (Nazwisko LIKE N'[A-Z•∆ £—”åèØ]%' AND (Nazwisko NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø\-]%') AND LEN(Nazwisko) BETWEEN 2 AND 25) NOT NULL,
    Adres_email NVARCHAR(50) CHECK (Adres_email LIKE '%@%.%' AND LEN(Adres_email) BETWEEN 6 AND 50),
    Nr_Telefonu VARCHAR(9) CHECK (LEN(Nr_Telefonu) = 9 AND Nr_Telefonu NOT LIKE '%[^0-9]%'),
    Specjalizacja NVARCHAR(50) CHECK (Specjalizacja NOT LIKE N'%[^A-Z•∆ £—”åèØa-zπÊÍ≥ÒÛúüø/ ]%' AND LEN(Specjalizacja) BETWEEN 5 AND 50)
);

CREATE TABLE Wizyta (
    ID_wizyty VARCHAR(15) PRIMARY KEY CHECK (ID_wizyty NOT LIKE '%[^0-9]%' AND LEN(ID_wizyty) = 15),
    Data_wizyty DATE NOT NULL,
    Godzina TIME NOT NULL,
    Zalecenia VARCHAR(MAX) CHECK (LEN(Zalecenia) >= 30),
    ID_zwierzecia CHAR(15) NOT NULL,
    FOREIGN KEY (ID_zwierzecia) REFERENCES Zwierze(ID) ON UPDATE CASCADE,
    PESEL_weterynarza VARCHAR(11) NOT NULL,
    FOREIGN KEY (PESEL_weterynarza) REFERENCES Weterynarz(PESEL)
);

CREATE TABLE Rodzaje_badan (
    ID_badania INT IDENTITY(1,1) PRIMARY KEY CHECK (ID_badania BETWEEN 1 AND 1000),
    Nazwa_Badania NVARCHAR(25) CHECK (LEN(Nazwa_Badania) BETWEEN 3 AND 25 AND Nazwa_Badania NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ ]%') NOT NULL
);

CREATE TABLE Choroby (
    ID_choroby INT IDENTITY(1,1) PRIMARY KEY CHECK (ID_choroby BETWEEN 1 AND 10000),
    Nazwa_Choroby NVARCHAR(25) CHECK (LEN(Nazwa_Choroby) BETWEEN 3 AND 25  AND Nazwa_Choroby NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ ]%') NOT NULL
);

CREATE TABLE Badania (
    ID_wykonanego_badania VARCHAR(15) PRIMARY KEY CHECK (LEN(ID_wykonanego_badania) = 15 AND ID_wykonanego_badania NOT LIKE '%[^0-9]%'),
    WynikBadania VARCHAR(MAX) CHECK (LEN(WynikBadania) >= 30 AND WynikBadania NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ0-9\-+/*!@#$%^&*()_=?,. ]%') NOT NULL,
    ID_badania INT NOT NULL,
    FOREIGN KEY (ID_badania) REFERENCES Rodzaje_badan(ID_badania),
    ID_wizyty VARCHAR(15) NOT NULL,
    FOREIGN KEY (ID_wizyty) REFERENCES Wizyta(ID_wizyty)
);

CREATE TABLE Historie_Chorob (
    ID_zdarzenia VARCHAR(15) PRIMARY KEY CHECK (LEN(ID_zdarzenia) = 15 AND ID_zdarzenia NOT LIKE '%[^0-9]%'),
    Opis_Diagnozy NVARCHAR(MAX) CHECK (LEN(Opis_Diagnozy) >= 30 AND Opis_Diagnozy NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ0-9\-+/*!@#$%^&*()_=?. ]%') NOT NULL,
    ID_choroby INT NOT NULL,
    FOREIGN KEY (ID_choroby) REFERENCES Choroby(ID_choroby) ON DELETE CASCADE,
    ID_wizyty VARCHAR(15) NOT NULL,
    FOREIGN KEY (ID_wizyty) REFERENCES Wizyta(ID_wizyty) 
);

CREATE TABLE Szczepienia (
    ID_szczepienia VARCHAR(7) PRIMARY KEY CHECK (LEN(ID_szczepienia) = 7 AND ID_szczepienia NOT LIKE '%[^0-9]%'),
    Nazwa_Szczepienia NVARCHAR(30) CHECK (LEN(Nazwa_Szczepienia) BETWEEN 5 AND 30 AND Nazwa_Szczepienia NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ ]%') NOT NULL,
    Data_szczepienia DATE NOT NULL,
    ID_zwierzecia CHAR(15) NOT NULL,
    FOREIGN KEY (ID_zwierzecia) REFERENCES Zwierze(ID) ON UPDATE CASCADE
);

CREATE TABLE Leki (
    ID_leku VARCHAR(10) PRIMARY KEY CHECK (LEN(ID_leku) BETWEEN 7 AND 10 AND ID_leku NOT LIKE '%[^0-9]%'),
    Nazwa_Leku NVARCHAR(40) CHECK (LEN(Nazwa_Leku) BETWEEN 3 AND 40 AND Nazwa_Leku NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ0-9 ]%') NOT NULL,
    Dawka NVARCHAR(5) CHECK (LEN(Dawka) BETWEEN 1 AND 5 AND Dawka NOT LIKE '%[^0-9]%') NOT NULL,
    Jednostka_Dawki NVARCHAR(15) CHECK (LEN(Jednostka_Dawki) BETWEEN 2 AND 15 AND Jednostka_Dawki NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ0-9\-+/*!@#$%^&*()_=?.  ]%') NOT NULL
);

CREATE TABLE Przypisane_leki (
    ID_przypisanego_leku VARCHAR(15) PRIMARY KEY CHECK (LEN(ID_przypisanego_leku) = 15 AND ID_przypisanego_leku NOT LIKE '%[^0-9]%'),
    Sposob_Uzycia VARCHAR(MAX) CHECK (LEN(Sposob_Uzycia) >= 20 AND Sposob_Uzycia NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ0-9\-+/*!@#$%^&*()_=?,. ]%') NOT NULL,
    Ilosc NVARCHAR(20) CHECK (LEN(Ilosc) BETWEEN 3 AND 20 AND Ilosc NOT LIKE '%[^a-zA-ZπÊÍ≥ÒÛúüø•∆ £—”åèØ0-9\-+/*!@#$%^&*()_=? ]%') NOT NULL,
    ID_wizyty VARCHAR(15) NOT NULL,
    FOREIGN KEY (ID_wizyty) REFERENCES Wizyta(ID_wizyty),
    ID_leku VARCHAR(10) NOT NULL,
    FOREIGN KEY (ID_leku) REFERENCES Leki(ID_leku)
);

-- Wype≥nienie tabeli Wlasciciel
INSERT INTO Wlasciciel (Imie, Nazwisko, Nr_Telefonu, Adres_email, PESEL, Miejscowosc, Ulica, Numer_domu, Kod_pocztowy)
VALUES
('Jan', 'Kowalski', '534864167', 'jan.kowalski@gmail.com', '89010112345', 'Warszawa', 'Marsza≥kowska', '12', '00-001'),
('Anna', 'Nowak', '601972567', 'anna.nowak@wp.pl', '78020298765', 'KrakÛw', 'D≥uga', '34', '30-001'),
('Marek', 'Lis', '789423156', 'marek.lis@o2.pl', '92030387654', 'GdaÒsk', 'NadwiúlaÒska', '56/2', '80-001'),
('Alicja', 'Wiúniewska', '812349758', 'alicja.wisniewska@interia.pl', '85121265432', 'PoznaÒ', 'Lecha', '78', '60-001'),
('Alek', 'Nowaczewski', '795164567', 'alek.kaczmarek@gmail.com', '95050578901', 'Wroc≥aw', 'S≥owiaÒska', '90', '50-001'),
('Zofia', 'Nowicka', '512345678', 'zofia.nowicka@wp.pl', '80060687654', '£Ûdü', 'Piotrkowska', '14', '90-001'),
('Krzysztof', 'SzymaÒski', '701234567', 'krzysztof.szymanski@gmail.com', '92070798765', 'Warszawa', 'Wita Stwosza', '45', '40-001'),
('Iwona', 'Dπbrowska', '812345678', 'iwona.dabrowska@o2.pl', '90080865432', 'Gdynia', 'Koúciuszki', '67/3', '81-001'),
('Marcin', 'Jaworski', '601234567', 'marcin.jaworski@interia.pl', '91090978901', 'Szczecin', 'Jana Paw≥a II', '78', '70-001'),
('Natalia', 'Mazurek', '879542167', 'natalia.mazurek@gmail.com', '89110112345', 'Bydgoszcz', 'åniadeckich', '23', '85-001'),
('Ewa', 'Malinowska', '657890123', 'ewa.malinowska@gmail.com', '92030378901', 'GdaÒsk', 'Brzozowa', '7', '80-001'),
('Tomasz', 'Kwiatkowski', '975432156', 'tomasz.kwiatkowski@wp.pl', '88020245678', 'PoznaÒ', 'Klonowa', '12', '60-002'),
('Agnieszka', 'ZieliÒska', '789012345', 'agnieszka.zielinska@o2.pl', '90010123456', 'Wroc≥aw', 'S≥owiaÒska', '5', '50-003'),
('Kamil', 'Nowakowski', '608765432', 'kamil.nowakowski@interia.pl', '81070734567', 'KrakÛw', 'Cicha', '2', '30-004'),
('Anna', 'Lis', '700101010', 'anna.lis@onet.pl', '95050567890', 'Warszawa', 'Øeromskiego', '15', '00-005'),
('Bartosz', 'Krawczyk', '555333555', 'bartosz.krawczyk@gmail.com', '93030311111', 'Gdynia', '3 Maja', '33', '81-006'),
('Karolina', 'Jaworska', '666444777', 'karolina.jaworska@wp.pl', '88080898765', '£Ûdü', 'Piotrkowska', '44', '90-007'),
('Micha≥', 'SzymaÒski', '777222333', 'michal.szymanski@o2.pl', '90121254321', 'Warszawa', 'Armii Krajowej', '23', '40-008'),
('Natalia', 'Czarnecka', '888111444', 'natalia.czarnecka@interia.pl', '99090976543', 'Szczecin', 'WyszyÒskiego', '9', '70-009'),
('Piotr', 'Kaczmarek', '999000111', 'piotr.kaczmarek@onet.pl', '88010123232', 'Bydgoszcz', 'WspÛlna', '21', '85-010');


-- Wype≥nienie tabeli Zwierze
-- Wype≥nienie tabeli Zwierze
INSERT INTO Zwierze (ID, Imie, Data_urodzenia, Gatunek, Rasa, Plec, PESEL_wlasciciela)
VALUES
('738209487123456', 'Burek', '2018-03-15', 'Pies', 'Labrador', 'M', '89010112345'),
('560913824567890', 'Mruczek', '2020-05-20', 'åwinka morska', 'Teddy', 'Ø', '78020298765'),
('214567890123456', 'Rex', '2019-07-10', 'Pies', 'Owczarek niemiecki', 'M', '92030387654'),
('981235674567890', 'Puszek', '2022-01-05', 'Kot', 'Pers', 'Ø', '85121265432'),
('653478912345678', 'Luna', '2021-08-12', 'Kot', 'Syjamski', 'Ø', '95050578901'),
('345678901234567', 'Azor', '2020-02-28', 'åwinka morska', 'AbisyÒska', 'M', '80060687654'),
('876543210987654', 'ånieøka', '2017-11-10', 'Kot', 'Brytyjski', 'Ø', '92070798765'),
('432109876543210', 'Max', '2019-04-03', 'Jaszczurka', 'Agama', 'M', '90080865432'),
('789012345678901', 'Bella', '2021-01-15', 'ØÛ≥w', 'B≥otny', 'Ø', '91090978901'),
('234567890123456', 'Rocky', '2019-06-22', 'Pies', 'Siberian Husky', 'M', '89010112345'),
('567890123456789', 'åwierszcz', '2020-09-08', 'Kot', 'Rosyjski Niebieski', 'Ø', '89110112345'),
('109876543210987', 'Bonzo', '2021-03-12', 'Pies', 'Chihuahua', 'M', '92030387654'),
('890123456789012', 'Daisy', '2018-12-01', 'Wπø', 'Zaskroniec', 'Ø', '85121265432'),
('345612789098765', 'Tofik', '2020-04-18', 'Chomik', 'Roborowski', 'M', '95050578901'),
('876590123456789', 'Mila', '2019-10-05', 'Pies', 'Yorkshire Terrier', 'Ø', '80060687654'),
('543210987654321', 'Kajtek', '2018-12-10', 'Pies', 'Buldog', 'M', '88010123232'),
('456789012345678', 'Filemon', '2019-08-05', 'Papugi', 'Ara', 'Ø', '92030378901'),
('234567890198765', 'Luna', '2020-05-20', 'Jaszczurka', 'Legwan', 'Ø', '81070734567'),
('901234567890123', 'Cezar', '2019-04-15', 'Kot', 'Brytyjski', 'M', '95050567890'),
('678901234567890', 'Bella', '2018-10-22', 'Wπø', 'Pyton', 'Ø', '88020245678'),
('123456789012345', 'Mia', '2021-02-18', 'Kot', 'Ragdoll', 'Ø', '90010123456'),
('890123456789210', 'Max', '2020-07-30', 'Papugi', 'Kakadu', 'M', '93030311111'),
('456789012345601', 'Simba', '2019-06-12', 'Kot', 'Maine Coon', 'M', '88080898765'),
('765432109876543', 'Rex', '2022-01-05', 'Chomik', 'Døungarski', 'M', '90121254321'),
('543210987654789', 'Milo', '2021-11-08', 'Wπø', 'Kobra', 'M', '99090976543');


-- Wype≥nienie tabeli Weterynarz
INSERT INTO Weterynarz (PESEL, Imie, Nazwisko, Adres_email, Nr_Telefonu, Specjalizacja)
VALUES
('95010198765', 'Anna', 'Kowalczyk', 'anna.kowalczyk@gmail.com', '601234567', 'Chirurg weterynaryjny'),
('00020287654', 'Micha≥', 'Nowicki', 'michal.nowicki@o2.pl', '701234567', 'Dermatolog weterynaryjny'),
('87030376543', 'Magdalena', 'Lisowska', 'magdalena.lisowska@interia.pl', '812345678', 'Ortopeda weterynaryjny'),
('90040465432', 'Adam', 'Kowal', 'adam.kowal@gmail.com', '601234567', 'Internista weterynaryjny'),
('91050554321', 'Ewa', 'Nowakowska', 'ewa.nowakowska@wp.pl', '701234567', 'Neurolog weterynaryjny'),
('95050522222', 'Barbara', 'Ruk', 'barbara.wet@o2.pl', '600222333', 'Okulista'),
('94040433333', 'Krzysztof', 'B≥otnisty', 'krzysztof.wet@gmail.com', '611333444', 'Neurolog'),
('85030344444', 'Agnieszka', 'Lewandowska', 'agnieszka.wet@interia.pl', '722444555', 'Ortopeda'),
('75020255555', 'Marcin', 'Lewandowski', 'marcin.wet@wp.pl', '833555666', 'Onkolog'),
('90010166666', 'Zofia', 'Wrona', 'zofia.wet@onet.pl', '944666777', 'Kardiolog'),--nie mia≥a wizyty
('87070777777', 'Kamil', 'Øuraw', 'kamil.wet@gmail.com', '755777888', 'Internista'),
('78080888888', 'Anna', 'Kowalska', 'anna.wet@o2.pl', '866888999', 'Chirurg'),
('80070799999', 'Bart≥omiej', 'MuszyÒski', 'bartlomiej.wet@wp.pl', '977999000', 'Dermatolog'),
('89060600000', 'Natalia', 'Kowal', 'natalia.wet@interia.pl', '588000111', 'Endokrynolog'),
('86050511111', 'Pawe≥', 'Nowak', 'pawel.wet@onet.pl', '699111222', 'Radiolog');

-- Wype≥nienie tabeli Wizyta
INSERT INTO Wizyta (ID_wizyty, Data_wizyty, Godzina, Zalecenia, ID_zwierzecia, PESEL_weterynarza) VALUES
('123456015312345', '2024-01-10', '08:30', 'Przepisano antybiotyk w celu zwalczania infekcji oraz poprawy ogÛlnej kondycji zdrowotnej.', '738209487123456', '95010198765'),
('987567890123456', '2021-02-15', '09:45', 'Zalecone szczegÛ≥owe badania krwi w celu dok≥adnej analizy parametrÛw zdrowotnych.', '560913824567890', '00020287654'),
('345678901234977', '2021-03-20', '11:00', 'Przepisano leki przeciwbÛlowe w celu z≥agodzenia bÛlu oraz poprawy komfortu øycia zwierzÍcia.', '214567890123456', '87030376543'),
('498789012345678', '2021-04-25', '13:15', 'Zalecone szczepienie w celu ochrony przed okreúlonymi chorobami zakaünymi.', '981235674567890', '90040465432'),
('987890123456789', '2021-05-30', '14:30', 'Wizyta kontrolna w celu oceny ogÛlnego stanu zdrowia i ewentualnych zmian.', '653478912345678', '91050554321'),
('610901234567890', '2021-06-05', '16:45', 'Przepisano krople do uszu w celu leczenia ewentualnych infekcji lub problemÛw ze s≥uchem.', '345678901234567', '95050522222'),
('789518735678901', '2024-01-02', '18:00', 'Zalecana dieta dostosowana do potrzeb zdrowotnych zwierzaka.', '876543210987654', '94040433333'),
('899523456789012', '2023-11-15', '08:30', 'Zalecone szczegÛ≥owe badania moczu w celu wykrycia ewentualnych problemÛw zdrowotnych.', '432109876543210', '85030344444'),
('982314567890123', '2023-09-20', '09:45', 'Przepisano leki przeciwpasoøytnicze w celu eliminacji pasoøytÛw i poprawy zdrowia.', '789012345678901', '75020255555'),
('102345678901234', '2023-10-25', '11:00', 'Zalecone szczegÛ≥owe badania obrazowe w celu dok≥adnej diagnostyki.', '234567890123456', '78080888888'),
('994678901234567', '2023-11-30', '13:15', 'Przepisano leki przeciwkaszlowe w celu z≥agodzenia kaszlu i poprawy komfortu zwierzÍcia.', '567890123456789', '87070777777'),
('722789012345678', '2022-01-05', '14:30', 'Zalecone szczegÛ≥owe badania krwi w celu monitorowania parametrÛw zdrowotnych.', '109876543210987', '78080888888'), --brak badaÒ
('559890123456789', '2023-12-10', '16:45', 'Przepisano antybiotyk w celu zwalczania infekcji bakteryjnych.', '890123456789012', '80070799999'),
('676401234567890', '2022-03-15', '18:00', 'Zalecana kuracja witaminowa w celu wzmocnienia uk≥adu odpornoúciowego.', '345612789098765', '89060600000'),
('789012345678994', '2023-04-20', '08:30', 'Przepisano leki przeciwbÛlowe w celu z≥agodzenia bÛlu i poprawy samopoczucia.', '876590123456789', '86050511111'),
('890123454489012', '2023-05-25', '09:45', 'Zalecone szczepienie w celu ochrony przed konkretnymi chorobami zakaünymi.', '543210987654321', '95010198765'),
('901246567890123', '2022-06-30', '11:00', 'Wizyta kontrolna w celu oceny ewentualnych zmian w stanie zdrowia.', '456789012345678', '00020287654'), --brak chorÛb
('124566789012345', '2022-08-05', '13:15', 'Przepisano krople do oczu w celu leczenia problemÛw zwiπzanych z narzπdem wzroku.', '234567890198765', '87030376543'),
('234567890123664', '2022-09-10', '14:30', 'Zalecone szczegÛ≥owe badania krwi w celu dok≥adnej analizy parametrÛw zdrowotnych.', '901234567890123', '90040465432'),
('594378901234567', '2022-10-15', '16:45', 'Zalecone szczegÛ≥owe badania obrazowe w celu lepszego zrozumienia ewentualnych problemÛw zdrowotnych.', '678901234567890', '91050554321'),
('456789055345678', '2023-11-20', '18:00', 'Przepisano leki przeciwkaszlowe w celu z≥agodzenia kaszlu.', '123456789012345', '95050522222'),
('548890123456789', '2023-01-25', '08:30', 'Zalecone szczepienie w celu ochrony przed konkretnymi chorobami zakaünymi.', '890123456789210', '94040433333'),
('920901234567890', '2023-02-28', '09:45', 'Wizyta kontrolna w celu oceny ogÛlnego stanu zdrowia zwierzaka.', '456789012345601', '85030344444'),
('972012345678901', '2023-04-05', '11:00', 'Przepisano leki przeciwbÛlowe w celu z≥agodzenia bÛlu i poprawy samopoczucia.', '765432109876543', '75020255555'),
('890123498312012', '2023-05-10', '13:15', 'Zalecone szczegÛ≥owe badania moczu w celu oceny funkcji nerek i uk≥adu moczowego.', '543210987654789', '95010198765'),
('901234567855423', '2023-06-15', '14:30', 'Przepisano krople do uszu w celu leczenia problemÛw zwiπzanych z uchem.', '789012345678901', '78080888888'),
('123450987654321', '2023-10-20', '16:45', 'Zalecone szczegÛ≥owe badania krwi w celu dok≥adnej analizy parametrÛw zdrowotnych.', '653478912345678', '91050554321'),
('987654321098765', '2023-08-25', '18:00', 'Zalecone szczepienie w celu ochrony przed konkretnymi chorobami zakaünymi.', '543210987654789', '78080888888'),
('876549710987654', '2023-09-30', '08:30', 'Wizyta kontrolna w celu monitorowania zdrowia zwierzaka i ewentualnych zmian.', '738209487123456', '95010198765'),
('754432109876543', '2023-11-05', '09:45', 'Przepisano leki przeciwkaszlowe w celu z≥agodzenia kaszlu i poprawy samopoczucia.', '123456789012345', '87030376543'),
('654321098765432', '2023-12-10', '11:00', 'Zalecone szczegÛ≥owe badania obrazowe w celu dok≥adnej diagnostyki.', '901234567890123', '87070777777'),
('543210987654322', '2024-01-05', '13:15', 'Przepisano krople do oczu w celu leczenia ewentualnych problemÛw z narzπdem wzroku.', '234567890123456', '80070799999'),
('987409876543210', '2024-01-02', '14:30', 'Zalecone szczegÛ≥owe badania krwi w celu monitorowania zdrowia zwierzaka.', '738209487123456', '75020255555'),
('321098765432109', '2024-01-07', '16:45', 'Zalecone szczepienie w celu ochrony przed konkretnymi chorobami zakaünymi.', '653478912345678', '95050522222');


INSERT INTO Rodzaje_badan (Nazwa_Badania) VALUES
('Badanie krwi'),
('Badanie moczu'),
('Badanie ka≥u'),
('Badanie DNA'),
('USG'),
('Rentgen'),
('EKG'),
('Tomografia komputerowa'),
('USG'),
('Morfologia'),
('Holter EKG');

INSERT INTO Choroby (Nazwa_Choroby) VALUES
('Grypa'),
('Zapalenie zatok'),
('Z≥amanie koúci'),
('Alergia'),
('Choroba nerek'),
('Zapalenie oka'),
('Padaczka'),
('Dysplazja stawÛw'),
('NowotwÛr'),
('Choroba serca'),
('Zapalenie ucha'),
('Zakaøenie pasoøytnicze');

INSERT INTO Leki (ID_leku, Nazwa_Leku, Dawka, Jednostka_Dawki) VALUES
('8392751', 'Paracetamol', '500', 'mg'),
('62481793', 'Ibuprofen', '200', 'mg'),
('1057382', 'Antybiotyk', '1', 'tabl.'),
('49268105', 'Krople do nosa', '1', 'kropla'),
('7654322', 'Syrop na kaszel', '10', 'ml'),
('89012345', 'Witamina C', '1000', 'mg'),
('123456789', 'Przeciwhistaminowy', '10', 'mg'),
('56789012', 'Probiotyk', '1', 'kapsu≥ka'),
('876543210', 'Magnez', '300', 'mg'),
('98765432', 'Witamina D3', '800', 'j.m.');

INSERT INTO Szczepienia (ID_szczepienia, Nazwa_Szczepienia, Data_szczepienia, ID_zwierzecia) VALUES
('1894567', 'Wúcieklizna', '2021-05-10', '738209487123456'),
('9876984', 'Grypa kotÛw', '2021-06-15', '560913824567890'),
('8767890', 'Parwowiroza', '2021-07-20', '214567890123456'),
('7654321', 'Ospa prawdziwa', '2021-08-25', '981235674567890'),
('6972341', 'Kocia chlamydioza', '2021-09-30', '653478912345678'),
('8762432', 'Wirus panleukopenii', '2021-10-05', '345678901234567'),
('5432199', 'Leptospiroza', '2021-11-10', '876543210987654'),
('8901274', 'NosÛwka', '2021-12-15', '981235674567890'),
('3456789', 'NosÛwka', '2022-01-20', '789012345678901'),
('6789012', 'TÍøec', '2022-02-25', '214567890123456'),
('2109876', 'Riketsjoza', '2022-03-30', '567890123456789'),
('1098765', 'Parainfluenza', '2022-04-05', '109876543210987'),
('8165432', 'Babeszjoza', '2022-05-10', '890123456789012'),
('5432109', 'Choroba Rubartha', '2022-06-15', '109876543210987'),
('9876579', 'NosÛwka', '2022-07-20', '876590123456789'),
('3210987', 'Piroplazmoza', '2022-08-25', '543210987654321'),
('6543219', 'Cytomegalia kotÛw', '2022-09-30', '456789012345678'),
('8471234', 'Histoplazmoza', '2022-10-05', '234567890198765'),
('2349578', 'Alergia na kleszcze', '2022-11-10', '901234567890123'),
('7653321', 'NosÛwka', '2022-12-15', '678901234567890'),
('4567890', 'Kocia leukoza', '2023-01-20', '123456789012345'),
('1234567', 'Astma u kotÛw', '2023-02-25', '890123456789210'),
('8901234', 'Lisza choroba', '2023-03-30', '456789012345601'),
('5678901', 'Dur plamisty', '2023-04-05', '876590123456789'),
('2345678', 'NosÛwka', '2023-05-10', '543210987654789'),
('8765432', 'Grypa psÛw', '2023-06-15', '543210987654789'), 
('3686789', 'NosÛwka', '2023-07-20', '567890123456789'),
('9876543', 'NosÛwka', '2023-08-25', '109876543210987'),
('6543210', 'Promienica', '2023-09-30', '543210987654789'),
('2846876', 'Choroba ucha kotÛw', '2023-10-05', '876543210987654');

INSERT INTO Historie_Chorob (ID_zdarzenia, Opis_Diagnozy, ID_choroby, ID_wizyty) VALUES
('987654321012345', 'Zdiagnozowano grypÍ. Przepisano leki i zalecono odpoczynek.', 1, '123456015312345'),
('876543210123456', 'Podejrzenie zapalenia zatok. Zalecone badania krwi i konsultacja z lekarzem.', 2, '987567890123456'),
('765432109234567', 'Potwierdzone z≥amanie koúci. Skierowano na ortopediÍ.', 3, '345678901234977'),
('654321098345678', 'Zalecone szczepienie przeciwko chorobom zakaünym.', 12, '498789012345678'),
('432109876567890', 'Przepisano krople do uszu w zwiπzku z infekcjπ.', 11, '610901234567890'),
('321098765678901', 'Zalecana dieta w zwiπzku z problemami trawiennymi.', 1, '789518735678901'),
('210987654789012', 'Zalecone badania moczu w celu oceny funkcji nerek.', 1, '899523456789012'),
('109876543890123', 'Przepisano leki przeciwpasoøytnicze.', 12, '982314567890123'),
('987012345678901', 'Zalecone badania obrazowe w celu diagnostyki.', 8, '102345678901234'),
('876123456789012', 'Przepisano leki przeciwkaszlowe w zwiπzku z kaszlem.', 1, '994678901234567'),
('765234567890123', 'Zalecone badania krwi w celu oceny stanu zdrowia.', 1, '559890123456789'),
('654345678901234', 'Zdiagnozowano grypÍ. Przepisano leki i zalecono odpoczynek.', 1, '559890123456789'),
('432567890123456', 'Przepisano leki przeciwbÛlowe w zwiπzku z bÛlem.', 3, '789012345678994'),
('321678901234567', 'Zalecone szczepienie przeciwko chorobom zakaünym.', 12, '890123454489012'),
('109890123456789', 'Przepisano krople do oczu w zwiπzku z podraønieniem oczu.', 6, '124566789012345'),
('876891210987654', 'Zalecone badania krwi w celu oceny stanu zdrowia.', 10, '234567890123664'),
('841054321098765', 'Zalecone badania obrazowe w celu diagnostyki.', 9, '594378901234567'),
('876543210987123', 'Przepisano leki przeciwkaszlowe w zwiπzku z kaszlem.', 1, '456789055345678'),
('765432109876234', 'Zalecone szczepienie przeciwko chorobom zakaünym.', 12, '548890123456789'),
('543210987654456', 'Przepisano leki przeciwbÛlowe w zwiπzku z bÛlem.', 3, '972012345678901'),
('432109876543567', 'Zalecone badania moczu w celu oceny funkcji nerek.', 5, '890123498312012'),
('321098765432678', 'Przepisano krople do uszu w zwiπzku z infekcjπ.', 11, '901234567855423'),
('210987654321789', 'Zalecone badania krwi w celu oceny stanu zdrowia.', 1, '123450987654321'),
('109876543210890', 'Zdiagnozowano alergiÍ. Zalecone leki przeciwhistaminowe.', 4, '987654321098765'),
('877543210987654', 'Zdiagnozowano padaczkÍ. Zalecono skonsultowanie siÍ z neurologiem.', 7, '754432109876543'),
('765432109920143', 'Zalecone badania obrazowe w celu diagnostyki.', 8, '654321098765432'),
('654321098930132', 'Przepisano krople do oczu w zwiπzku z podraønieniem oczu.', 6, '543210987654322'),
('543210989710121', 'Zalecone badania krwi w celu oceny stanu zdrowia.', 1, '987409876543210'),
('432109876549630', 'Zdiagnozowano nowotwÛr. Zalecone leczenie onkologiczne.', 9, '321098765432109');

INSERT INTO Przypisane_leki (ID_przypisanego_leku, Sposob_Uzycia, Ilosc, ID_wizyty, ID_leku) VALUES
('102938475610293', 'PrzyjmowaÊ po posi≥ku, pÛ≥ godziny przed jedzeniem', '2 razy dziennie', '123456015312345', '8392751'),
('497890123456789', 'PrzyjmowaÊ przed posi≥kiem, najlepiej z duøπ iloúciπ wody', '1 raz dziennie', '987567890123456', '62481793'),
('987654321066345', 'StosowaÊ miejscowo, nak≥adaÊ na dotkniÍte miejsce delikatnymi ruchami', 'Wed≥ug potrzeb', '345678901234977', '1057382'),
('314159265358979', 'WstrzykiwaÊ domiÍúniowo, stosowaÊ jedynie pod nadzorem lekarza', '1 raz dziennie', '498789012345678', '7654322'),
('888888888888888', 'StosowaÊ do nosa, unikaÊ kontaktu z oczami', '1 kropla co 5 godzin', '610901234567890', '49268105'),
('123451234512345', 'StosowaÊ doustnie, popijaÊ szklankπ wody', '1 kapsu≥ka dziennie', '789518735678901', '89012345'),
('777777777777777', 'StosowaÊ przed snem, nie ≥πczyÊ z innymi lekami nasennymi', '1 raz dziennie', '899523456789012', '123456789'),
('555555555555555', 'StosowaÊ doustnie, nie przekraczaÊ zalecanej dawki', '1 raz dziennie', '982314567890123', '56789012'),
('999999999999999', 'StosowaÊ doustnie, rano i wieczorem', '2 razy dziennie', '102345678901234', '876543210'),
('246801357924680', 'StosowaÊ doustnie, przed posi≥kiem', '1 raz dziennie', '994678901234567', '98765432'),
('135791357913579', 'PrzyjmowaÊ po posi≥ku, nie spoøywaÊ z napojami gazowanymi', '2 razy dziennie', '559890123456789', '123456789'),
('101010101010101', 'StosowaÊ doustnie, po posi≥ku', '1 raz dziennie', '559890123456789', '8392751'),
('888877776666555', 'WstrzykiwaÊ domiÍúniowo, stosowaÊ jedynie w warunkach sterylnych', '1 raz dziennie', '789012345678994', '876543210'),
('987123654789321', 'StosowaÊ do nosa, unikaÊ wdychania', '2 krople co 5 godzin', '890123454489012', '1057382'),
('222222222222222', 'StosowaÊ doustnie, popijaÊ duøπ iloúciπ wody', '1 kapsu≥ka dziennie', '901246567890123', '7654322'),
('232323232323232', 'WstrzykiwaÊ domiÍúniowo, unikaÊ miejsc podraønionych', '1 raz dziennie', '890123454489012', '876543210'),
('131313131313131', 'StosowaÊ do nosa, nak≥adaÊ delikatnie za pomocπ aplikatora', '1 kropla co 5 godzin', '982314567890123', '98765432'),
('454545454545454', 'StosowaÊ doustnie, nie podwajaÊ dawki', '1 raz dziennie', '982314567890123', '876543210'),
('987654321234567', 'StosowaÊ przed snem, nie ≥πczyÊ z alkoholem', '1 raz dziennie', '548890123456789', '98765432'),
('888543210987654', 'StosowaÊ doustnie, rano przed úniadaniem', '1 raz dziennie', '548890123456789', '56789012'),
('999111222333444', 'StosowaÊ doustnie, rano i wieczorem', '2 razy dziennie', '754432109876543', '876543210'),
('543210973101521', 'PrzyjmowaÊ po posi≥ku, popijaÊ sokiem pomaraÒczowym', '2 razy dziennie', '654321098765432', '98765432'),
('135792468024680', 'StosowaÊ doustnie, popijaÊ duøπ iloúciπ wody', '1 raz dziennie', '123456015312345', '123456789'),
('864209731357419', 'WstrzykiwaÊ domiÍúniowo, unikaÊ miejsc podraønionych', '1 raz dziennie', '594378901234567', '56789012'),
('975318642097531', 'StosowaÊ do nosa, nie przekraczaÊ 3 razy dziennie', '2 krople co 5 godzin', '498789012345678', '876543210');

INSERT INTO Badania (ID_wykonanego_badania, WynikBadania, ID_badania, ID_wizyty) VALUES
('135792468024681', 'Wynik badaÒ krwi w normie. Brak odchyleÒ od wartoúci referencyjnych.', 1, '123456015312345'),
('246801357913579', 'Wynik moczu bez patologii. Brak obecnoúci bakterii ani innych nieprawid≥owoúci.', 2, '987567890123456'),
('357924680135792', 'Badanie ka≥u nie wykaza≥o obecnoúci pasoøytÛw ani innych nieprawid≥owoúci.', 3, '345678901234977'),
('468013579246801', 'Badanie DNA zidentyfikowa≥o zwierzÍ. Brak odchyleÒ genetycznych.', 4, '498789012345678'),
('579246801357924', 'USG jamy nosowej. Brak patologicznych zmian.', 5, '610901234567890'),
('680135792468013', 'Rentgen klatki piersiowej. Brak widocznych zmian strukturalnych.', 6, '789518735678901'),
('791357924680135', 'EKG w normie. RÛwnomierne rytmiczne tÍtno.', 7, '899523456789012'),
('802468013579246', 'Tomografia komputerowa jamy brzusznej. Brak patologii w narzπdach wewnÍtrznych.', 8, '982314567890123'),
('913579246801357', 'USG jamy miednicy. Brak widocznych nieprawid≥owoúci.', 9, '102345678901234'),
('531972468024681', 'Morfologia krwi. Wartoúci hemoglobiny i liczby krwinek w normie.', 10, '994678901234567'),
('642081357913579', 'Holter EKG przez 24 godziny. Nie stwierdzono arytmii ani nieprawid≥owoúci.', 11, '559890123456789'),
('753194680135792', 'Badanie krwi w normie. Wartoúci biochemiczne na w≥aúciwym poziomie.', 1, '559890123456789'),
('864013579246801', 'Badanie DNA. Zidentyfikowano genetyczne predyspozycje do pewnych schorzeÒ.', 4, '789012345678994'),
('975246801357924', 'USG nosa i zatok. Brak widocznych zmian strukturalnych.', 5, '890123454489012'),
('086013579246801', 'Rentgen jamy ustnej. Brak patologii w strukturze zÍbÛw.', 6, '901246567890123'),
('197135792468013', 'Morfologia krwi. Wartoúci hemoglobiny i liczby krwinek w normie.', 10, '890123454489012'),
('208246801357924', 'Tomografia komputerowa nosa i gard≥a. Brak patologicznych zmian.', 8, '982314567890123'),
('319357924680135', 'Badanie ka≥u nie wykaza≥o obecnoúci pasoøytÛw ani innych nieprawid≥owoúci.', 3, '982314567890123'),
('420468013579246', 'EKG w normie. RÛwnomierne rytmiczne tÍtno.', 7, '548890123456789'),
('531579246801357', 'Badanie krwi w normie. Wartoúci biochemiczne na w≥aúciwym poziomie.', 1, '548890123456789'),
('642680135792468', 'USG jamy miednicy. Brak widocznych nieprawid≥owoúci.', 9, '754432109876543'),
('753791357924680', 'Badanie moczu bez patologii. Brak obecnoúci bakterii ani innych nieprawid≥owoúci.', 2, '654321098765432'),
('864802468013579', 'Morfologia krwi. Wartoúci hemoglobiny i liczby krwinek w normie.', 10, '123456015312345'),
('975913579246801', 'Rentgen klatki piersiowej. Brak widocznych zmian strukturalnych.', 6, '594378901234567'),
('086024680135792', 'USG nosa i zatok. Brak widocznych zmian strukturalnych.', 5, '498789012345678');
