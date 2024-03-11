Описание задания (аналитика). Задача 1

Необходимо вывести следующую информацию:
• Идентификатор перелёта;
• Код аэропорта отправления;
• Код аэропорта прибытия;
• Запланированные дата и время вылета;
• Актуальные дата и время вылета;
• На сколько был задержан вылет;
• Минимальное время задержки вылета для аэропорта вылета;
• Среднее время задержки вылета для аэропорта вылета;
• Максимальное время задержки вылета для аэропорта вылета;
Данные необходимо вывести только для тех перелетов, для которых существует
информация об актуальных дате и времени вылета и время задержки составляет 1 минута
и более.

with totals as(
select departure_airport, 
avg(actual_departure - scheduled_departure) as avg_delay, 
min(actual_departure - scheduled_departure) as min_delay,
max(actual_departure - scheduled_departure) as max_delay
from flights
where (actual_departure is null = false) and ((actual_departure - scheduled_departure) >= '00:01:00')
group by departure_airport
)
select f.flight_id , f.departure_airport , f.arrival_airport , f.scheduled_departure, f.actual_departure , 
(f.actual_departure - f.scheduled_departure) as delay,
totals.avg_delay as avg_delay,
totals.min_delay as min_delay,
totals.max_delay as max_delay
from flights f
join totals on totals.departure_airport = f.departure_airport
where (f.actual_departure is null = false) and ((f.actual_departure - f.scheduled_departure) >= '00:01:00')



Описание задания (аналитика). Задача 2

Вывести следующую информацию для всех пассажиров, которые осуществляли
бронирование билетов летом 2017 года:
• Имя и фамилия пассажира;
• Номер бронирования;
• Общая сумма бронирования;
• Номер билета;
• Стоимость билета;
• Кол-во билетов в бронировании;
• Стоимость самого дешёвого билета в бронировании;
• Стоимость самого дорогого билета в бронировании;
Данные необходимо отсортировать по убыванию сначала по общей стоимости
бронирования, а затем по убыванию количества билетов в бронировании.

with totals as(
select t.book_ref, 
count(*) as tickets_count, 
min(tf.amount) as min_amount,
max(tf.amount) as max_amount
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
group by t.book_ref 
)
select t.passenger_name, t.book_ref, b.total_amount, t.ticket_no, tf.amount, 
totals.tickets_count as tickets_count,
totals.min_amount as min_amount,
totals.max_amount as max_amount
from tickets t
join bookings b on t.book_ref =b.book_ref 
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join  totals on totals.book_ref =t.book_ref 
where (b.book_date >= '2017-06-01') and (b.book_date <= '2017-08-31')
order by b.total_amount desc, totals.tickets_count desc 



Описание задания (аналитика). Задача 3

Вывести информацию о последнем совершенном перелёте для каждого
пассажира (имя и фамилия пассажира, идентификатор полёта, актуальная
дата вылета, название аэропорта отправления на русском языке, название
аэропорта прибытия на русском языке) с помощью группировок и
агрегирующих функций.

select t.passenger_name, 
f.flight_id, 
f.actual_departure,
ad1.airport_name['ru'] as depart_airp, 
ad2.airport_name['ru'] as arriv_airp
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join airports_data ad1  on  ad1.airport_code = f.departure_airport 
join airports_data ad2  on  ad2.airport_code = f.arrival_airport  
where (f.actual_departure is not null) and (f.actual_departure = (select max(actual_departure) 
from tickets t1
join ticket_flights tf1 on t1.ticket_no = tf1.ticket_no 
join flights f1 on f1.flight_id = tf1.flight_id 
where (t1.passenger_name = t.passenger_name) 
group by t1.passenger_name) )  
order by passenger_name 


Описание задания (аналитика). Задача 4

Вывести информацию из предыдущего пункта с использованием оконных
функций.


with w as(
select t.passenger_name, max(actual_departure) as lst_flight
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
where actual_departure is not null
group by t.passenger_name 
)
select t.passenger_name, f.flight_id, w.lst_flight, ad1.airport_name['ru'] as depart_airp, ad2.airport_name['ru'] as arriv_airp
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join airports_data ad1  on  ad1.airport_code = f.departure_airport 
join airports_data ad2  on  ad2.airport_code = f.arrival_airport 
join w on w.passenger_name =t.passenger_name 
where (actual_departure is not null) and (actual_departure = w.lst_flight)
order by t.passenger_name 
limit 10



select t.passenger_name, max(actual_departure) as lst_flight
from tickets t
join ticket_flights tf on t.ticket_no = tf.ticket_no 
join flights f on f.flight_id = tf.flight_id 
join ticket_flights tf on t.ticket_no = tf.ticket_no 
where actual_departure is not null
group by t.passenger_name 



Описание задания (аналитика). Задача 5 

Построим маршрут перелетов для всех пассажиров, у которых имя
начинается на «A» и содержит ещё одну букву «A», а фамилия содержит
«OV»:
• Имя и фамилия пассажира в отдельных колонках;
• Дата предыдущего вылета и аэропорт вылета (в одной колонке);
• Дата вылета и аэропорт вылета (в одной колонке);
• Дата следующего вылета и аэропорт вылета (в одной колонке).


