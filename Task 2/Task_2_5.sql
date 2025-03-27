/*
Задача 5

Условие

Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией 
(больше 3.0) и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, 
среднюю позицию, количество гонок, в которых он участвовал, страну производства класса автомобиля, 
а также общее количество гонок для каждого класса. Отсортировать результаты по количеству 
автомобилей с низкой средней позицией.
*/
select
	final1.car_name as car_name,
	final1.car_class as car_class,
	final1.average_position as average_position,
	final1.race_count as race_count, 
	final1.car_country as car_country,
	final2.count as total_races
from
	(
	select
		c.name as car_name,
		c.class as car_class,
		r.avg_pos as average_position,
		r.race_count as race_count,
		cls.country as car_country
	from
		(
			select
				res.car as car,
				cast(avg(res.position) as numeric(10, 4)) as avg_pos,
				count(res.race) as race_count
			from
				Results as res
				group by
					res.car
		) as r join (
			select
				name,
				class
			from
				Cars
		) as c on c.name = r.car
		join (
			select
				class,
				country
			from
				Classes
		) as cls on cls.class = c.class
	order by
		average_position, car_class
	) as final1
	join (select
    class,
	count(race_count)
from
(
			select
				res.car as car,
				cast(avg(res.position) as numeric(10, 4)) as avg_pos,
				count(res.race) as race_count
			from
				Results as res
				group by
					res.car
		) as r join (
			select
				name,
				class
			from
				Cars
		) as c on c.name = r.car
group by
	class) as final2 on final1.car_class = final2.class
where
	average_position > 3
order by
	count desc,
	average_position