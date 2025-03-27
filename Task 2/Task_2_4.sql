/*
Задача 4

Условие

Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе 
(то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них). Вывести информацию об этих 
автомобилях, включая их имя, класс, среднюю позицию, количество гонок, в которых они участвовали, 
и страну производства класса автомобиля. Также отсортировать результаты по классу и затем по средней 
позиции в порядке возрастания.
*/
select
	final2.car_name as car_name,
	final1.car_class as car_class,
	final1.min as average_position,
	final2.race_count as race_count,
	final2.car_country as car_country
from
(select
    car_class,
    min(average_position)
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
	)
where
	car_class in (
	    select
			car_class
		from
		(select
		    tmp.car_class,
    		count(tmp.car_class)
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
		) as tmp
		group by
			tmp.car_class
		having
			count(tmp.car_class) > 1
		)
	)
group by
	car_class
) as final1
join (select
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
	)
where
	car_class in (
	    select
			car_class
		from
		(select
		    tmp.car_class,
    		count(tmp.car_class)
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
		) as tmp
		group by
			tmp.car_class
		having
			count(tmp.car_class) > 1
		)
	)
) as final2 on final2.car_class = final1.car_class and final2.average_position = final1.min
order by
	final1.car_class,
	final1.min desc