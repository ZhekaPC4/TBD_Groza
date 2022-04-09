/*1*/

SELECT name,surname FROM student WHERE score>=4 AND score<=4.5

/*3*/

Select name, surname, n_group from student order by n_group desc, name

/*4*/

Select name, surname, score from student where score > 4.0 order by score desc

/*5*/
Select name, risk from hobbies where name = 'Шахматы' or name = 'Баскетбол'

/*6*/
Select id, hobby_id, started_at, finished_at
from student_hobby
where started_at between '2018-01-01' and '2019-01-01' and finished_at notnull

/*7*/

Select name, surname, score from student where score > 4.5 order by score desc

/*8*/

 Select name, surname, score from student where score > 4.5 order by score desc limit 5

/*10*/

Select name, risk from hobbies order by (risk) desc limit 3











