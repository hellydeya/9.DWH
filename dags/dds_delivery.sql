BEGIN; 
insert into dds.deliverys (order_id, order_ts, delivery_id, courier_id, address, delivery_ts, rate, sum, tip_sum)
select 
deliveries_info::JSON->>'order_id',
(deliveries_info::JSON->>'order_ts')::timestamp,
deliveries_id,
deliveries_info::JSON->>'courier_id',
deliveries_info::JSON->>'address',
deliveries_ts,
(deliveries_info::JSON->>'rate')::numeric(14,2),
(deliveries_info::JSON->>'sum')::numeric(14,2),
(deliveries_info::JSON->>'tip_sum')::numeric(14,2)
from stg.deliveries
where deliveries_ts > (select coalesce(max(workflow_key::timestamp), '1900-01-01'::timestamp) from dds.srv_wf_settings where workflow_settings ='deliveries')
on conflict (delivery_id) do update SET
order_ts = excluded.order_ts,
courier_id = excluded.courier_id,
address = excluded.address,
delivery_ts = excluded.delivery_ts,
rate = excluded.rate,
sum = excluded.sum,
tip_sum = excluded.tip_sum;
insert into dds.srv_wf_settings (workflow_key, workflow_settings) values ((select coalesce(max(delivery_ts::timestamp), '1900-01-01'::timestamp) from dds.deliverys), 'deliveries');
COMMIT;
