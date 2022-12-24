USE	MusicStore
GO

--************************************************************************************************************************
/*Збережена процедура показує повну інформацію про му-
зичні диски  */
------------------------Створення процедури---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc
AS
	SELECT [D].[Name] AS 'Назва диску',
			[A].[Name] AS 'Виконавець',
			[S].[Name] AS 'Стиль диску',
			[D].[DatePublish] AS 'Дата виходу',
			[P].[Name] AS 'Видавець'
	FROM [Disc] D, [Artist] A, [Style] S, [Publisher] P
	WHERE [D].[IdArtist] = [A].[Id] AND
			[D].[IdStyle] = [S].[Id] AND
			[D].[IdPublisher] = [P].[Id]
GO
---------------------Кінець створень процедури-------------------------
-------------------------Тестування процедури--------------------------
exec GetInfo_MusicalDisc;
--************************************************************************************************************************
/*Збережена процедура показує повну інформацію про всі
музичні диски конкретного видавця. Назва видавця пере-
дається як параметр*/
------------------------Створення процедури---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc_FromPublisher
@Pub nvarchar(100)
AS
	SELECT [D].[Name] AS 'Назва диску',
				[A].[Name] AS 'Виконавець',
				[S].[Name] AS 'Стиль диску',
				[D].[DatePublish] AS 'Дата виходу',
				[P].[Name] AS 'Видавець'
		FROM [Disc] D, [Artist] A, [Style] S, [Publisher] P
		WHERE [D].[IdArtist] = [A].[Id] AND
				[D].[IdStyle] = [S].[Id] AND
				[D].[IdPublisher] = [P].[Id] AND
				[P].[Name] = @Pub
GO
---------------------Кінець створень процедури-------------------------
-------------------------Тестування процедури--------------------------
exec GetInfo_MusicalDisc_FromPublisher 'Parlophone'
--************************************************************************************************************************
/*Збережена процедура показує назву найпопулярнішого стилю. 
Популярність стилю визначається за кількістю дисків у колекції*/
------------------------Створення процедури---------------------------
GO
CREATE PROCEDURE GetInfo_TopMusicStyle
AS
	SELECT [S].[Name] AS 'Найпопулярніший стиль',
			[TEMP].[CountStyle] AS 'Кількість дисків'
	FROM [Style] S,
		(SELECT COUNT([D].[IdStyle]) AS 'CountStyle',
			[D].[IdStyle] AS 'Id'
		FROM [Disc] D
		GROUP BY [D].[IdStyle]) TEMP
	WHERE [S].[Id] = [TEMP].[Id] AND
	[TEMP].[CountStyle] = (SELECT MAX([TEMP].[CountStyle])
									FROM (SELECT COUNT([D].[IdStyle]) AS 'CountStyle',
												[D].[IdStyle] AS 'Id'
												FROM [Disc] D
												GROUP BY [D].[IdStyle]) AS [TEMP])
