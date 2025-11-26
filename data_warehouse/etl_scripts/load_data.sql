USE Casino_DataWarehouse;
GO

SET LANGUAGE Polish;
GO

Declare @StartDate date;
Declare @EndDate date;

SELECT @StartDate = '2020-01-01', @EndDate = '2030-12-31';

Declare @DateInProcess date = @StartDate;

DECLARE @id INT = 1;

IF EXISTS (SELECT 1 FROM dbo.Data)
    SELECT @id = MAX(ID_Daty) + 1 FROM dbo.Data;

While @DateInProcess <= @EndDate
	Begin
		
		Insert Into dbo.Data 
		( 
			ID_Daty,
			PelnaData, 
			Rok, 
			Miesiac, 
			NazwaMiesiaca, 
			DzienTygodnia, 
			NazwaDniaTygodnia, 
			CzyWeekend
		)
		Values ( 
			@id,
			@DateInProcess, 
			Year(@DateInProcess), 
			Month(@DateInProcess), 
			Cast(DATENAME(month, @DateInProcess) as nvarchar(30)), 
			DATEPART(dw, @DateInProcess), 
			Cast(DATENAME(dw, @DateInProcess) as nvarchar(30)), 
			CASE 
				WHEN DATENAME(dw, @DateInProcess) IN ('Sobota', 'Niedziela') THEN 1
				ELSE 0
			END 
		);  
		
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
		SET @id = @id + 1;
	End
GO