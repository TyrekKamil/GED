SELECT COUNT(*) FROM Klienci
-- (11 rows affected)
SELECT * FROM Towary
-- (26 rows affected)
SELECT COUNT(*) FROM Regiony
-- (7 rows affected)
SELECT * FROM Czas
-- (204 rows affected)
SELECT * FROM Sprzedaz_hist
-- (15773 rows affected)
SELECT * FROM Sprzedaz_plan
-- (2026 rows affected)

-------------------------------------------------
-- zad 3 --
WITH CTE_Suma
AS
   (SELECT SUM(sprzedaz_hist.Ilosc) Ilosc_hist
    FROM sprzedaz_hist
	JOIN Czas czas
	ON sprzedaz_hist.Czas_Id = czas.Id AND czas.Rok = 2007 AND czas.Miesiac <= 4
	JOIN sprzedaz_plan
	ON sprzedaz_plan.Region_Id = Sprzedaz_hist.Region_Id AND sprzedaz_plan.Czas_Id = czas.Id AND czas.Rok = 2007 AND czas.Miesiac <= 4
	GROUP BY sprzedaz_hist.Region_Id
	JOIN Czas czas
	ON czas.rok = 2007  AND  czas.Miesiac = 4 AND czas.Id = planS.Czas_Id AND czas.Id = histS.Czas_Id
	JOIN Regiony region
	ON region.id = planS.Region_id
	GROUP BY region.Region
   )
SELECT *
FROM CTE_Suma


WITH cte_suma AS	
	(   SELECT SUM(sprzedaz_hist.ilosc) hist_ilosc, SUM(sprzedaz_plan.ilosc) plan_ilosc, Regiony.Region
		FROM sprzedaz_hist
		JOIN Sprzedaz_plan
		ON Sprzedaz_plan.Region_Id = Sprzedaz_hist.Region_Id
		JOIN Regiony
		ON Regiony.Id = Sprzedaz_plan.Region_Id
		JOIN Czas
		ON Czas.Id = Sprzedaz_plan.Czas_Id AND Czas.Id = Sprzedaz_hist.Czas_Id
		WHERE Czas.rok = 2007
		GROUP BY Regiony.Region
	 )
SELECT *
FROM cte_suma


	SELECT * 
	FROM
		(SELECT SUM(sprzedaz_hist.ilosc), SUM(sprzedaz_plan.ilosc), Regiony.Region
		FROM sprzedaz_hist
		JOIN sprzedaz_plan
		ON sprzedaz_plan.Region_Id = sprzedaz_hist.Region_Id
		JOIN Regiony
		ON Regiony.Id = sprzedaz_plan.Region_Id
		JOIN Czas
		ON Czas.Id = sprzedaz_plan.Czas_Id AND Czas.Id = Sprzedaz_hist.Czas_Id AND czas.Rok = 2007 
		GROUP BY Regiony.Region)



-- zad 4 --
WITH CTE AS (
SELECT T.Towar, sum(obrot) Obrot, C.Kwartal,
rownum = ROW_NUMBER() OVER (ORDER BY T.Towar, C.Kwartal)
FROM Sprzedaz_hist
JOIN Towary T
ON T.id = Towary_Id
JOIN Czas c
ON Czas_Id = C.Id
WHERE Czas_Id LIKE '%2006' AND T.Podgrupa = 'okapy'
GROUP BY T.Towar, C.Kwartal
)
SELECT CTE.Towar, CTE.Kwartal, CTE.obrot as 'obrot biezacy kwartal', prev.Obrot as 'obrot poprzedni kwartal',
CASE WHEN CTE.obrot - prev.obrot > 0 
	 THEN 'wzrost'
	 WHEN prev.Obrot is null 
	 THEN '-'
	 ELSE 'spadek'
     END AS 'bilans'
FROM CTE
LEFT JOIN CTE prev ON prev.rownum = CTE.rownum - 1 AND CTE.Kwartal != 1
GO