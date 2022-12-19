### <ins>Merging of the 5 seasons to 1 summary table</ins>

:zap: In this part I will merge the 5 data sheets to 1 combined table and I will add the necessary columns that will help to conduct the analysis afterwards.

- At first we will create an additional column which shows the season each match took place:

**Addition of a "Season" Column and placement after the "Date" Column**
```ruby
    ALTER table season20212022
    ADD Season varchar(255);
    update season20212022
    SET Season="2021/22";
    ALTER TABLE season20212022
    MODIFY Season varchar(255)
    AFTER Date;
    ```
    
The same query is being repeated 5 times one for each dataset only making the necessary changes in the table name and the desired season name.

**Merging of the 5 files in one by selecting the columns we need**

```ruby
create table Summary_2017_2022

select season20212022.Date AS match_date,Season, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee, HS, season20212022.AS, HST, AST, HF, AF, HC, AC, HY, AY, HR, AR, B365H, B365D, B365A
from season20212022
union all 
select season20202021.Date AS match_date,Season, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee, HS, season20202021.AS, HST, AST, HF, AF, HC, AC, HY, AY, HR, AR, B365H, B365D, B365A
from season20202021
union all 
select season20192020.Date AS match_date,Season, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee, HS, season20192020.AS, HST, AST, HF, AF, HC, AC, HY, AY, HR, AR, B365H, B365D, B365A
from season20192020
union all 
select season20182019.Date AS match_date,Season, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee, HS, season20182019.AS, HST, AST, HF, AF, HC, AC, HY, AY, HR, AR, B365H, B365D, B365A
from season20182019
union all 
select season20172018.Date AS match_date,Season, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee, HS, season20172018.AS, HST, AST, HF, AF, HC, AC, HY, AY, HR, AR, B365H, B365D, B365A
from season20172018;
```

- The next issue of our new dataset is that it will be helpful to add a new column: match_id as primary key and then sort the matches by date.

```ruby
ALTER TABLE Summary_2017_2022 ADD match_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
SELECT *
from Summary_2017_2022
ORDER BY STR_TO_DATE(match_date, '%d/%m/%Y');
```

- Next setp is that the primary key column should be the first column

```ruby
ALTER TABLE Summary_2017_2022
MODIFY match_id INT(10)
FIRST;
```

:zap: We will also need a column for the points won by each team (3 if the team wins, 1 if the team draws and 0 if it loses).
For our analysis we will need a separate column for the home team and another one for the away team.

```ruby
#Addition of HomePoints column as Integer for the points won by the Home Team 
ALTER TABLE Summary_2017_2022
ADD HomePoints INT(10);
#Population of the column depending on the outcome of the match for the Home Team
UPDATE Summary_2017_2022
SET HomePoints = CASE
  WHEN FTHG > FTAG THEN 3
  WHEN FTHG = FTAG THEN 1
  ELSE 0
END;
#Addition of AwayPoints column as Integer for the points won by the Away Team 
ALTER TABLE Summary_2017_2022
ADD AwayPoints INT(10);
#Population of the column depending on the outcome of the match for the Away Team
UPDATE Summary_2017_2022
SET AwayPoints = CASE
  WHEN FTHG > FTAG THEN 0
  WHEN FTHG = FTAG THEN 1
  ELSE 3
END;
```
Our final table looks like this and it is ready to proceed to the analysis:
![image](https://user-images.githubusercontent.com/69303154/206854923-8cb6a770-0a9c-4437-8105-03ccf902982b.png)
