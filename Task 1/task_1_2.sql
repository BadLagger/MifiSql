-- Задача 2
-- Найти информацию о производителях и моделях различных типов транспортны
-- средств (автомобили, мотоциклы и велосипеды), которые соответствуют заданным
-- критериям.
-- 1. Автомобили: 
--   Извлечь данные о всех автомобилях, которые имеют:
-- * Мощность двигателя более 150 лошадиных сил.
-- * Объем двигателя менее 3 литров.
-- * Цену менее 35 тысяч долларов.
--   В выводе должны быть указаны производитель (maker), номер модели (model),
-- мощность (horsepower), объем двигателя (engine_capacity) и тип транспортного
-- средства, который будет обозначен как Car.
-- 2. Мотоциклы:
--   Извлечь данные о всех мотоциклах, которые имеют:
-- * Мощность двигателя более 150 лошадиных сил.
-- * Объем двигателя менее 1,5 литров.
-- * Цену менее 20 тысяч долларов.
--   В выводе должны быть указаны производитель (maker), номер модели (model), 
-- мощность (horsepower), объем двигателя (engine_capacity) и тип транспортного
-- средства, который будет обозначен как Motorcycle.
-- 3. Велосипеды:
--   Извлечь данные обо всех велосипедах, которые имеют:
-- * Количество передач больше 18.
-- * Цену менее 4 тысяч долларов.
--  В выводе должны быть указаны производитель (maker), номер модели (model), а 
-- также NULL для мощности и объема двигателя, так как эти характеристики не
-- применимы для велосипедов. Тип транспортного средства будет обозначен как
-- Bicycle.
-- 4. Сортировка: 
--   Результаты должны быть объединены в один набор данных и отсортированы по
-- мощности в порядке убывания. Для велосипедов, у которых нет значения
-- мощности, они будут располагаться внизу списка.
select
	veh.maker,
	veh.model,
	tmp.horsepower,
	tmp.engine_capacity,
	veh.type as vehicle_type
from
	Vehicle as veh
	left join (
		select
		    model,
			horsepower,
			engine_capacity
		from
			Car
		where
			price < 35000 and horsepower > 150 and engine_capacity < 3
		union
		select
			model,
			horsepower,
			engine_capacity
		from
			Motorcycle
		where
			price < 20000 and horsepower > 150 and engine_capacity < 1.5
	) as tmp on tmp.model = veh.model
	left join (
		select
			model
		from 
			Bicycle
		where
			price < 4000 and gear_count > 18
	) as bic on bic.model = veh.model 
where
	((veh.type = 'Bicycle' and bic.model is not null) or veh.type != 'Bicycle')
	and ((veh.type = 'Car' and tmp.model is not null) or veh.type != 'Car')
	and ((veh.type = 'Motorcycle' and tmp.model is not null) or veh.type != 'Motorcycle')
order by
	tmp.horsepower desc nulls last;