drop table if exists stg.srv_wf_settings;
CREATE TABLE stg.srv_wf_settings (
	id serial4 NOT NULL,
	workflow_key varchar NOT NULL,
	workflow_settings text NOT NULL
);

drop table if exists stg.couriers;
CREATE TABLE stg.couriers (
	id serial4 NOT NULL,
	couriers_id varchar NOT NULL,
	couriers_info text NOT NULL,
	CONSTRAINT couriers_id_unique UNIQUE (couriers_id),
	CONSTRAINT couriers_pkey PRIMARY KEY (id)
);

drop table if exists stg.deliveries;
CREATE TABLE stg.deliveries (
	id serial4 NOT NULL,
	deliveries_id varchar NOT NULL,
	deliveries_info text NOT NULL,
	deliveries_ts timestamp NOT NULL,
	CONSTRAINT deliveries_id_unique UNIQUE (deliveries_id),
	CONSTRAINT deliveries_pkey PRIMARY KEY (id),
	CONSTRAINT deliveries_ts_check CHECK (((deliveries_ts > '2022-01-01 00:00:00'::timestamp without time zone) AND (deliveries_ts <= (CURRENT_TIMESTAMP + '08:00:00'::interval))))
);

drop table if exists stg.restaurants;
CREATE TABLE stg.restaurants (
	id serial4 NOT NULL,
	restaurants_id varchar NOT NULL,
	restaurants_info text NOT NULL,
	CONSTRAINT restaurants_id_unique UNIQUE (restaurants_id),
	CONSTRAINT restaurants_pkey PRIMARY KEY (id)
);

drop table if exists dds.restaurants;
CREATE TABLE dds.restaurants (
	id serial4 NOT NULL,
	"_id" varchar NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT restaurants_id_unique UNIQUE (_id),
	CONSTRAINT restaurants_pkey PRIMARY KEY (id)
);



drop table if exists dds.couriers;
CREATE TABLE dds.couriers (
	id serial4 NOT NULL,
	"_id" varchar NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT couriers_id_unique UNIQUE (_id),
	CONSTRAINT couriers_pkey PRIMARY KEY (id)
);


drop table if exists dds.deliverys;
CREATE TABLE dds.deliverys (
	id serial4 NOT NULL,
	order_id varchar NOT NULL,
	order_ts timestamp NOT NULL,
	delivery_id varchar NOT NULL,
	courier_id varchar NOT NULL,
	address text NOT NULL,
	delivery_ts timestamp NOT NULL,
	rate int2 NOT NULL,
	sum numeric(14, 2) NOT NULL,
	tip_sum numeric(14, 2) NULL,
	CONSTRAINT delivery_id_unique UNIQUE (delivery_id),
	CONSTRAINT deliverys_delivery_ts_check CHECK (((delivery_ts > '2022-01-01 00:00:00'::timestamp without time zone) AND (delivery_ts <= (CURRENT_TIMESTAMP + '08:00:00'::interval)))),
	CONSTRAINT deliverys_order_ts_check CHECK (((order_ts > '2022-01-01 00:00:00'::timestamp without time zone) AND (order_ts <= (CURRENT_TIMESTAMP + '08:00:00'::interval)))),
	CONSTRAINT deliverys_pkey PRIMARY KEY (id),
	CONSTRAINT deliverys_rate_check CHECK (((rate >= 1) AND (rate <= 5))),
	CONSTRAINT deliverys_sum_check CHECK ((sum > (0)::numeric)),
	CONSTRAINT deliverys_tip_sum_check CHECK ((tip_sum >= (0)::numeric))
);

drop table if exists dds.srv_wf_settings;
CREATE TABLE dds.srv_wf_settings (
	id serial4 NOT NULL,
	workflow_key varchar NULL,
	workflow_settings text NULL
);

drop table if exists cdm.dm_courier_ledger;
CREATE TABLE cdm.dm_courier_ledger (
id serial4 NOT NULL,
	courier_name text NOT NULL,
	settlement_year int4 NOT NULL,
	settlement_month int2 NOT NULL,
	orders_count int4 NOT NULL,
	orders_total_sum numeric(14, 2) NOT NULL,
	rate_avg float8 NOT NULL,
	order_processing_fee numeric(14, 2) NOT NULL,
	courier_order_sum numeric(14, 2) NOT NULL,
	courier_tips_sum numeric(14, 2) NOT NULL,
	courier_reward_sum numeric(14, 2) NOT NULL,
	CONSTRAINT dm_courier_ledger_courier_settlement_year_check CHECK ((settlement_year > 2020) and (settlement_year <= extract(year from now()))),
	CONSTRAINT dm_courier_ledger_courier_settlement_month_check CHECK ((settlement_month >= 1) and (settlement_month <= 12)),
	CONSTRAINT dm_courier_ledger_courier_order_sum_check CHECK ((courier_order_sum >= (0)::numeric)),
	CONSTRAINT dm_courier_ledger_courier_reward_sum_check CHECK ((courier_reward_sum >= (0)::numeric)),
	CONSTRAINT dm_courier_ledger_courier_tips_sum_check CHECK ((courier_tips_sum >= (0)::numeric)),
	CONSTRAINT dm_courier_ledger_order_processing_fee_check CHECK ((order_processing_fee >= (0)::numeric)),
	CONSTRAINT dm_courier_ledger_orders_count_check CHECK ((orders_count >= 0)),
	CONSTRAINT dm_courier_ledger_orders_total_sum_check CHECK ((orders_total_sum >= (0)::numeric)),
	CONSTRAINT dm_courier_ledger_pkey PRIMARY KEY (id),
	CONSTRAINT dm_courier_ledger_rate_avg_check CHECK (((rate_avg >= (1)::double precision) AND (rate_avg <= (5)::double precision))),
	CONSTRAINT dm_courier_ledger_settlement_month_check CHECK (((settlement_month >= 1) AND (settlement_month <= 12))),
	CONSTRAINT dm_courier_ledger_settlement_year_check CHECK (((settlement_year > 2020) AND ((settlement_year)::double precision <= date_part('year'::text, (current_timestamp + '08:00:00'::interval)))))
);

