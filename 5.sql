
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
