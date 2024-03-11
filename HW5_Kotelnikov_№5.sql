
Описание задания (аналитика). Задача 5 

Построим маршрут перелетов для всех пассажиров, у которых имя
начинается на «A» и содержит ещё одну букву «A», а фамилия содержит
«OV»:
• Имя и фамилия пассажира в отдельных колонках;
• Дата предыдущего вылета и аэропорт вылета (в одной колонке);
• Дата вылета и аэропорт вылета (в одной колонке);
• Дата следующего вылета и аэропорт вылета (в одной колонке).


/* Для Аделины Абрамовой и Аделины Акимовой*/
with num as(
select t.passenger_name, f.actual_departure, row_number() OVER (partition by t.passenger_name ORDER by f.actual_departure) as row_num
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join airports_data ad1  on  ad1.airport_code = f.departure_airport 
where (t.passenger_name = 'ADELINA ABRAMOVA' or t.passenger_name = 'ADELINA AKIMOVA') 
)
select split_part(t.passenger_name, ' ', 1) as first_name,
split_part(t.passenger_name, ' ', 2) as surname,
(select (to_char(f.actual_departure, 'DD.MM.YYYY') || '  ' || ad1.airport_name['ru']) as DATE_AIRP
	from tickets t1
	join ticket_flights tf on t1.ticket_no = tf.ticket_no 
	join flights f on f.flight_id = tf.flight_id 
	join airports_data ad1  on  ad1.airport_code = f.departure_airport 
	join num on (num.passenger_name = t1.passenger_name) and (num.actual_departure = f.actual_departure)
	where num.row_num = 1 and t1.passenger_name = t.passenger_name
	) as last_flight,
(select (to_char(f.actual_departure, 'DD.MM.YYYY') || '  ' || ad1.airport_name['ru']) as DATE_AIRP
	from tickets t1
	join ticket_flights tf on t1.ticket_no = tf.ticket_no 
	join flights f on f.flight_id = tf.flight_id 
	join airports_data ad1  on  ad1.airport_code = f.departure_airport 
	join num on (num.passenger_name = t1.passenger_name) and (num.actual_departure = f.actual_departure)
	where num.row_num = 2 and t1.passenger_name = t.passenger_name
	) as current_flight,
(select (to_char(f.actual_departure, 'DD.MM.YYYY') || '  ' || ad1.airport_name['ru']) as DATE_AIRP
	from tickets t1
	join ticket_flights tf on t1.ticket_no = tf.ticket_no 
	join flights f on f.flight_id = tf.flight_id 
	join airports_data ad1  on  ad1.airport_code = f.departure_airport 
	join num on (num.passenger_name = t1.passenger_name) and (num.actual_departure = f.actual_departure)
	where num.row_num = 3 and t1.passenger_name = t.passenger_name
	) as next_flight
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join airports_data ad1  on  ad1.airport_code = f.departure_airport 
join num on (num.passenger_name = t.passenger_name) and (num.actual_departure = f.actual_departure)
where (t.passenger_name = 'ADELINA ABRAMOVA' or t.passenger_name = 'ADELINA AKIMOVA') 
group by t.passenger_name, split_part(t.passenger_name, ' ', 1), split_part(t.passenger_name, ' ', 2)


/*Для полной выборки*/

with num as(
select t.passenger_name, f.actual_departure, row_number() OVER (partition by t.passenger_name ORDER by f.actual_departure) as row_num
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join airports_data ad1  on  ad1.airport_code = f.departure_airport 
where (split_part(t.passenger_name, ' ', 1) like 'A%A%') and (length(split_part(t.passenger_name, ' ', 1)) - length(REPLACE(split_part(t.passenger_name, ' ', 1), 'A', '')) = 2) and (split_part(t.passenger_name, ' ', 2) like '%OV%')
)
select split_part(t.passenger_name, ' ', 1) as first_name,
split_part(t.passenger_name, ' ', 2) as surname,
(select (to_char(f.actual_departure, 'DD.MM.YYYY') || '  ' || ad1.airport_name['ru']) as DATE_AIRP
	from tickets t1
	join ticket_flights tf on t1.ticket_no = tf.ticket_no 
	join flights f on f.flight_id = tf.flight_id 
	join airports_data ad1  on  ad1.airport_code = f.departure_airport 
	join num on (num.passenger_name = t1.passenger_name) and (num.actual_departure = f.actual_departure)
	where num.row_num = 1 and t1.passenger_name = t.passenger_name
	) as last_flight,
(select (to_char(f.actual_departure, 'DD.MM.YYYY') || '  ' || ad1.airport_name['ru']) as DATE_AIRP
	from tickets t1
	join ticket_flights tf on t1.ticket_no = tf.ticket_no 
	join flights f on f.flight_id = tf.flight_id 
	join airports_data ad1  on  ad1.airport_code = f.departure_airport 
	join num on (num.passenger_name = t1.passenger_name) and (num.actual_departure = f.actual_departure)
	where num.row_num = 2 and t1.passenger_name = t.passenger_name
	) as current_flight,
(select (to_char(f.actual_departure, 'DD.MM.YYYY') || '  ' || ad1.airport_name['ru']) as DATE_AIRP
	from tickets t1
	join ticket_flights tf on t1.ticket_no = tf.ticket_no 
	join flights f on f.flight_id = tf.flight_id 
	join airports_data ad1  on  ad1.airport_code = f.departure_airport 
	join num on (num.passenger_name = t1.passenger_name) and (num.actual_departure = f.actual_departure)
	where num.row_num = 3 and t1.passenger_name = t.passenger_name
	) as next_flight
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join airports_ data ad1  on  ad1.airport_code = f.departure_airport 
join num on (num.passenger_name = t.passenger_name) and (num.actual_departure = f.actual_departure)
where (split_part(t.passenger_name, ' ', 1) like 'A%A%') and (length(split_part(t.passenger_name, ' ', 1)) - length(REPLACE(split_part(t.passenger_name, ' ', 1), 'A', '')) = 2) and (split_part(t.passenger_name, ' ', 2) like '%OV%') 
group by t.passenger_name, split_part(t.passenger_name, ' ', 1), split_part(t.passenger_name, ' ', 2)

