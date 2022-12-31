select *
from PortfolioProject.dbo.educationCOVID19


-- Converting NULL values into '0'

update PortfolioProject.dbo.educationCOVID19
set Country_Code = 0, Country_Name = 0, Income_Level = 0,
Region_Name = 0, School_Status = 0, Year_Pre = 0, Year_Prm = 0, Year_Sec = 0, Year_Ter = 0, Latitude_generated = 0,
Longitude_generated = 0, Enrollment = 0, Se_Pre_Enrl = 0, Se_Prm_Enrl = 0, Se_Sec_Enrl = 0, Se_Ter_Enrl = 0

where Se_Ter_Enrl IS NULL

select *
from PortfolioProject.dbo.educationCOVID19


-- Adding '-20' to the date of 'If_Closed_due_to_COVID19_When' column

update PortfolioProject.dbo.educationCOVID19
set If_Closed_due_to_COVID19_When = concat(If_Closed_due_to_COVID19_When, '-20')
where If_Closed_due_to_COVID19_When like '%-Mar' or If_Closed_due_to_COVID19_When like '%-Feb' or 
If_Closed_due_to_COVID19_When like '%-Jan'


update PortfolioProject.dbo.educationCOVID19
set If_Closed_due_to_COVID19_When = REPLACE(If_Closed_due_to_COVID19_When, 'Apirl 3', '3-Apr')
where If_Closed_due_to_COVID19_When = 'Apirl 3'


update PortfolioProject.dbo.educationCOVID19
set If_Closed_due_to_COVID19_When = CONCAT(If_Closed_due_to_COVID19_When, '-20')
where If_Closed_due_to_COVID19_When like '%-Apr'


select *
from PortfolioProject.dbo.educationCOVID19


-- Adding the closing date of the schools in 'If_Closed_due_to_COVID19_When' when it is possible


update PortfolioProject.dbo.educationCOVID19
set If_Closed_due_to_COVID19_When = Cast(If_Closed_due_to_COVID19_When as date)
where not (Country_Code = 'FSM' or Country_Code = 'MMR' or Country_Code = 'NIC' or Country_Code = 'SWE' or
Country_Code = 'TKM' or Country_Code = 'BDI')


select *
from PortfolioProject.dbo.educationCOVID19


-- Separating date and string data into two columns in 'If_Closed_due_to_COVID19_When'

alter table PortfolioProject.dbo.educationCOVID19
add Closed_Date DATE

alter table PortfolioProject.dbo.educationCOVID19
add String_Closed_Date nvarchar(200)


update PortfolioProject.dbo.educationCOVID19
set String_Closed_Date = If_Closed_due_to_COVID19_When
where If_Closed_due_to_COVID19_When like '%schools%'


update PortfolioProject.dbo.educationCOVID19
set Closed_Date = If_Closed_due_to_COVID19_When
where not (If_Closed_due_to_COVID19_When like '%schools%')


-- Changing 'School_Status' to 'Closed' for 4 schools on the top bottom of the list

update PortfolioProject.dbo.educationCOVID19
set School_Status = REPLACE(School_Status, 'Null, No information available, Not known', 'Closed')
where Country_Code = 'COM' or Country_Code = 'Mac' or Country_Code = 'VUT' or Country_Code = 'WSM';


-- Delating rows where all values are equal to 0

delete from PortfolioProject.dbo.educationCOVID19
where Income_Level = '0' or
Region_Name = '0' or School_Status = '0' or Year_Pre = 0 or Year_Prm = 0 or Year_Sec = 0 or Year_Ter = 0 or Latitude_generated = 0 or
Longitude_generated = 0 or Enrollment = 0 or Se_Pre_Enrl = 0 or Se_Prm_Enrl = 0 or Se_Sec_Enrl = 0 or Se_Ter_Enrl = 0;


-- Split Dt_Extraction in separate Date and Time columns

	-- Creation of two columns for Date and Time respectively

alter table PortfolioProject.dbo.educationCOVID19
add Date_Extraction DATE

alter table PortfolioProject.dbo.educationCOVID19
add Time_Extraction TIME(0)


	--Filling both columns with respective Date and TIME values

update PortfolioProject.dbo.educationCOVID19
set Date_Extraction = CONVERT(DATE, Dt_Extraction)

update PortfolioProject.dbo.educationCOVID19
set Time_Extraction = CONVERT(TIME(0), Dt_Extraction)


-- Grouping countries by income level, region name and school status

select *
from PortfolioProject.dbo.educationCOVID19

select Country_Name, Income_Level, Region_Name
from PortfolioProject.dbo.educationCOVID19
where Income_Level = 'Low Income'

select Income_Level,Region_Name, count(Income_Level) as Income_Frequency
from PortfolioProject.dbo.educationCOVID19
where Income_Level = 'Low Income' or Income_Level = 'Lower middle income' or Income_Level = 'Upper middle income'
or Income_Level = 'High Income'
group by Income_Level, Region_Name
order by Income_Frequency desc


select Income_Level, count(Income_Level) as Income_Frequency
from PortfolioProject.dbo.educationCOVID19
group by Income_Level
order by Income_Frequency desc

select *
from PortfolioProject.dbo.educationCOVID19


-- Checking for School Status versus Regions

select Region_Name, School_Status, count(School_Status) as School_Status_Frequency
from PortfolioProject.dbo.educationCOVID19
where School_Status = 'Closed' or School_Status = 'Closed (in select areas)' or School_Status = 'Seasonal school closures'
or School_Status = 'Open with limitations' or School_Status = 'Open'
group by School_Status, Region_Name
order by School_Status_Frequency desc



-- Checking for School_Status

select School_Status, COUNT(School_Status) as Status_Frequency
from PortfolioProject.dbo.educationCOVID19
group by School_Status
order by Status_Frequency desc

