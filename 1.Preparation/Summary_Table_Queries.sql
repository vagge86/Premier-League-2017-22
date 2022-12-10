#Addition of a "Season" Column and placement after the "Date" Column

ALTER table season20212022
ADD Season varchar(255);
update season20212022
SET Season="2021/22";
ALTER TABLE season20212022
MODIFY Season varchar(255)
AFTER Date;

ALTER table season20202021
ADD Season varchar(255);
update season20202021
SET Season="2020/21";
ALTER TABLE season20202021
MODIFY Season varchar(255)
AFTER Date;

ALTER table season20192020
ADD Season varchar(255);
update season20192020
SET Season="2019/20";
ALTER TABLE season20192020
MODIFY Season varchar(255)
AFTER Date;

ALTER table season20182019
ADD Season varchar(255);
update season20182019
SET Season="2018/19";
ALTER TABLE season20182019
MODIFY Season varchar(255)
AFTER Date;

ALTER table season20172018
ADD Season varchar(255);
update season20172018
SET Season="2017/18";
ALTER TABLE season20172018
MODIFY Season varchar(255)
AFTER Date;

#Creation of one combined table using UNION ALL
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

#Ordering by date
SELECT *
from Summary_2017_2022
ORDER BY STR_TO_DATE(match_date, '%d/%m/%Y');
#Addition of column match_id as primary key
ALTER TABLE Summary_2017_2022 ADD match_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
#Setting Primary Key at as the first column
ALTER TABLE Summary_2017_2022
MODIFY match_id INT(10)
FIRST;
