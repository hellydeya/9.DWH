begin;
insert into dds.couriers (_id, name)
select couriers_id, couriers_info::JSON->>'name' from stg.couriers
on conflict(_id) do update set
name = excluded.name;
commit;