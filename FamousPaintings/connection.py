import pandas as pd
from sqlalchemy import create_engine

datasets = ["image_link","museum_hours","museum","product_size","subject","work","artist","canvas_size"]


DATABASE_TYPE = 'postgresql'
DBAPI = 'psycopg2'
ENDPOINT = 'localhost'  # Localhost
USER = 'postgres'
PASSWORD = '###'
PORT = 5432  # Default PostgreSQL port
DATABASE = 'paintings'

engine = create_engine(f'{DATABASE_TYPE}+{DBAPI}://{USER}:{PASSWORD}@{ENDPOINT}:{PORT}/{DATABASE}')


for dataset in datasets:
    df = pd.read_csv(f'./datasets/{dataset}.csv')
    df.to_sql(dataset, con=engine, if_exists='replace', index=False)
    
