#Creation of aggregate table for the most important statistics for the home teams with descriptive aliases in each new column
create table HomeTeams
select HomeTeam,
sum(HomePoints) as HomePoints, 
sum(FTHG) as HGoalsScored,
sum(FTAG) as HGoalsConceded, 
sum(HS) as HomeShots, 
sum(HST) as HomeOnTarget, 
sum(HF) as HomeFouls,
sum(HC) as HomeCorners,
sum(HY+(2*HR)) as HomeCards
From Summary_2017_2022
group by HomeTeam
order by sum(HomePoints) desc;

#Creation of new table to calculate the number of matches of the Home Teams
Create table HomeMatches
SELECT HomeTeam,Count(HomeTeam) as Home_matches
from Summary_2017_2022
Group by HomeTeam;

#Joining the Home Teams table with the above created table to add a column with the matches played by each team
create table HomeTeamsTable
SELECT h.*, m.Home_matches
from hometeams as h
left join homematches as m
on m.HomeTeam=h.HomeTeam;
ALTER TABLE HomeTeamsTable
MODIFY Home_matches int(10)
AFTER HomeTeam;

#Creation of aggregate table for the most important statistics for the away teams with descriptive aliases in each new column
create table AwayTeams
select AwayTeam, 
sum(AwayPoints) as AwayPoints, 
sum(FTHG) as AGoalsConceded, sum(FTAG) as AGoalsScored, 
sum(Summary_2017_2022.AS) as AwayShots, SUM(AST) as AwayOnTarget, 
sum(AF) as AwayFouls,
sum(AC) as AwayCorners,
sum(AY+(2*AR)) as AwayCards
From Summary_2017_2022
group by AwayTeam
order by sum(AwayPoints) desc;

#Creation of new table to calculate the number of matches of the Away Teams
Create table awaymatches
SELECT AwayTeam,Count(AwayTeam) as Away_matches
from Summary_2017_2022
Group by AwayTeam;

#Joining the Away Teams table with the above created table to add a column with the matches played by each team
create table AwayTeamsTable
SELECT a.*, m.Away_matches
from awayteams as a
left join awaymatches as m
on m.AwayTeam=a.AwayTeam;
ALTER TABLE AwayTeamsTable
MODIFY Away_matches int(10)
AFTER AwayTeam;

#So now we have two cumulativce wide tables one for the home teams: HomeTeamsTable and away teams:AwayTeamsTable

#Merge of the two tables into one
create table Wide_table
SELECT *
from HomeTeamsTable as h
left join AwayTeamsTable as a
on HomeTeam=AwayTeam;

SELECT *
from Wide_table;

#creation of the final standings by aggregating stats for each team from both home and away matches
create table Cumulative_Table
select 
ROW_Number() OVER(ORDER BY((HomePoints + AwayPoints)) desc) AS Position,
HomeTeam, 
(Home_matches+Away_matches) as Matches,
(HomePoints + AwayPoints) as Points,
(HGoalsScored + AGoalsScored) as Goals_Scored,
(HGoalsConceded + AGoalsConceded) as Goals_Conceded,
((HGoalsScored + AGoalsScored) - (HGoalsConceded + AGoalsConceded)) as Goal_Difference,
(HomeShots + AwayShots) as Shots,
(HomeOnTarget + AwayOnTarget) as Shots_On_Target,
(HomeFouls + AwayFouls) as Fouls,
(HomeCorners + AwayCorners) as Corners,
(HomeCards + AwayCards) as Cards
from Wide_table
order by Points desc;

SELECT *
from Cumulative_Table;






