begin;
insert into dds.restaurants (_id, name)
select restaurants_id, restaurants_info::JSON->>'name' from stg.restaurants
on conflict (_id) do update set
name = excluded.name;
commit;