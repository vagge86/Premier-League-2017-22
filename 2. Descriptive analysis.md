**In this section a wide cumulative table will be created**

In order to conduct this part of the analysis the following steps will be followed:
a. Creation of two tables HomeTeams and AwayTeams which will aggregate the stats and points for each team separately.
b. Merging and summarizing those two tables 

**For the calculation of the cards the following Card Points system has been followed: Each Yellow card is worth one Card Point and each Red Card is worth 2 Card Points. A column with the mathes played will be added with the following method: First a separate table will be created counting all the matches played by each team at home and another one for matches played away. Then each one will be Joined to the corresponding home and away cumulative table.
```
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
```
So now we have two cumulativce wide tables one for the home teams: HomeTeamsTable and away teams:AwayTeamsTable
Next step is to create a combined wide table by using the JOIN command on the match of the same team in both tables.

```
#Merge of the two tables into one
create table Wide_table
SELECT *
from HomeTeamsTable as h
left join AwayTeamsTable as a
on HomeTeam=AwayTeam;
```

The final Cumulative table will be created by creating a table which will add the home and away stats of each team, adding an additional column for the goal difference and will rank the teams on the basis of points won over the last 5 years.

```
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
```
[This is our final Cumulative table:]![image](https://user-images.githubusercontent.com/69303154/206860213-cad96bb4-3249-42b4-9fb9-62eb8ab2de7e.png)
