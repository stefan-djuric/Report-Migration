# Tests connection, returns DB Version
import psycopg2

# Change these environment variables
debug_logging_enabled = False
server_name = 'localhost'
database_name = 'DevFinanceSORDB'
user_id = 'finadmin'
user_pass = 'f1nadm1n'
curr_port = 8050

# Connect 
conn = psycopg2.connect(host=server_name, database=database_name, user=user_id, password=user_pass, port=curr_port)

print("Testing Connection...")

# Create a Cursor
cur = conn.cursor()

# Retrieve the db version (a simple test command)
print('PostgreSQL database version: ')
cur.execute('SELECT version()')
db_version = cur.fetchone()
print(db_version)



# Error handling for invalid report ID values
try:
	report_id = int("hi")
except ValueError as error:
	print("you messed up ")
	raise Exception(error) from None
	#logging.error("Invalid report ID provided: ")
	#logging.error(report_id)
	#logging.error(str(error) + " occurred at " + str(datetime.datetime.now().time()))
	#raise ValueError("Invalid report ID provided. ")


