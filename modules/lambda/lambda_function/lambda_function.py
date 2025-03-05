# modules/lambda/lambda_function/lambda_function.py

import requests
import os
import pymysql
import datetime

def lambda_handler(event, context):
    try:
        # Fetch crypto data from API
        response = requests.get("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")
        response.raise_for_status() # Raise HTTPError for bad responses (4xx or 5xx)
        data = response.json()
        bitcoin_price = data['bitcoin']['usd']

        # Connect to RDS
        connection = pymysql.connect(
            host=os.environ['DB_HOST'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            db=os.environ['DB_NAME']
        )
        cursor = connection.cursor()

        # Insert data into database
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        cursor.execute("INSERT INTO crypto_prices (price, timestamp) VALUES (%s, %s)", (bitcoin_price, timestamp))
        connection.commit()
        cursor.close()
        connection.close()

        return {
            'statusCode': 200,
            'body': 'Data inserted successfully!'
        }
    except requests.exceptions.RequestException as req_err:
        return {
            'statusCode': 500,
            'body': f'Request error: {str(req_err)}'
        }
    except pymysql.MySQLError as db_err:
        return {
            'statusCode': 500,
            'body': f'Database error: {str(db_err)}'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'An error occurred: {str(e)}'
        }