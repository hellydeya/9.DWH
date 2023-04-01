drop table if exists test.test_couriers;
CREATE TABLE test.test_couriers (
	id serial4 NOT NULL,
	courier_id varchar NOT NULL,
	courier_info text NOT NULL,
	CONSTRAINT couriers_id_unique UNIQUE (courier_id),
	CONSTRAINT couriers_pkey PRIMARY KEY (id)
);

drop table if exists test.test_delivery;
CREATE TABLE test.test_delivery (
	id serial4 NOT NULL,
	delivery_id varchar NOT NULL,
	delivery_info text NOT NULL,
	delivery_ts timestamp NOT NULL,
	CONSTRAINT delivery_ts_check CHECK ((delivery_ts > '2022-01-01 00:00:00'::timestamp without time zone) AND (delivery_ts <= (CURRENT_TIMESTAMP + '08:00:00'::interval))),
	CONSTRAINT delivery_id_unique UNIQUE (delivery_id),
	CONSTRAINT delivery_pkey PRIMARY KEY (id)
);

drop table if exists test.test_restaurants;
CREATE TABLE test.test_restaurants (
	id serial4 NOT NULL,
	restaurants_id varchar NOT NULL,
	restaurants_info text NOT NULL,
	CONSTRAINT restaurants_id_unique UNIQUE (restaurants_id),
	CONSTRAINT restaurants_pkey PRIMARY KEY (id)
);

'''=================Stg Positive test========================================'''
insert into test.test_couriers (courier_id, courier_info) values 
('positive_test_1', 'testing test'),
('positive_test_2', 'testing test')

insert into test.test_restaurants (restaurants_id, restaurants_info) values
('positive_test_1', 'testing restaraunt'),
('positive_test_2', 'testing restaraunt')

insert into test.test_delivery (delivery_id, delivery_info, delivery_ts) values
('positive_test_1', '{"test1": "test", "test2": "2022-02-22 22:22:22.222"}', '2022-02-22 22:22:22.222')


'''=================Stg Negative test========================================'''
'''========================DOUBLE====================================='''
insert into test.test_couriers (courier_id, courier_info) values 
('negative_test_1', 'double'),
('negative_test_1', 'double')

insert into test.test_restaurants (restaurants_id, restaurants_info) values
('negative_test_1', 'double'),
('negative_test_1', 'double')

insert into test.test_delivery (delivery_id, delivery_info, delivery_ts) values
('negative_test_1', '{"double": "double", "double": "2022-02-22 22:22:22.222"}', '2022-02-22 22:22:22.222'),
('negative_test_1', '{"double": "double", "double": "2022-02-22 22:22:22.222"}', '2022-02-22 22:22:22.222')

'''=============================values type=============================='''
insert into test.test_delivery (delivery_id, delivery_info, delivery_ts) values
('negative_test_2', '{"double": "double", "double": "2022-02-22 22:22:22.222"}', 'negative_test_2')


'''========================Null value====================================='''
insert into test.test_couriers (courier_id) values 
('negative_test_3')
insert into test.test_couriers (courier_info) values 
('negative_test_3')

insert into test.test_restaurants (restaurants_id) values
('negative_test_3')
insert into test.test_restaurants (restaurants_info) values
('negative_test_3')

insert into test.test_delivery (delivery_id) values
('negative_test_3')
insert into test.test_delivery (delivery_info) values
('negative_test_3')
insert into test.test_delivery (delivery_ts) values
('2022-02-22 22:22:22.222')

'''=============================MAX - MIN=============================='''
insert into test.test_delivery (delivery_id, delivery_info, delivery_ts) values
('negative_test_4', '{"test1": "test", "test2": "2022-01-01 22:22:22.222"}', '2020-02-22 22:22:22.222')

insert into test.test_delivery (delivery_id, delivery_info, delivery_ts) values
('negative_test_5', '{"test1": "test", "test2": "2022-02-22 22:22:22.222"}', '2023-01-21 22:22:22.222')



drop table if exists test.test_dds_couriers;
CREATE TABLE test.test_dds_couriers (
	id serial4 NOT NULL,
	"_id" varchar NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT test_couriers_id_unique UNIQUE (_id),
	CONSTRAINT test_couriers_pkey PRIMARY KEY (id)
);
drop table if exists test.test_dds_restaurants;
CREATE TABLE test.test_dds_restaurants (
	id serial4 NOT NULL,
	"_id" varchar NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT test_restaurants_id_unique UNIQUE (_id),
	CONSTRAINT test_restaurants_pkey PRIMARY KEY (id)
);
drop table if exists test.test_dds_deliverys;
CREATE TABLE test.test_dds_deliverys (
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
	CONSTRAINT test_delivery_id_unique UNIQUE (delivery_id),
	CONSTRAINT test_deliverys_order_ts_check CHECK (((order_ts > '2022-01-01 00:00:00'::timestamp without time zone) AND (order_ts <= (CURRENT_TIMESTAMP + '08:00:00'::interval)))),
	CONSTRAINT test_deliverys_order_ts_check1 CHECK (((delivery_ts > '2022-01-01 00:00:00'::timestamp without time zone) AND (delivery_ts <= (CURRENT_TIMESTAMP + '08:00:00'::interval)))),
	CONSTRAINT test_deliverys_pkey PRIMARY KEY (id),
	CONSTRAINT test_deliverys_rate_check CHECK (((rate >= 1) AND (rate <= 5))),
	CONSTRAINT test_deliverys_sum_check CHECK ((sum > (0)::numeric)),
	CONSTRAINT test_deliverys_tip_sum_check CHECK ((tip_sum >= (0)::numeric))
);


