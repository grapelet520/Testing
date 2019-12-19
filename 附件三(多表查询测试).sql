
--数据量(一年)
--v_sendschedule:		2396321
--v_sendschedule_detail：7001807
--v_schedule：			3723008
--v_schedule_detail:	8009738
Q1:
--售票时间分布
select 	
		f_time,
		SUM(f_ticketsale) sumTicketsale,
		SUM(f_passenger) sumPassenger 
from 
	(
		select 
				(case when vss.f_time is null then vs.f_time else vss.f_time end) f_time, 
				(case when f_ticketsale is null then 0 else f_ticketsale end) f_ticketsale, 
				(case when f_passenger is null then 0 else f_passenger end)  f_passenger 
		from 
				(
					select 
							f_time,
							SUM(f_passenger) f_passenger 
					from 
							v_sendschedule
					where 	f_date>='2018-01-01' and f_date <'2019-01-01' 
					group 	by f_time
				) vss 
				full outer join 
				(
					select 
							f_time,
							SUM(f_ticketsale) f_ticketsale 
					from 
							v_schedule
					where 	f_date>='2018-01-01' and f_date <'2019-01-01'
					group by f_time
				) vs 
		on 	vss.f_time=vs.f_time 
		order by f_time 
	) result 
group by f_time 
order by f_time;

Q2:
--总班次信息
select  
		ticket.f_stationcode,
		station_xl.xlzs, 
		ticket.bczs, 
		ticket.ylzs, 
		ticket.z_bczs,
		ticket.z_ylzs, 
		ticket.j_bczs,
		ticket.j_ylzs, 
		ticket.ysps,
		ticket.syps, 
		ticket.wsyps
from
		(
			select 
					f_stationcode, 
					SUM(z_bczs)+SUM(j_bczs) bczs, 
					SUM(z_ylzs)+SUM(j_ylzs) ylzs,
					MAX(z_bczs) z_bczs, 
					MAX(z_ylzs) z_ylzs,
					MAX(j_bczs) j_bczs, 
					MAX(j_ylzs) j_ylzs,
					SUM(ysps) ysps, 
					SUM(syps) syps, 
					SUM(wsyps) wsyps
			from 
				(
					select 
							f_stationcode,
							(case when f_schtype='正班' then COUNT(f_schtype) else 0 end) z_bczs,
							(case when f_schtype='正班' then SUM(f_ticketsell)+SUM(f_ticketsale) else 0 end) z_ylzs,
							(case when f_schtype='加班' then COUNT(f_schtype) else 0 end) j_bczs,
							(case when f_schtype='加班' then SUM(f_ticketsell)+SUM(f_ticketsale) else 0 end) j_ylzs,
							sum(f_ticketsale) ysps, 
							sum(f_ticketsell) syps, 
							sum(f_seatcount) wsyps  
					from 
							v_schedule
					where 	f_date>='2018-01-01' and f_date <'2019-01-01'
					group by f_stationcode,f_schtype
				) station_bc
			group by f_stationcode
		) ticket
		left outer join
		(
			select 
					f_stationcode, 
					COUNT(distinct f_linename) xlzs 
			from 
					v_schedule 
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode
		) station_xl
on ticket.f_stationcode=station_xl.f_stationcode
order by ticket.f_stationcode,station_xl.xlzs;

Q3:
--区域售票量：
select 
		area_name,
		SUM(f_ticketsale) 
from
		(
			select 
					station_code,
					area_name 
			from 
					t_station 
			where 	is_valid=1 
		) station
		left outer join
		(
			select 
					f_stationcode,
					SUM(f_ticketsale) f_ticketsale 
			from 
					v_schedule 
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode
		) vss
on station.station_code=vss.f_stationcode
group by station.area_name;

Q4:
--区域旅客量：
select 
		area_name,
		SUM(f_passenger) 
from
		(
			select 
					station_code,
					area_name 
			from 	t_station 
			where 	is_valid=1 
		) station
		left outer join
		(
			select 
					f_stationcode,
					SUM(f_passenger) f_passenger 
			from 	v_sendschedule 
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode
		) vss
on station.station_code=vss.f_stationcode
group by station.area_name;

Q5:
--发班流向
select 	
		f_linekind, 
		(SUM(z_bczs)+SUM(j_bczs)) bczs, 
		(SUM(z_rs)+SUM(j_rs)) rs,
		SUM(z_bczs) z_bczs, 
		SUM(z_rs) z_rs, 
		SUM(j_bczs) j_bczs, 
		SUM(j_rs) j_rs,
		SUM(ylzs) ylzs, 
		SUM(zds) zds
