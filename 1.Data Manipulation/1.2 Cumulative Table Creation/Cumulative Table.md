## <ins>In this section a wide cumulative table will be created:</ins>

:zap: In order to conduct this part of the analysis the following steps will be followed:

a. Creation of two tables HomeTeams and AwayTeams which will aggregate the stats and points for each team separately.

b. Merging the two above tables in one wide table with two parts: 
- One for the aggregated stats for each team only for their home matches on the left side and the same for their away matches on the right side.
 
c. Merging the stats from home and away matches to one cumulative table.

⭐ For the calculation of the cards the following Card Points system has been followed: Each Yellow card is worth one Card Point and each Red Card is worth 2 Card Points. 

⭐ A column with the mathes played will be added with the following method: First a separate table will be created counting all the matches played by each team at home and another one for matches played away. Then each one will be Joined to the corresponding home and away cumulative table.
```ruby
#Creation of aggregate table for the most important statistics for the home teams (both for and against) with descriptive aliases in each new column.
#All stats are marked as H to indicate that they are gathered from the matches of the home matches of each team.

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

#Merging of the two tables into one big table with data for home and matches separated.
create table Wide_Table
SELECT *
from hometable as h
left join awaytable as a
on HomeTeam=AwayTeam;

```

⭐The wide table is temporary and used mainly to enable us aggregate the stats for each team.

⭐The final Cumulative table will be created by creating a table which will add the home and away stats of each team, adding an additional column for the goal difference and will rank the teams on the basis of points won over the last 5 years.

```ruby
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
```
💬 This is our final Cumulative table:![image](https://user-images.githubusercontent.com/69303154/208435131-7cadd9fb-947f-419e-8f7a-d83a3c703407.png)
