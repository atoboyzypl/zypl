import pandas as pd
from sqlalchemy import create_engine

def get_dataframe(user, password, host, port, database, query):
    # Создание URL для подключения
    url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    
    # Создание двигателя для подключения
    engine = create_engine(url)
    
    # Выполнение запроса и получение данных в виде датафрейма
    with engine.connect() as connection:
        df = pd.read_sql_query(query, connection)
    
    # Закрытие подключения
    engine.dispose()
    
    return df

# Пример использования функции
if __name__ == "__main__":
    user = "postgres"
    password = "123456789"
    host = "localhost"
    port = "5432"
    database = "postgres"
    query = "SELECT * FROM your_table"

    df = get_dataframe(user, password, host, port, database, query)
    print(df)
