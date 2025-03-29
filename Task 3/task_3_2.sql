/*

Задача 2

Условие

Необходимо провести анализ клиентов, которые сделали более двух бронирований в разных отелях и потратили более 500 долларов на свои бронирования. Для этого:

    Определить клиентов, которые сделали более двух бронирований и забронировали номера в более чем одном отеле. Вывести для каждого такого клиента следующие данные: ID_customer, имя, общее количество бронирований, общее количество уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.
    Также определить клиентов, которые потратили более 500 долларов на бронирования, и вывести для них ID_customer, имя, общую сумму, потраченную на бронирования, и общее количество бронирований.
    В результате объединить данные из первых двух пунктов, чтобы получить список клиентов, которые соответствуют условиям обоих запросов. Отобразить поля: ID_customer, имя, общее количество бронирований, общую сумму, потраченную на бронирования, и общее количество уникальных отелей.
    Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.

*/
select
	total_tab.id_customer as id_customer,
	total_tab.customer_name as name,
	total_book.booking_number as total_bookings,
	total_tab.total_price as total_spent,
	total_tab.uniq_hotels as unique_hotels
from
(
with uniq_hotel as (
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
)
select
	book.id_customer as id_customer,
	sum(room.price) as total_price,
	cus.name as customer_name,
	uhot.uniq_hotel_count as uniq_hotels
from
	Booking as book
	join Room as room on room.id_room = book.id_room
	join Customer as cus on cus.id_customer = book.id_customer
	join uniq_hotel as uhot on uhot.id_customer = book.id_customer
group by
	book.id_customer,
	cus.name,
	uhot.uniq_hotel_count
) as total_tab
join (
	select
			id_customer,
			count(id_customer) as booking_number
	from
		Booking
	group by
		id_customer
) as total_book on total_book.id_customer = total_tab.id_customer
where
	total_tab.total_price > 500 and total_tab.uniq_hotels > 1
order by
	total_tab.total_price