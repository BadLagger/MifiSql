select
	cas.name,
	cas.email,
	cas.phone,
	book.booking_number,
	hot.hotel_names,
	book.avg_days
from
	Customer as cas
	join
	/* id_customer, booking_number, avg_days*/
	(
		select
			id_customer,
			count(id_customer) as booking_number,
			cast(avg(check_out_date - check_in_date) as numeric(10, 4)) as avg_days
		from
			Booking
		group by
			id_customer
	) as book on book.id_customer = cas.id_customer
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
	) as hot on hot.id_customer = cas.id_customer
where
	hot.uniq_hotel_count > 1 and book.booking_number > 2
order by
	book.booking_number
	