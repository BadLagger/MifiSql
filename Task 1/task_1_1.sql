-- Задача 1
-- Найдите производителей (maker) и модели всех мотоциклов, которые имеют
-- мощность более 150 лошадиных сил, стоят менее 20 тысяч долларов и являются
-- спортивными (тип Sport). Также отсортируйте результаты по мощности в порядке
-- убывания.
select
	veh.maker,
	moto.model
from 
	Vehicle as veh
	join Motorcycle as moto on veh.model = moto.model
where
	veh.type = 'Motorcycle' and moto.type = 'Sport' and moto.price < 20000 and moto.horsepower > 150
order by
	moto.horsepower desc;