# lambda_src/lambda_function.py

import requests
import pymysql
import os

def lambda_handler(event, context):
    try:
        # Connect to RDS MySQL database
        connection = pymysql.connect(
            host=os.environ['DATABASE_ADDRESS'],
            user=os.environ['DATABASE_USER'],
            password=os.environ['DATABASE_PASSWORD'],
            db=os.environ['DATABASE_NAME']
        )

        with connection.cursor() as cursor:
            # Create the table if it doesn't exist
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS prices (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    bitcoin_price DECIMAL(10, 2),
                    ethereum_price DECIMAL(10, 2),
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)

            # Fetch cryptocurrency prices (example: CoinGecko API)
            response = requests.get("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd")
            data = response.json()

            bitcoin_price = data["bitcoin"]["usd"]
            ethereum_price = data["ethereum"]["usd"]

            # Insert data into the database
            sql = "INSERT INTO prices (bitcoin_price, ethereum_price) VALUES (%s, %s)"
            cursor.execute(sql, (bitcoin_price, ethereum_price))
            connection.commit()

        connection.close()
        return {
            'statusCode': 200,
            'body': 'Data stored successfully'
        }

    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': f'Error: {e}'
        }
