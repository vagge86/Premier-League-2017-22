ALTER table season20212022
ADD Season varchar(255);
update season20212022
SET Season="2021/22";
ALTER TABLE season20212022
MODIFY Season varchar(255)
AFTER Date;