'''=================Dds Positive test========================================'''
insert into test.test_dds_couriers ("_id", "name") values 
('positive_test_1', 'testing test')

insert into test.test_dds_restaurants ("_id", "name") values 
('positive_test_1', 'testing test')

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('positive_test_1', '2022-02-01 00:00:00', 'positive_test_1', 'positive_test_1', 'positive_test_1', '2022-02-01 00:00:00', 5, 100, 100)



'''=================Dds Negative test========================================'''
'''========================DOUBLE====================================='''
insert into test.test_dds_couriers ("_id", "name") values 
('negative_test_1', 'double'),
('negative_test_1', 'double')

insert into test.test_dds_restaurants ("_id", "name") values
('negative_test_1', 'double'),
('negative_test_1', 'double')

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values
('negative_test_1', '2022-02-01 00:00:00', 'negative_test_1', 'negative_test_1', 'negative_test_1', '2022-02-01 00:00:00', 5, 100, 100),
('negative_test_1', '2022-02-01 00:00:00', 'negative_test_1', 'negative_test_1', 'negative_test_1', '2022-02-01 00:00:00', 5, 100, 100)

'''=============================values type=============================='''
insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values
('negative_test_2', 1, 'negative_test_1', 'negative_test_1', 'negative_test_1', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values
('negative_test_2', '2022-02-01 00:00:00', 'negative_test_1', 'negative_test_1', 'negative_test_1', 1, 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values
('negative_test_2', '2022-02-01 00:00:00', 'negative_test_1', 'negative_test_1', 'negative_test_1', '2022-02-01 00:00:00', 'negative_test_2', 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values
('negative_test_2', '2022-02-01 00:00:00', 'negative_test_1', 'negative_test_1', 'negative_test_1', '2022-02-01 00:00:00', 5, 'negative_test_2', 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values
('negative_test_2', '2022-02-01 00:00:00', 'negative_test_1', 'negative_test_1', 'negative_test_1', '2022-02-01 00:00:00', 5, 100, 'negative_test_2')

'''========================Null value====================================='''
insert into test.test_dds_couriers ("_id", "name") values 
('negative_test_3', Null)

insert into test.test_dds_couriers ("_id", "name") values 
(Null, 'negative_test_3')

insert into test.test_dds_restaurants ("_id", "name") values 
(Null, 'negative_test_3')

insert into test.test_dds_restaurants ("_id", "name") values 
('negative_test_3', Null)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
(Null, '2022-02-01 00:00:00', 'negative_test_3', 'negative_test_3', 'negative_test_3', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', Null, 'negative_test_3', 'negative_test_3', 'negative_test_3', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', '2022-02-01 00:00:00', Null, 'negative_test_3', 'negative_test_3', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', '2022-02-01 00:00:00', 'negative_test_3', Null, 'negative_test_3', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', '2022-02-01 00:00:00', 'negative_test_3', 'negative_test_3', Null, '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', '2022-02-01 00:00:00', 'negative_test_3', 'negative_test_3', 'negative_test_3', Null, 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', '2022-02-01 00:00:00', 'negative_test_3', 'negative_test_3', 'negative_test_3', '2022-02-01 00:00:00', Null, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_3', '2022-02-01 00:00:00', 'negative_test_3', 'negative_test_3', 'negative_test_3', '2022-02-01 00:00:00', 5, Null, 100)


'''=============================MAX - MIN=============================='''
insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2020-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2023-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2022-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2022-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2020-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2022-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2023-02-01 00:00:00', 5, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2022-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2022-02-01 00:00:00', -1, 100, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2022-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2022-02-01 00:00:00', 5, -1, 100)

insert into test.test_dds_deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum) values 
('negative_test_4', '2022-02-01 00:00:00', 'negative_test_4', 'negative_test_4', 'negative_test_4', '2022-02-01 00:00:00', 5, 100, -1)





drop table if exists test.test_dm_courier_ledger;
CREATE TABLE test.test_dm_courier_ledger (
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
	CONSTRAINT dm_courier_ledger_courier_settlement_year_check CHECK ((settlement_year > 2022) and (settlement_year < extract(year from now()))),
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

'''=================Cdm Positive test========================================'''

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('positive_test_1', 2022, 08, 100, 100, 5, 50, 50, 20, 20)



'''=================Cdm Negative test========================================'''

'''========================Null value====================================='''

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
(Null, 2022, 08, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', Null, 08, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, Null, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, Null, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, Null, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, Null, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, Null, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, 50, Null, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, 50, 50, Null, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, 50, 50, 20, Null)



'''=============================MAX - MIN=============================='''
insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2020, 08, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2023, 08, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 00, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 13, 100, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, -1, 100, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, -1, 5, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, -1, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 6, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 6, 50, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, -1, 50, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, 50, -1, 20, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, 50, 50, -1, 20)

insert into test.test_dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum) values
('negatige_test_1', 2022, 08, 100, 100, 5, 50, 50, 20, -1)

