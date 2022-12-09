**Merging of the 5 seasons to 1 summary table**

Additionally we will create an additional column which shows the season each match took place.

**Addition of a "Season" Column and placement after the "Date" Column**

    ALTER table season20212022
    ADD Season varchar(255);
    update season20212022
    SET Season="2021/22";
    ALTER TABLE season20212022
    MODIFY Season varchar(255)
    AFTER Date;
    
The same query is being repeated 5 times one for each dataset only making the necessary changes in the table name and the desired season name.

**Merging of the 5 files in one by selecting the columns we need**

```
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

The next issue of our new dataset is that it will be helpful to add a new column: match_id as primary key and then sort the matches by date.

```
ALTER TABLE Summary_2017_2022 ADD match_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
SELECT *
from Summary_2017_2022
ORDER BY STR_TO_DATE(match_date, '%d/%m/%Y');
```

Finally the primary key column should be the first column

```
ALTER TABLE Summary_2017_2022
MODIFY match_id INT(10)
FIRST;
```
