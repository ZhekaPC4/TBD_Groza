Create table authorisation(
user_id serial primary key,
login varchar(100) not null unique,
email varchar(100) not null unique,
password varchar(100) not null,
role varchar(20) default user
);

Create table bucket(
id serial primary key,
user_id integer,
foreign key (user_id) references authorisation (user_id),
dishes varchar(255),
total_price float(10)
);

Create table menu(
dish_id serial primary key,
name varchar(100) not null,
weight float(10),
composition varchar(255),
protein float(10),
fats float(10),
carbohydrates float(10),
kcal float(10),
availible bool not null default true,
price float(10) default 0
);

Create table history(
id serial primary key,
user_id integer,
foreign key (user_id) references authorisation (user_id),
user_order varchar(255) not null,
total_price float(10),
date timestamp,
status varchar(20)
);
--Далее пару insert для примера
INSERT INTO authorisation (login, email, password, role)
VALUES ('vasya12', 'vasya12@gamil.com', 'password', 'admin');
--Колонку role нельзя будет задавать при регистрации. Админка будет выдваватся только через систему

INSERT INTO menu (name, weight, composition, protein, fats, carbohydrates, kcal, price)
VALUES ('балтика 9', '0.564', 'балтика 9  0.5л ж/б', '100', '100', '100', '100', '3');
INSERT INTO menu (name, weight, composition, protein, fats, carbohydrates, kcal, price)
VALUES ('балтика 3', '0.564', 'балтика 3  0.5л ж/б', '100', '100', '100', '100','3');

--корзина всегда сущетсвует и сущетсвует только одна для каждого юзера
INSERT INTO bucket (user_id, dishes, total_price)
VALUES ('1', NULL, '0');
--пользователь положил товар в корзину(система будет деражть id товаров с запятой в качестве разделительного знака)
--так как в корзине могут лежать другие товара а до дозаписывания я не додумался, то
select dishes from bucket where id = '1';
--суммируем текущую корзину и заказанный элемент в браузере
update bucket set dishes = '1,' where user_id = '1';
--так как я не придумал делать дописывание (не перезаписывание) через update и set, то пойдем топорнее и будет дейтсововать в три запроса
select total_price from bucket where id = '1';
select price from menu where dish_id = '1';
--суммируем два вышеуказанных результата в браузере
 update bucket set total_price = '3,' where user_id = '1';

--при оофрмлении заказа будем обнулять корзину и перемещать данные в history
 update bucket set dishes = '1,2,' where user_id = '1';

--уточнения:
--корзина и история общая для всех, но когда к ним получает доступ юзер он получает только те записи где user_id его собсвенный
--повторение заказа это не более чем копирование значение поля user_order из history в поле dishes из таблицы bucket 
--управляющий может менять статус заказа с помощью поля status в разделе history