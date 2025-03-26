/*
Задача 1

Условие

Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, 
и вывести информацию о каждом таком автомобиле для данного класса, включая его класс, 
среднюю позицию и количество гонок, в которых он участвовал. Также отсортировать результаты по средней позиции.
*/

/* Идиология подхода: 
1. делаем общую таблицу в которой содержатся поля усредненой позиции, количества гонок, названия машины и её класса (но эту таблицу джойним в последнюю очередь)
2. делаем точно такую же таблицу как и в п.1 только в ней считаем минимальную позицию и группируем по классу 
3. джойним в таблицу из п.2 таблицу из п.1 при этом строки соотносим по полям класса и средней позиции
4. В итоговой таблице выводим только строки названия машин, класса, средней позиции и счётчика гонок. Всё это дело сортируем по средней позиции */
select
	b.name as car_name,
	b.class as car_class,
	b.avg_pos as average_position,
	b.race_count as race_count
from
	(
		select
			c.class as cls,
			min(r.avg_pos) as average_pos
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
			) as r
			join (
				select
					name,
					class
				from
					Cars
			) as c on c.name = r.car
		group by
			c.class
	) as a
	join
		(
			select
			*
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
			) as r
			join (
				select
					name,
					class
				from
					Cars
			) as c on c.name = r.car
	) as b on (b.avg_pos = a.average_pos and b.class = a.cls)
order by
	b.avg_pos
