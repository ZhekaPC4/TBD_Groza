/*1.Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.*/
SELECT st.name, st.surname, hb.name
FROM student st, hobbies hb, student_hobby sh
WHERE sh.n_z = st.n_z AND sh.hobby_id = hb.id;
/*2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/
SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY sh.started_at
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
/*15 Для каждого хобби вывести количество людей, которые им занимаются.. */
SELECT hb.name, tt.countOfHobby
FROM hobbies hb
INNER JOIN
(SELECT count(sh.id) as countOfHobby, sh.hobby_id
FROM student_hobby sh
WHERE sh.finished_at IS NULL
GROUP BY sh.hobby_id) tt
ON tt.hobby_id = hb.id
/*16 Вывести ИД самого популярного хобби. */
SELECT hb.name, hb.id, tt.countOfHobby
FROM hobbies hb
INNER JOIN
(SELECT count(sh.id) as countOfHobby, sh.hobby_id
FROM student_hobby sh
WHERE sh.finished_at IS NULL
GROUP BY sh.hobby_id) tt
ON tt.hobby_id = hb.id
ORDER BY countOfHobby DESC LiMit 1
