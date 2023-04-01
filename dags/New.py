import pandas as pd
import requests
import datetime
from typing import List
from datetime import datetime, timedelta
from airflow import DAG
from airflow.decorators import dag, task
from airflow.operators.python_operator import PythonOperator, BranchPythonOperator
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.dummy_operator import DummyOperator
from airflow.models.variable import Variable
from urllib.parse import quote_plus as quote
from pymongo.mongo_client import MongoClient
import json 
import bson.objectid
import sys
import logging
import pendulum
import pandas as pd
import numpy as np
from typing import List
from urllib.parse import quote_plus as quote

our_sourse = 'PG_WAREHOUSE_CONNECTION'
headers = json.loads(Variable.get('headers'))
 
logger = logging.getLogger(__name__)

def get_values(x):
    if isinstance(x, pd.core.frame.DataFrame):
        return list(map(tuple, x.values))
    elif isinstance(x, datetime):
        return x.isoformat()
    elif isinstance(x, bson.objectid.ObjectId):
        return str(x)
    else:
        return x

def get_from_source():
    connection_our = PostgresHook(our_sourse).get_conn()
    cursor = connection_our.cursor()
    for url in Variable.get("BASE_URL").split(','):
        logging.info(f'BASE URL: {url}')
        i = 0
        params = {'sort_direction': 'asc', 'limit': '50', 'offset': i}
        if 'deliveries' in url:
            last_value = pd.read_sql("""select coalesce(max(workflow_key::timestamp), '1900-01-01'::timestamp) from stg.srv_wf_settings where workflow_settings='deliveries'""", connection_our).iloc[0, 0].replace(microsecond=0)
            params.update({'sort_field': 'delivery_ts', 'from': last_value})
        else:
            params.update({'sort_field': '_id'})
        response = requests.get(url, params=params, headers=headers)
        logging.info(f'Formated urk: {response.url}')
        tn = response.headers['x-serverless-gateway-path'].strip('/')
        logging.info(f'Source path name: {tn}')
        values = []
        while len(response.json()):
            for vl in response.json():
                logging.info(f'JSON string: {vl}')
                values.clear()
                if tn in ['couriers', 'restaurants']:
                    values.extend((vl['_id'], json.dumps({k: v for k, v in vl.items() if k not in ['_id']}, default=get_values)))
                    sql = "insert into stg.{name} ({name}_id, {name}_info) values ('{}', '{}')"                                 
                else:
                    values.extend((vl['delivery_id'], vl['delivery_ts'], json.dumps({k: v for k, v in vl.items() if k not in ['delivery_id', 'delivery_ts']}, default=get_values)))
                    sql = "insert into stg.{name} ({name}_id, {name}_ts, {name}_info) values ('{}', '{}', '{}')"
                cursor.execute(f'{sql} on conflict ({{name}}_id) do update set {{name}}_info = excluded.{{name}}_info'.format(name = tn, *values))
                connection_our.commit()
            i += 50
            params.update({'offset': i}) 
            response = requests.get(url, params=params, headers=headers)
        if tn == 'deliveries' and values:
            cursor.execute("""insert into stg.srv_wf_settings (workflow_key, workflow_settings) values ((select coalesce(max(deliveries_ts::timestamp), '1900-01-01'::timestamp) from stg.deliveries), 'deliveries')""")
        elif tn == 'deliveries' and not values:
            logging.info(f'New values in {tn} not found')
        connection_our.commit()
    connection_our.close()

with DAG(
        'new',
        schedule_interval=None,
        start_date=pendulum.datetime(2022, 5, 5, tz="UTC"),
        catchup=False,
        tags=['sprint5'],
        is_paused_upon_creation=False) as dag:

    get_from_source = PythonOperator(
        task_id='get_from_source',
        python_callable=get_from_source)

    dds_restaurants = PostgresOperator(
        task_id='dds_restaurants',
        postgres_conn_id=our_sourse,
        sql="dds_restaurants.sql") 

    dds_couriers = PostgresOperator(
        task_id='dds_couriers',
        postgres_conn_id=our_sourse,
        sql="dds_couriers.sql") 

    dds_delivery = PostgresOperator(
        task_id='dds_delivery',
        postgres_conn_id=our_sourse,
        sql="dds_delivery.sql") 


    dm_courier_ledger = PostgresOperator(
        task_id='dm_courier_ledger',
        postgres_conn_id=our_sourse,
        sql="dm_courier_ledger.sql") 



get_from_source >> dds_restaurants >> dds_couriers >> dds_delivery >>  dm_courier_ledger