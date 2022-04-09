/*1*/

SELECT n_group, COUNT(*) FROM student GROUP BY n_group

/* 2*/

SELECT n_group, MAX(score) FROM student GROUP BY n_group

/* 3*/

SELECT surname, COUNT(surname) FROM student GROUP BY surname

/* 4 */

SELECT date, count(date) FROM student GROUP BY date

/* 7  */

SELECT  n_group,AVG(score)  FROM student GROUP BY n_group HAVING AVG(score)<= 3.5 ORDER BY AVG(score) ASC

/* 8*/
SELECT  n_group, COUNT(name),MAX(score),AVG(score),MIN(score) FROM student GROUP BY n_group

/* 9*/

SELECT  name, MAX(score),n_group FROM student WHERE n_group = 2251 GROUP BY n_group,name HAVING MAX(score) >= 5
/* 10 */

SELECT distinct n_group, name ,MAX(score) FROM student WHERE score = (SELECT MAX(score)  from student) GROUP BY n_group,name


