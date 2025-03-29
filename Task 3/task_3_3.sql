/*
Задача 3

Условие

Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:

    Категоризация отелей.

    Определите категорию каждого отеля на основе средней стоимости номера:
        «Дешевый»: средняя стоимость менее 175 долларов.
        «Средний»: средняя стоимость от 175 до 300 долларов.
        «Дорогой»: средняя стоимость более 300 долларов.
    Анализ предпочтений клиентов.

    Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:
        Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
        Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
        Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
    Вывод информации.

    Выведите для каждого клиента следующую информацию:
        ID_customer: уникальный идентификатор клиента.
        name: имя клиента.
        preferred_hotel_type: предпочитаемый тип отеля.
        visited_hotels: список уникальных отелей, которые посетил клиент.
    Сортировка результатов.

    Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».

*/
select
	full_users.id_customer as id_customer,
	full_users.name as name,
	full_users.quality as preferred_hotel_type,
	husers.hotel_names as visited_hotels
from
(
select
	*,
	'Средний' as quality,
	2 as qual_id
from
(with hotel_quality_cus as (
with hotel_cus as (select distinct
	book.id_customer as id_customer,
	cus.name as name,
	r.id_hotel as id_hotel
from
	Booking as book
	join Customer as cus on cus.id_customer = book.id_customer
	join Room as r on r.id_room = book.id_room
order by
	book.id_customer
)
select
	hotel_cus.id_customer as id_customer,
	hotel_cus.name as name,
	hotel_cus.id_hotel as id_hotel,
	hot_cat.avg_price as avg_price,
	hot_cat.quality as quality
from
	hotel_cus
	join 
-- Категории отелей
(with hotels_category as (
with hotes_prices as (select
	id_hotel,
	avg(price) as avg_price
from
	Room
group by
	id_hotel
)
select
	*
from
	(
		select 
			*,
			'Дешёвый' as quality
		from
			hotes_prices
		where
			avg_price < 175
	) as cheap_hotels
union
select
	*
from
	(
		select 
			*,
			'Средний' as quality
		from
			hotes_prices
		where
			avg_price >= 175 and avg_price < 300
	) as middle_hotels
union
select
	*
from
	(
		select 
			*,
			'Дорогой' as quality
		from
			hotes_prices
		where
			avg_price >= 300
	) as cool_hotels
)
select
	*
from
	hotels_category
	) as hot_cat on  hot_cat.id_hotel = hotel_cus.id_hotel
)
select distinct
	id_customer,
	name
	--quality
from
	hotel_quality_cus
where
	quality = 'Средний'
except
select distinct
	id_customer,
	name
	--quality
from
	hotel_quality_cus
where
	quality = 'Дорогой'
)
union
(
	select
		*,
		'Дешёвый' as quality,
		1 as qual_id
	from
	(
with hotel_quality_cus as (
with hotel_cus as (select distinct
	book.id_customer as id_customer,
	cus.name as name,
	r.id_hotel as id_hotel
from
	Booking as book
	join Customer as cus on cus.id_customer = book.id_customer
	join Room as r on r.id_room = book.id_room
order by
	book.id_customer
)
select
	hotel_cus.id_customer as id_customer,
	hotel_cus.name as name,
	hotel_cus.id_hotel as id_hotel,
	hot_cat.avg_price as avg_price,
	hot_cat.quality as quality
from
	hotel_cus
	join 
-- Категории отелей
(with hotels_category as (
with hotes_prices as (select
	id_hotel,
	avg(price) as avg_price
from
	Room
group by
	id_hotel
)
select
	*
from
	(
		select 
			*,
			'Дешёвый' as quality
		from
			hotes_prices
		where
			avg_price < 175
	) as cheap_hotels
union
select
	*
from
	(
		select 
			*,
			'Средний' as quality
		from
			hotes_prices
		where
			avg_price >= 175 and avg_price < 300
	) as middle_hotels
union
select
	*
from
	(
		select 
			*,
			'Дорогой' as quality
		from
			hotes_prices
		where
			avg_price >= 300
	) as cool_hotels
)
select
	*
from
	hotels_category
	) as hot_cat on  hot_cat.id_hotel = hotel_cus.id_hotel
)
select distinct
	id_customer,
	name
	--quality
from
	hotel_quality_cus
where
	quality = 'Дешёвый'
except
select distinct
	id_customer,
	name
	--quality
from
	hotel_quality_cus
where
	quality = 'Дорогой'
except
select distinct
	id_customer,
	name
	--quality
from
	hotel_quality_cus
where
	quality = 'Средний'
	)
)
union (
	select
		*,
		'Дорогой' as quality,
		3 as qual_id
	from
	(
with hotel_quality_cus as (
with hotel_cus as (select distinct
	book.id_customer as id_customer,
	cus.name as name,
	r.id_hotel as id_hotel
from
	Booking as book
	join Customer as cus on cus.id_customer = book.id_customer
	join Room as r on r.id_room = book.id_room
order by
	book.id_customer
)
select
	hotel_cus.id_customer as id_customer,
	hotel_cus.name as name,
	hotel_cus.id_hotel as id_hotel,
	hot_cat.avg_price as avg_price,
	hot_cat.quality as quality
from
	hotel_cus
	join 
-- Категории отелей
(with hotels_category as (
with hotes_prices as (select
	id_hotel,
	avg(price) as avg_price
from
	Room
group by
	id_hotel
)
select
	*
from
	(
		select 
			*,
			'Дешёвый' as quality
		from
			hotes_prices
		where
			avg_price < 175
	) as cheap_hotels
union
select
	*
from
	(
		select 
			*,
			'Средний' as quality
		from
			hotes_prices
		where
			avg_price >= 175 and avg_price < 300
	) as middle_hotels
union
select
	*
from
	(
		select 
			*,
			'Дорогой' as quality
		from
			hotes_prices
		where
			avg_price >= 300
	) as cool_hotels
)
select
	*
from
	hotels_category
	) as hot_cat on  hot_cat.id_hotel = hotel_cus.id_hotel
)
select distinct
	id_customer,
	name
	--quality
from
	hotel_quality_cus
where
	quality = 'Дорогой'
	)
)
) as full_users
join (
with hotelcus as (
			select distinct 
				h.hotel_name as hotel_name,
				book.id_customer as id_customer
			from
				Booking as book
			join ( 
				select
					r.id_room as id_room,
					h.name as hotel_name
				from
					Room as r
				join (
					select
						id_hotel,
						name
					from
						Hotel
				) as h on h.id_hotel = r.id_hotel
			) as h on h.id_room = book.id_room
		order by
			book.id_customer
		)
		select distinct 
    		id_customer,
			count(id_customer) as uniq_hotel_count,
			string_agg(hotel_name, ',') as hotel_names
		from
    		hotelcus
		group by
			id_customer
) as husers on husers.id_customer = full_users.id_customer
order by
	full_users.qual_id,
	full_users.id_customer

		