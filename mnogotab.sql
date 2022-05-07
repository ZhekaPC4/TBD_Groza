/*1.Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.*/
SELECT st.name, st.surname, hb.name
FROM student st, hobbies hb, student_hobby sh
WHERE sh.n_z = st.n_z AND sh.hobby_id = hb.id;

/*2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/
SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY sh.started_at Limit 1

--3. Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, а сумма риска всех хобби, которыми он занимается в данный момент, больше 4
SELECT st.name, st.surname, st.n_z, st.date, Sosy_biby.anime
FROM student st, hobbies h, (select st.n_z, sum(hb.risk) as anime
FROM student st, student_hobby sh, hobbies hb
where st.n_z = sh.n_z and hb.id = sh.hobby_id 
group by st.n_z) as Sosy_biby
Where score > (
	select avg(score)::real
	from student
) 
and Sosy_biby.n_z = st.n_z and Sosy_biby.anime > 4
group by st.name, st.surname, st.n_z, st.date, Sosy_biby.anime

--4. Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби Диапазон дат.
SELECT st.name, st.surname, st.n_z, st.date, hb.name, extract(month from age(sh.finished_at, sh.started_at)) + 12 * extract(year from age(sh.finished_at, sh.started_at)) as months, sh.finished_at 
FROM student st
INNER JOIN student_hobby sh on sh.n_z = st.n_z
INNER JOIN hobbies hb on hb.id = sh.hobby_id
Where sh.finished_at IS NOT null

/*6 Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби. */
SELECT DISTINCT st.n_group, avg(st.score)::numeric(3,2)
FROM student st
INNER JOIN(SELECT DISTINCT sh.id
FROM student_hobby sh, hobbies hb
WHERE sh.id = hb.id AND sh.finished_at IS NULL) tt
ON tt.id = st.n_z
GROUP BY st.n_group

/*8 Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл. */
SELECT hb.name
FROM student st
INNER JOIN student_hobby sh on sh.id = st.n_z
INNER JOIN hobbies hb on hb.id = sh.id
WHERE st.score = (SELECT max(st.score)
FROM student st)

/*9 Найти все действующие хобби, которыми увлекаются троечники 2-го курса. */
SELECT hb.name
FROM hobbies hb
INNER JOIN student_hobby sh on sh.id = hb.id AND sh.finished_at IS NULL
INNER JOIN student st on st.n_z = sh.id
WHERE SUBSTRING(st.n_group::varchar, 1,1) = '2' AND st.score > 2 AND st.score < 4

/*12 Для каждого курса подсчитать количество различных действующих хобби на курсе. */
SELECT count(sh.n_z), SUBSTRING(st.n_group::varchar, 1,1)
FROM student_hobby sh, student st
WHERE sh.finished_at IS NULL AND sh.n_z = st.n_z
GROUP BY SUBSTRING(st.n_group::varchar,1,1)

/*13 Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.. */
SELECT DISTINCT st.n_z, st.name, st.surname, st.date, SUBSTRING(st.n_group::varchar,1,1) as course
FROM student_hobby sh, student st
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL and st.score = 5
ORDER BY course, date

--14. Создать представление, в котором отображается вся информация о студентах, которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.
SELECT *, extract(year from age('2022-05-07', sh.started_at)) as hobby_years
FROM student st
INNER JOIN student_hobby sh on sh.n_z = st.n_z
INNER JOIN hobbies hb on hb.id = sh.hobby_id
Where sh.finished_at is null and extract(year from age('2022-05-07', sh.started_at)) >= 5
--как делать представление? 

/*15 Для каждого хобби вывести количество людей, которые им занимаются.. */
SELECT hb.name, tt.countOfHobby
FROM hobbies hb
INNER JOIN (
    SELECT count(sh.id) as countOfHobby, sh.hobby_id
    FROM student_hobby sh
    WHERE sh.finished_at IS NULL
    GROUP BY sh.hobby_id) tt
ON tt.hobby_id = hb.id

/*16 Вывести ИД самого популярного хобби. */
	SELECT hb.id
	FROM hobbies hb
		INNER JOIN
		(SELECT count(sh.hobby_id) as countOfHobby, sh.hobby_id
		FROM student_hobby sh
		WHERE sh.finished_at IS NULL
		GROUP BY sh.hobby_id) tt
	ON tt.hobby_id = hb.id
	ORDER BY countOfHobby DESC Limit 1

--17. Вывести всю информацию о студентах, занимающихся самым популярным хобби.
SELECT *
FROM student st
INNER JOIN student_hobby sh on sh.n_z = st.n_z
INNER JOIN hobbies hb on hb.id = sh.hobby_id
Where sh.hobby_id = 
(
	SELECT hb.id
	FROM hobbies hb
		INNER JOIN
		(SELECT count(sh.hobby_id) as countOfHobby, sh.hobby_id
		FROM student_hobby sh
		WHERE sh.finished_at IS NULL
		GROUP BY sh.hobby_id) tt
	ON tt.hobby_id = hb.id
	ORDER BY countOfHobby DESC Limit 1
)

--18. Вывести ИД 3х хобби с максимальным риском.
Select id
From hobbies
Where risk >= (
	Select risk
	From hobbies
	order by risk desc
	
--19. Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY sh.started_at Limit 10

--20.Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.
Select distinct st.n_group
from student st
inner join (
	SELECT st.name, st.surname, sh.started_at, st.n_group
	FROM student st, student_hobby sh
	WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
	ORDER BY sh.started_at Limit 10) tt
On tt.n_group = st.n_groupLimit 1 offset 2
)
--19. Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY sh.started_at Limit 10

--20.Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.
Select distinct st.n_group
from student st
inner join (
	SELECT st.name, st.surname, sh.started_at, st.n_group
	FROM student st, student_hobby sh
	WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
	ORDER BY sh.started_at Limit 10) tt
On tt.n_group = st.n_group
