/*
Задача 3

Условие

Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, 
и вывести информацию о каждом автомобиле из этих классов, включая его имя, 
среднюю позицию, количество гонок, в которых он участвовал, страну производства класса автомобиля, 
а также общее количество гонок, в которых участвовали автомобили этих классов. 
Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
*/
select
	*
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
	) as res
where
	average_position = (select
							min(ret.avg_pos)
						from 
							(
								select
								    r.car as car,
									cast(avg(r.position) as numeric(10, 4)) as avg_pos
								from
									Results as r
								group by
									r.car
							) as ret
						)
									 