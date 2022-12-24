USE	MusicStore
GO

--************************************************************************************************************************
/*��������� ��������� ������ ����� ���������� ��� ��-
����� �����  */
------------------------��������� ���������---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc
AS
	SELECT [D].[Name] AS '����� �����',
			[A].[Name] AS '����������',
			[S].[Name] AS '����� �����',
			[D].[DatePublish] AS '���� ������',
			[P].[Name] AS '��������'
	FROM [Disc] D, [Artist] A, [Style] S, [Publisher] P
	WHERE [D].[IdArtist] = [A].[Id] AND
			[D].[IdStyle] = [S].[Id] AND
			[D].[IdPublisher] = [P].[Id]
GO
---------------------ʳ���� �������� ���������-------------------------
-------------------------���������� ���������--------------------------
exec GetInfo_MusicalDisc;
--************************************************************************************************************************
/*��������� ��������� ������ ����� ���������� ��� ��
������� ����� ����������� �������. ����� ������� ����-
������ �� ��������*/
------------------------��������� ���������---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc_FromPublisher
@Pub nvarchar(100)
AS
	SELECT [D].[Name] AS '����� �����',
				[A].[Name] AS '����������',
				[S].[Name] AS '����� �����',
				[D].[DatePublish] AS '���� ������',
				[P].[Name] AS '��������'
		FROM [Disc] D, [Artist] A, [Style] S, [Publisher] P
		WHERE [D].[IdArtist] = [A].[Id] AND
				[D].[IdStyle] = [S].[Id] AND
				[D].[IdPublisher] = [P].[Id] AND
				[P].[Name] = @Pub
GO
---------------------ʳ���� �������� ���������-------------------------
-------------------------���������� ���������--------------------------
exec GetInfo_MusicalDisc_FromPublisher 'Parlophone'
--************************************************************************************************************************
/*��������� ��������� ������ ����� ���������������� �����. 
������������ ����� ����������� �� ������� ����� � ��������*/
------------------------��������� ���������---------------------------
GO
CREATE PROCEDURE GetInfo_TopMusicStyle
AS
	SELECT [S].[Name] AS '��������������� �����',
			[TEMP].[CountStyle] AS 'ʳ������ �����'
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
---------------------ʳ���� �������� ���������-------------------------
-------------------------���������� ���������--------------------------
exec GetInfo_TopMusicStyle
--************************************************************************************************************************
/*��������� ��������� �������� ���������� ��� ���� ����������� ����� 
� ��������� ������� �����. ����� ����� ���������� �� ��������, 
���� �������� ����� all, ����� ��� �� ���� �������*/
------------------------��������� ���������---------------------------
GO
CREATE PROCEDURE GetInfo_MusicalDisc_FromStyle
@Style nvarchar(50)
AS
	BEGIN
		IF(@Style = 'all')
			BEGIN
				SELECT [D].[Name] AS '����� �����',
					COUNT([S].[Name]) AS 'ʳ������ �����'
				FROM [Disc] D, [Song] So, [Style] S
				WHERE [So].[IdDisc] = [D].[Id] AND
						[S].[Id] = [So].[IdStyle]
				GROUP BY [D].[Name]
				HAVING COUNT([S].[Name]) = (SELECT MAX([T].[ʳ������ �����])
											FROM (SELECT [D].[Name] AS '����� �����',
												COUNT([S].[Name]) AS 'ʳ������ �����'
											FROM [Disc] D, [Song] So, [Style] S
											WHERE [So].[IdDisc] = [D].[Id] AND
													[S].[Id] = [So].[IdStyle]
											GROUP BY [D].[Name]) AS [T])
			END
		ELSE
			BEGIN
			SELECT [D].[Name] AS '����� �����',
					COUNT([S].[Name]) AS 'ʳ������ �����'
				FROM [Disc] D, [Song] So, [Style] S
				WHERE [So].[IdDisc] = [D].[Id] AND
						[S].[Id] = [So].[IdStyle] AND
						[S].[Name] = @Style
				GROUP BY [D].[Name]
				HAVING  
						COUNT([S].[Name]) = (SELECT MAX([T].[ʳ������ �����])
											FROM (SELECT [D].[Name] AS '����� �����',
												COUNT([S].[Name]) AS 'ʳ������ �����'
											FROM [Disc] D, [Song] So, [Style] S
											WHERE [So].[IdDisc] = [D].[Id] AND
													[S].[Id] = [So].[IdStyle] AND
													[S].[Name] = @Style
											GROUP BY [D].[Name]) AS [T])						
			END
	END
GO
---------------------ʳ���� �������� ���������-------------------------
-------------------------���������� ���������--------------------------
EXEC GetInfo_MusicalDisc_FromStyle 'ALL'
EXEC GetInfo_MusicalDisc_FromStyle 'Rock & Roll'
EXEC GetInfo_MusicalDisc_FromStyle 'Pop rock'
--************************************************************************************************************************
/*��������� ��������� ������� �� ����� �������� �����.
����� ����� ���������� �� ��������. ��������� �����-
�� ������� ��������� �������*/
------------------------��������� ���������---------------------------



---------------------ʳ���� �������� ���������-------------------------

-------------------------���������� ���������--------------------------

--************************************************************************************************************************
/*��������� ��������� �������� ���������� ��� �����
������� ������ � ����� ��������. ������� �� ��������
������������ �� ����� �������;*/
------------------------��������� ���������---------------------------



---------------------ʳ���� �������� ���������-------------------------

-------------------------���������� ���������--------------------------

--************************************************************************************************************************
/*��������� ��������� ������� �� ����� � ���� ���� � ��-
���� �����. ����� ���������� �� ��������. ���������
������� ������� ��������� �������.*/
------------------------��������� ���������---------------------------



---------------------ʳ���� �������� ���������-------------------------

-------------------------���������� ���������--------------------------

