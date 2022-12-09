**Merging of the 5 seasons to 1 summary table**

Additionally we will create an additional column which shows the season each match took place.

```
ALTER table season20212022
ADD Season varchar(255);
update season20212022
SET Season="2021/22";
ALTER TABLE season20212022
MODIFY Season varchar(255)
AFTER Date;
```
