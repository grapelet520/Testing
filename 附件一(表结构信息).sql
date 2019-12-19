BEGIN;
CREATE TABLE t_station
(
  station_id character varying(32) NOT NULL,
  company_id character varying(32),
  area_id character varying(32),
  depot_id character varying(32),
  station_name character varying(60),
  station_code character varying(40),
  station_level character varying(8),
  latitude numeric,
  longitude numeric,
  station_phoneno character varying(20),
  station_address character varying(100),
  businesser_code character varying(100),
  businesser_name character varying(100),
  province character varying(30),
  city character varying(30),
  county character varying(30),
  town character varying(30),
  station_type character varying(20),
  station_location character varying(10),
  evaluate_date date,
  oper_unit_comp_no integer,
  start_time date,
  end_time date,
  owner_name character varying(80),
  status character varying(20),
  all_floor_area numeric,
  is_valid integer NOT NULL DEFAULT 1,
  area_name character varying(12),
  CONSTRAINT t_station_pkey PRIMARY KEY (station_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE t_station
  OWNER TO test;

\copy t_station from '/home/tbase/data/t_station' with delimiter as '`';

COMMIT;
--------------------------------------------------------------------------
BEGIN;

CREATE SEQUENCE v_schedule_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 2398120859
  CACHE 1;
ALTER TABLE v_schedule_id_seq
  OWNER TO test;

CREATE TABLE v_schedule
(
  id bigint NOT NULL DEFAULT nextval('v_schedule_id_seq'::regclass),
  f_guid character varying(50),
  f_stationcode character varying(50),
  f_stationname character varying(50),
  f_globalcode character varying(50),
  f_localcode character varying(50),
  f_linename character varying(50),
  f_transtype character varying(20),
  f_linekind character varying(20),
  f_schkind character varying(20),
  f_schtype character varying(20),
  f_schmode character varying(20),
  f_starttime character varying(20),
  f_endtime character varying(20),
  f_rotationinterval character varying(20),
  f_time character varying(20),
  f_date date,
  f_endnodecode character varying(100),
  f_status character varying(50),
  f_seatcount integer,
  f_ticketsale integer,
  f_ticketsell integer,
  f_ticketcount integer,
  f_freechildrenticketsale integer,
  f_enterprisecode character varying(50),
  f_businessbus character varying(20),
  f_bustype character varying(50),
  f_seattype character varying(20),
  f_buslevel character varying(50),
  f_uploadtime timestamp without time zone,
  f_updatetime timestamp without time zone,
  CONSTRAINT pk_v_schedule PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE v_schedule
  OWNER TO test;

CREATE INDEX idx_vs_date
  ON v_schedule
  USING btree
  (f_date);

\copy v_schedule(f_guid,f_stationcode,f_stationname,f_globalcode,f_localcode,f_linename,f_transtype,f_linekind,f_schkind,f_schtype,f_schmode,f_starttime,f_endtime,f_rotationinterval,f_time,f_date,f_endnodecode,f_status,f_seatcount,f_ticketsale,f_ticketsell,f_ticketcount,f_freechildrenticketsale,f_enterprisecode,f_businessbus,f_bustype,f_seattype,f_buslevel,f_uploadtime,f_updatetime) from '/home/tbase/data/v_schedule' with delimiter as '`';

COMMIT;
--------------------------------------------------------------------------
BEGIN;

CREATE SEQUENCE v_schedule_detail_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 2600946103
  CACHE 1;
ALTER TABLE v_schedule_detail_id_seq
  OWNER TO test;
  
CREATE TABLE v_schedule_detail
(
  id bigint NOT NULL DEFAULT nextval('v_schedule_detail_id_seq'::regclass),
  f_guid character varying(50),
  f_parentid character varying(50),
  f_stationcode character varying(50),
  f_localcode character varying(50),
  f_date date,
  f_nodecode character varying(50),
  f_traveltime character varying(50),
  f_mileage character varying(20),
  f_upperprice numeric(9,2),
  f_price numeric(9,2),
  f_halfprice numeric(9,2),
  f_createtime timestamp without time zone,
  f_updatetime timestamp without time zone,
  CONSTRAINT pk_v_schedule_detail3 PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE v_schedule_detail
  OWNER TO test;

CREATE INDEX idx_vsd_date
  ON v_schedule_detail
  USING btree
  (f_date);

CREATE INDEX idx_vsd_union
  ON v_schedule_detail
  USING btree
  (f_stationcode,f_date,f_localcode,f_nodecode);

\copy v_schedule_detail(f_guid,f_parentid,f_stationcode,f_localcode,f_date,f_nodecode,f_traveltime,f_mileage,f_upperprice,f_price,f_halfprice,f_createtime,f_updatetime) from '/home/tbase/data/v_schedule_detail' with delimiter as '`';

COMMIT;
--------------------------------------------------------------------------
BEGIN;

CREATE SEQUENCE v_sendschedule_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 693998901
  CACHE 1;
ALTER TABLE v_sendschedule_id_seq
  OWNER TO test;
  
CREATE TABLE v_sendschedule
(
  id bigint NOT NULL DEFAULT nextval('v_sendschedule_id_seq'::regclass),
  f_guid character varying(50),
  f_stationcode character varying(50),
  f_stationname character varying(50),
  f_busic character varying(50),
  f_buscode character varying(50),
  f_buscolor character varying(20),
  f_enterprisecode character varying(50),
  f_globalcode character varying(50),
  f_localcode character varying(50),
  f_date date,
  f_time character varying(20),
  f_intime character varying(20),
  f_outtime character varying(20),
  f_safecheck character varying(20),
  f_passenger integer,
  f_passengerin integer,
  f_passengerfee integer,
  f_child integer,
  f_passengerout integer,
  f_oper character varying(20),
  f_optime timestamp without time zone,
  f_memo character varying(255),
  f_uploadtime timestamp without time zone,
  f_seattype character varying(10),
  f_buslevel character varying(50),
  f_endnodecode character varying(50),
  f_schkind character varying(20),
  f_schtype character varying(20),
  f_schmode character varying(20),
  f_drivinglicensevalid character varying(10),
  f_isdanger character varying(10),
  f_dangername character varying(255),
  f_issafetybelt character varying(10),
  f_isoverman character varying(10),
  f_createtime timestamp without time zone,
  f_updatetime timestamp without time zone,
  CONSTRAINT pk_v_sendschedule PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE v_sendschedule
  OWNER TO test;

CREATE INDEX idx_vss_date
  ON v_sendschedule
  USING btree
  (f_date);
  
\copy v_sendschedule(f_guid,f_stationcode,f_stationname,f_busic,f_buscode,f_buscolor,f_enterprisecode,f_globalcode,f_localcode,f_date,f_time,f_intime,f_outtime,f_safecheck,f_passenger,f_passengerin,f_passengerfee,f_child,f_passengerout,f_oper,f_optime,f_memo,f_uploadtime,f_seattype,f_buslevel,f_endnodecode,f_schkind,f_schtype,f_schmode,f_drivinglicensevalid,f_isdanger,f_dangername,f_issafetybelt,f_isoverman,f_createtime,f_updatetime) from '/home/tbase/data/v_sendschedule' with delimiter as '`';

COMMIT;
--------------------------------------------------------------------------
BEGIN;

CREATE SEQUENCE v_sendschedule_detail_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1405805996
  CACHE 1;
ALTER TABLE v_sendschedule_detail_id_seq
  OWNER TO test;
  
CREATE TABLE v_sendschedule_detail
(
  id bigint NOT NULL DEFAULT nextval('v_sendschedule_detail_id_seq'::regclass),
  f_guid character varying(50),
  f_parentid character varying(50),
  f_stationcode character varying(50),
  f_date date,
  f_localcode character varying(50),
  f_nodecode character varying(50),
  f_nodename character varying(50),
  f_nodenumber integer,
  f_createtime timestamp without time zone,
  f_updatetime timestamp without time zone,
  CONSTRAINT pk_v_sendschedule_detail PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE v_sendschedule_detail
  OWNER TO test;

CREATE INDEX idx_vssd_date
  ON v_sendschedule_detail
  USING btree
  (f_date);

CREATE INDEX idx_vssd_union
  ON v_sendschedule_detail
  USING btree
  (f_stationcode,f_date,f_localcode,f_nodecode);

 \copy v_sendschedule_detail(f_guid,f_parentid,f_stationcode,f_date,f_localcode,f_nodecode,f_nodename,f_nodenumber,f_createtime,f_updatetime) from '/home/tbase/data/v_sendschedule_detail' with delimiter as '`';

COMMIT;