GO									
---------------------Кінець створень процедури-------------------------
-------------------------Тестування процедури--------------------------
exec GetInfo_TopMusicStyle
--************************************************************************************************************************
/*Збережена процедура відображає інформацію про диск конкретного стилю 
з найбільшою кількістю пісень. Назва стилю передається як параметр, 
якщо передано слово all, аналіз йде за всіма стилями*/
------------------------Створення процедури---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc_FromStyle
@Style nvarchar(50)
AS
	BEGIN
		IF(@Style = 'all')
			BEGIN
				SELECT [D].[Name] AS 'Назва диску',
					COUNT([S].[Name]) AS 'Кількість пісень'
				FROM [Disc] D, [Song] So, [Style] S
				WHERE [So].[IdDisc] = [D].[Id] AND
						[S].[Id] = [So].[IdStyle]
				GROUP BY [D].[Name]
				HAVING COUNT([S].[Name]) = (SELECT MAX([T].[Кількість пісень])
											FROM (SELECT [D].[Name] AS 'Назва диску',
												COUNT([S].[Name]) AS 'Кількість пісень'
											FROM [Disc] D, [Song] So, [Style] S
											WHERE [So].[IdDisc] = [D].[Id] AND
													[S].[Id] = [So].[IdStyle]
											GROUP BY [D].[Name]) AS [T])
			END
		ELSE
			BEGIN
			SELECT [D].[Name] AS 'Назва диску',
					COUNT([S].[Name]) AS 'Кількість пісень'
				FROM [Disc] D, [Song] So, [Style] S
				WHERE [So].[IdDisc] = [D].[Id] AND
						[S].[Id] = [So].[IdStyle] AND
						[S].[Name] = @Style
				GROUP BY [D].[Name]
				HAVING  
						COUNT([S].[Name]) = (SELECT MAX([T].[Кількість пісень])
											FROM (SELECT [D].[Name] AS 'Назва диску',
												COUNT([S].[Name]) AS 'Кількість пісень'
											FROM [Disc] D, [Song] So, [Style] S
											WHERE [So].[IdDisc] = [D].[Id] AND
													[S].[Id] = [So].[IdStyle] AND
													[S].[Name] = @Style
											GROUP BY [D].[Name]) AS [T])						
			END
	END
GO
---------------------Кінець створень процедури-------------------------
-------------------------Тестування процедури--------------------------
EXEC GetInfo_MusicalDisc_FromStyle 'ALL'
EXEC GetInfo_MusicalDisc_FromStyle 'Rock & Roll'
EXEC GetInfo_MusicalDisc_FromStyle 'Pop rock'
--************************************************************************************************************************
/*Збережена процедура видаляє всі диски заданого стилю.
Назва стилю передається як параметр. Процедура повер-
тає кількість видалених альбомів*/
------------------------Створення процедури---------------------------



---------------------Кінець створень процедури-------------------------

-------------------------Тестування процедури--------------------------

--************************************************************************************************************************
/*Збережена процедура відображає інформацію про самий
«старий» альбом і самий «молодий». Старість та молодість
визначаються за датою випуску;*/
------------------------Створення процедури---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc_TOP_YOUNG_OLD
AS
	SELECT [D].[Name] AS 'Назва диску',
			[A].[Name] AS 'Виконавець',
			[S].[Name] AS 'Стиль диску',
			[D].[DatePublish] AS 'Дата виходу',
			[P].[Name] AS 'Видавець'
	FROM [Disc] D, [Artist] A, [Style] S, [Publisher] P
	WHERE [D].[IdArtist] = [A].[Id] AND
			[D].[IdStyle] = [S].[Id] AND
			[D].[IdPublisher] = [P].[Id] AND
			[D].[DatePublish] = (SELECT MIN([D].[DatePublish])
								FROM [Disc] D)
	UNION
		SELECT [D].[Name] AS 'Назва диску',
			[A].[Name] AS 'Виконавець',
			[S].[Name] AS 'Стиль диску',
			[D].[DatePublish] AS 'Дата виходу',
			[P].[Name] AS 'Видавець'
	FROM [Disc] D, [Artist] A, [Style] S, [Publisher] P
	WHERE [D].[IdArtist] = [A].[Id] AND
			[D].[IdStyle] = [S].[Id] AND
			[D].[IdPublisher] = [P].[Id] AND
			[D].[DatePublish] = (SELECT MAX([D].[DatePublish])
								FROM [Disc] D)
GO
---------------------Кінець створень процедури-------------------------
-------------------------Тестування процедури--------------------------
EXEC GetInfo_MusicalDisc_TOP_YOUNG_OLD
--************************************************************************************************************************
/*Збережена процедура видаляє всі диски в назві яких є за-
дане слово. Слово передається як параметр. Процедура
повертає кількість видалених альбомів.*/
------------------------Створення процедури---------------------------



---------------------Кінець створень процедури-------------------------

-------------------------Тестування процедури--------------------------