from (
		select 	
				f_linekind,
				f_schtype,
				(case when f_schtype='正班' or f_schtype is null then COUNT(1) else 0 end) z_bczs,
				(case when f_schtype='正班' or f_schtype is null then SUM(f_passenger) else 0 end) z_rs,
				(case when f_schtype='加班' then COUNT(1) else 0 end) j_bczs,
				(case when f_schtype='加班' then SUM(f_passenger) else 0 end) j_rs,
				SUM(f_ticketsale+f_ticketsell) ylzs,
				SUM(zds) zds	
		from 
				(
					select 
							f_stationcode,f_localcode,
							f_date,f_time,
							SUM(f_ticketsale) f_ticketsale,
							SUM(f_ticketsell) f_ticketsell,
							f_schtype,f_linekind
					from 
							v_schedule 
					where 	f_date>='2018-01-01' and f_date<'2019-01-01'
					group by f_stationcode,f_localcode,f_time,f_date,f_linekind,f_schtype 
				) vs2
				full outer join
				(
					select 
							f_stationcode,
							f_localcode,
							f_date,f_time,
							f_outtime, 
							SUM(f_passenger) f_passenger,
							(case when f_time<=f_outtime then 1 else 0 end) zds 
					from 
							v_sendschedule 
					where 	f_date>='2018-01-01' and f_date<'2019-01-01'
					group by 
							f_stationcode,
							f_localcode,
							f_date,
							f_time,
							f_outtime
				) vss2
		on 
				vs2.f_stationcode=vss2.f_stationcode 
				and vs2.f_localcode=vss2.f_localcode 
				and vs2.f_time=vss2.f_time 
				and vs2.f_date=vss2.f_date
		where 
				vs2.f_stationcode is not null 
				or vss2.f_stationcode is not null
		group by 
				vs2.f_linekind,
				vs2.f_schtype 
) schtype
group by f_linekind
order by f_linekind,rs desc;

Q6:
--发班情况
select  
		vs.f_date,
		(case when should is null then 0 else should end) should,
		(case when actual is null then 0 else actual end) actual,
		on_time,
		(case when actual>0 then round(cast(on_time as numeric)/cast(actual as numeric),4) else 0 end) on_time_ratio,
		delay,delay_one,delay_two,delay_three,delay_four,delay_greater_than_four
from 
		(
			select 
					f_date,
					f_stationcode,
					COUNT(f_localcode) should
			from 
					v_schedule 
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode,f_date
		) vs 
		left outer join 
		(
			select 	
					f_date,
					f_stationcode, 
					COUNT(f_localcode) actual,
					sum(case when difftime<=15 then 1 else 0 end ) on_time, 
					sum(case when difftime>15 then 1 else 0 end ) delay,
					sum(case when difftime<=100 and difftime>15 then 1 else 0 end ) delay_one, 
					sum(case when difftime<=200 and difftime>100 then 1 else 0 end ) delay_two, 
					sum(case when difftime<=300 and difftime>200 then 1 else 0 end ) delay_three, 
					sum(case when difftime<=400 and difftime>300 then 1 else 0 end ) delay_four, 
					sum(case when difftime>=400 then 1 else 0 end ) delay_greater_than_four
			from 
					(
						select 
								f_date,f_stationcode,
								f_localcode,
								(cast(f_outtime as int)-cast(f_time as int)) as difftime
						from 
								v_sendschedule 
						where 	f_date>='2018-01-01' and f_date <'2019-01-01'
					) vs 
			group by f_stationcode,f_date
		) vss2 
		on vs.f_stationcode=vss2.f_stationcode and vs.f_date=vss2.f_date
order by 	should desc
limit 100;

Q7:
--发班信息
--6414*19514
select 
		vssd.f_stationcode,
		f_passenger,
		f_nodenumber 
from 
		(
			select 
					f_stationcode,
					SUM(f_passenger) f_passenger
			from 
					v_sendschedule
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode
		)vss,
		(
			select 
					f_stationcode,
					SUM(f_nodenumber) f_nodenumber 
			from 
					v_sendschedule_detail
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode
		) vssd
where 	vssd.f_stationcode=vss.f_stationcode;

Q8:
--客运站某天营业额
--19514*21351
select 
		vssd.f_stationcode,
		vssd.f_date,
		f_nodenumber*f_price total_price 
from 
		(
			select 
					f_stationcode,
					f_date,
					SUM(f_nodenumber) f_nodenumber
			from 
					v_sendschedule_detail
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode,f_date
		) vssd,
		(
			select 
					f_stationcode,
					f_date,
					SUM(f_price) f_price 
			from 
					v_schedule_detail
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode,f_date
		)vsd
where 
		vssd.f_stationcode=vsd.f_stationcode 
		and vssd.f_date=vsd.f_date 
order by vssd.f_stationcode,vssd.f_date
limit 100;

Q9:
--线路流量
select 
		vssd.f_stationcode,
		vssd.f_nodecode,
		f_nodenumber total_nodenumber,
		f_price total_price 
from 
		(
			select 
					f_stationcode,
					f_nodecode,
					SUM(f_nodenumber) f_nodenumber 
			from 
					v_sendschedule_detail
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode,f_nodecode
		) vssd,
		(
			select 
					f_stationcode,
					f_nodecode,
					SUM(f_price) f_price 
			from 	v_schedule_detail
			where 	f_date>='2018-01-01' and f_date <'2019-01-01'
			group by f_stationcode,f_nodecode
		)vsd
where 
		vssd.f_stationcode=vsd.f_stationcode 
		and vssd.f_nodecode=vsd.f_nodecode
order by vssd.f_stationcode,vssd.f_nodecode
limit 100;