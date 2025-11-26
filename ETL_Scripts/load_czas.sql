USE Casino_DataWarehouse;
GO


-- BEZ "1 row affected"
SET NOCOUNT ON;

DECLARE @Hour INT = 0;
DECLARE @Minute INT = 0;
DECLARE @Second INT = 0;
DECLARE @PoraDnia NVARCHAR(50);

DECLARE @id INT = 1;

--ZABEZPIECZNIE GDY NIE JEST PUSTA:
IF EXISTS (SELECT 1 FROM dbo.Czas)
    SELECT @id = MAX(ID_Czasu) + 1 FROM dbo.Czas;

WHILE @Hour <= 23
BEGIN
    SET @Minute = 0;
    
    WHILE @Minute <= 59
    BEGIN
        SET @Second = 0;

        WHILE @Second <= 59
        BEGIN

            SET @PoraDnia = CASE 
                WHEN @Hour BETWEEN 6 AND 11 THEN 'Rano'
                WHEN @Hour BETWEEN 12 AND 17 THEN 'Popo³udnie'
                WHEN @Hour BETWEEN 18 AND 22 THEN 'Wieczór'
                ELSE 'Noc'
            END;

            INSERT INTO dbo.Czas (
                ID_Czasu,
                Pelny_Czas,
                Godzina,
                Minuta,
                Sekunda,
                Pora_Dnia
            )
            VALUES (
                @id,
                TIMEFROMPARTS(@Hour, @Minute, @Second, 0, 0),
                @Hour,
                @Minute,
                @Second,
                @PoraDnia
            );

            SET @Second = @Second + 1;
            SET @id = @id + 1;
        END

        SET @Minute = @Minute + 1;
    END

    SET @Hour = @Hour + 1;
END

SET NOCOUNT OFF;
GO