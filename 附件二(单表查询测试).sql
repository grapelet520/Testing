
Q1:
select 
		COUNT(*) cnt 
from 
		v_sendschedule;

Q2:
select 
		AVG(f_passenger) avg_p
from 
		v_sendschedule;

Q3:
select 
		SUM(f_passenger) sum_p
from 
		v_sendschedule;

Q4:
select 
		*
from 
		v_sendschedule
where 	f_date='2018-10-01' and f_passenger>0
limit 100;

Q5:
select 
		f_stationcode,
		COUNT(*) cnt,
		SUM(f_passenger) sum_p
from 
		v_sendschedule
where 	f_date>='2018-01-01' and f_date <'2019-01-01'
group by f_stationcode
order by f_stationcode desc
limit 10;

Q6:
select 
		f_endnodecode,
		COUNT(*) cnt,
		SUM(f_passenger) sum_p
from 
		v_sendschedule
where 	f_date>='2018-01-01' and f_date <'2019-01-01'
group by f_endnodecode
order by sum_p desc
limit 10;

Q7:
select 
		f_stationcode,
		f_date,
		COUNT(*) cnt,
		SUM(f_passenger) sum_p
from 
		v_sendschedule
where 	f_date>='2018-01-01' and f_date <'2019-01-01'
group by f_date,f_stationcode
order by f_stationcode,f_date desc
limit 10;

Q8:
select 
		f_date,
		f_buscode,
		COUNT(distinct(f_localcode)) cnt,
		SUM(f_passenger) sum_p
from 
		v_sendschedule
where 	f_date>='2018-01-01' and f_date <'2019-01-01'
group by f_date,f_buscode
order by f_date desc,f_buscode
limit 10;

Q9:
select 
		f_date,
		f_stationcode,
		f_localcode,
		SUM(f_passenger) sum_p,
		SUM(f_passengerout) sum_po,
		AVG(f_passenger) avg_p
from 
		v_sendschedule
where 	f_date>='2018-01-01' and f_date <'2019-01-01'
group by f_date,f_stationcode,f_localcode
order by f_stationcode,f_date desc
limit 10;

