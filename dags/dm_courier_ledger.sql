begin;
truncate cdm.dm_courier_ledger;
with t1 as (select *, avg(rate) over (partition by courier_id, extract(year from delivery_ts), extract(month from delivery_ts)) as avg_rate, extract(year from delivery_ts) as year, extract(month from delivery_ts) as month from dds.deliverys),
t2 as (select *, case when avg_rate < 4 then greatest(sum*0.05, 100) when avg_rate < 4.5 then greatest(sum*0.07, 150) when avg_rate < 4.9 then greatest(sum*0.08, 175) else greatest(sum*0.1, 200) end courier_order from t1),
t3 as (select courier_id, year, month, count(*) orders_count, sum(sum) orders_total_sum, sum(rate) / count(*) rate_avg,
sum(sum) * 0.25 order_processing_fee, sum(courier_order) courier_order_sum, sum(tip_sum) courier_tips_sum, (sum(courier_order)+sum(tip_sum))* 0.95 courier_reward_sum   
from t2 group by (year, month, courier_id))
insert into cdm.dm_courier_ledger (courier_name, settlement_year, settlement_month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum)
select c.name, year, month, orders_count, orders_total_sum, rate_avg, order_processing_fee, courier_order_sum, courier_tips_sum, courier_reward_sum 
from t3 join dds.couriers c on c._id = t3.courier_id; 
commit;