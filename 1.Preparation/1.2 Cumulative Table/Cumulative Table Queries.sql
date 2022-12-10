#Creation of aggregate table for the most important statistics for the home teams with descriptive aliases in each new column
#All stats are marked as H at the beginning of their alias names to indicate that they are gathered from the matches of the home matches of each team.
Create table HomeTable
SELECT HomeTeam,
sum(HomePoints) as HomePoints, 
sum(FTHG) as HGoalsScored,
sum(FTAG) as HGoalsConceded, 
SUM(HS) as HShotsFor, 
sum(summary_2017_2022.AS) as HShotsAgainst, 
SUM(HST) as HOnTargetFor, 
SUM(AST) as HOnTargetAgainst,
sum(HF) as HFoulsCommited,
sum(AF) as HFoulsSuffered,
SUM(HC) as HCornersFor,
SUM(AC) as HCornersAgainst,
SUM(HY+(2*HR)) as HCardsTeam,
SUM(AY+(2*AR)) as HCardsOpp,
Count(HomeTeam) as Hmatches
FROM summary_2017_2022
GROUP BY HomeTeam
order by homepoints DESC;

#Creation of aggregate table for the most important statistics for the away teams with descriptive aliases in each new column
#All stats are marked as A at the beginning of their alias names to indicate that they are gathered from the matches of the home matches of each team.
create table awaytable
SELECT AwayTeam, 
sum(AwayPoints) as AwayPoints, 
sum(FTHG) as AGoalsConceded,
sum(FTAG) as AGoalsScored, 
SUM(HS) as AShotsAgainst, 
sum(summary_2017_2022.AS) as AShotsFor, 
SUM(HST) as AOnTargetAgainst, 
SUM(AST) as AOnTargetFor,
sum(HF) as AFoulsSuffered,
sum(AF) as AFoulsCommited,
SUM(HC) as ACornersAgainst,
SUM(AC) as ACornersFor,
SUM(HY+(2*HR)) as ACardsOpp,
SUM(AY+(2*AR)) as ACardsTeam,
Count(HomeTeam) as Amatches
FROM summary_2017_2022
GROUP BY AwayTeam
order by AwayPoints DESC;

#So now we have two cumulativce wide tables one for the home teams: hometable and away teams: awaytable

#Merging of the two tables into one big table with data for home and matches separated.
create table Wide_Table
SELECT *
from hometable as h
left join awaytable as a
on HomeTeam=AwayTeam;


#creation of the final standings by aggregating stats for each team from both home and away matches
create table Cumulative_Table
select 
ROW_Number() OVER(ORDER BY((HomePoints + AwayPoints)) desc) AS Position,
HomeTeam as Team, 
(HomePoints + AwayPoints) as Points,
(HGoalsScored + AGoalsScored) as Goals_Scored,
(HGoalsConceded + AGoalsConceded) as Goals_Conceded,
((HGoalsScored + AGoalsScored) - (HGoalsConceded + AGoalsConceded)) as Goal_Difference,
(HShotsFor + AShotsFor) as Shots_For,
(HShotsAgainst + AShotsAgainst) as Shots_Against,
(HOnTargetFor + AOnTargetFor) as Shots_On_Target_For,
(HOnTargetAgainst + AOnTargetAgainst) as Shots_On_Target_Against,
(HFoulsCommited + AFoulsCommited) as Fouls_Commited,
(HFoulsSuffered + AFoulsSuffered) as Fouls_Suffered,
(HCornersFor + ACornersFor) as Corners_For,
(HCornersAgainst + ACornersAgainst) as Corners_Against,
(HCardsTeam + ACardsTeam) as Team_Cards,
(HCardsOpp + ACardsOpp) as Opposition_Cards,
(Hmatches + Amatches) as No_Matches
from Wide_Table
order by Points desc;
Alter table cumulative_table
Modify No_Matches int(10)
AFTER Team;

SELECT *
from Cumulative_Table;






