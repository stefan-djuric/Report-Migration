# DBToFile by Stefan Djuric
# Nov. 1 2018 - Nov. 12 2018
# Queries a PostgreSQL database and creates output files from the results.

# Start with our imports
import logging
import sys
import datetime
import psycopg2

# Assign the paths to our files: (assuming root is where the .py file is)
path_to_log="logs/DBToFileLog.txt"
path_to_env="env/Variables.txt"
path_to_output="Output/"
path_to_backup="Backup/"

# Configure our logging and start it
logging.basicConfig(level=logging.DEBUG, filename=path_to_log, filemode='a', format='%(name)s[%(asctime)s]: %(filename)s - %(levelname)s: %(message)s')
logging.info("Process started at " + str(datetime.datetime.now().time()))

# Set default values for environment variables
debug_logging_enabled = False
server_name = 'localhost'
database_name = 'DevFinanceSORDB'
user_id = 'finadmin'
user_pass = 'f1nadm1n'
curr_port = 8050

# Set changed values from variable file, if any. 
variable_file = open(path_to_env, "r")
try:
	# Read the file (split so that no newlines are kept)
	file_lines = variable_file.read().split('\n')
	# Set our variables
	debug_logging_enabled = file_lines[1]
	server_name = file_lines[3]
	database_name = file_lines[5]
	user_id = file_lines[7]
	user_pass = file_lines[9]
	curr_port = file_lines[11]
	print("Environment variables set! ")
	logging.info("Environment variables set: ")
	logging.info(debug_logging_enabled)
	logging.info(server_name)
	logging.info(database_name)
	logging.info(user_id)
	logging.info(user_pass)
	logging.info(curr_port)
	logging.info("At " + str(datetime.datetime.now().time()))

# Error handling 
except Exception:
	print("Unable to set all environment variables!")
	print(sys.exc_info()[0])	
	logging.info("Unable to set environment variables at " + str(datetime.datetime.now().time()))
	logging.info(str(sys.exc_info()[0]))
	raise 

# (Optional) Check the Version 
#print('PostgreSQL database version:')
#ver_cur = conn.cursor()
#ver_cur.execute('SELECT version()')
#db_version = ver_cur.fetchone()
#print(db_version)

# GenericOutput_n name, in case of no valid output file names.
generic_n = 0

# Configure our connection - Assign this to a variable to make it easier to change
conn_string = "host=" + str(server_name) + " dbname=" + str(database_name) + " user=" + str(user_id) + " password=" + str(user_pass) + " port=" + str(curr_port)
conn = psycopg2.connect(conn_string)
#conn = psycopg2.connect(host="localhost", database="DevFinanceSORDB", user="finadmin", password="f1nadm1n", port=8050)
#conn = psycopg2.connect("host=localhost dbname=DevFinanceSORDB user=finadmin password=f1nadm1n port=8050")

# Create a cursor for SELECT statement execution
cur = conn.cursor()

# Create a second cursor
table_cur = conn.cursor()

# Retrieve the current day, week, and month period. For now, we only use CUR_DAY
sql_param = "SELECT param_id, param_class, param_name, param_value FROM report.tbl_gen_params"
var_cur = conn.cursor()
var_cur.execute(sql_param)
param_vars = var_cur.fetchall()
cur_day = param_vars[0][3]
cur_week = param_vars[1][3]
cur_mon = param_vars[2][3]


# A function for retrieving output:
def postgresql_output(report_id):

	# Let's keep track of the records we've iterated through.
	num_records_attempted = 0
	num_records_succesful = 0
	num_records_failed = 0

	# Assign a default value command (that should still work)
	sql_function = "SELECT version()"

	# Assign a default output_file, if none is provided:
	output_file_name = "GenericOutput"
	
	# Error handling for invalid report ID values
	try:
		report_id = int(report_id)
	except:
		logging.error("Invalid report ID provided: " + str(report_id) + " at " + str(datetime.datetime.now().time()))
		raise ValueError("Invalid Report ID provided. Report IDs should be integers. ") from None
	report_id = str(report_id)	
	
	# Now execute our statement
	try:
		# Select the columns we're working with - NOTE: Will have have an output_file param added after.
		sql_param = "SELECT report_id, function_name, file_name, file_ext, has_date, total_param, param_1, param_2, param_3, param_4 FROM report.tbl_report_param WHERE report_id = " + report_id
		cur.execute(sql_param)
	# Check if our report_id gives us an invalid result.
	except psycopg2.Error as error:
		logging.error("Invalid report ID provided: " + str(report_id) + " at " + str(datetime.datetime.now().time()))
		logging.error(error + " at " + str(datetime.datetime.now().time()))
		raise("Invalid report ID provided: " + report_id)

	try:
		# Take the row that matches our row id
		row = cur.fetchone()
		
		# If we have no results, raise an error.
		if (row) is None:
			logging.error("No results for report id: " + str(report_id))
			# If we want to continue on error, print instead of raising like so:
			#print("No results for report id: " + str(report_id))
			raise InvalidReportId("No results for report id: " + str(report_id))
		
		# If we have multiple results, raise an error.
		if type(row) is not tuple:
			logging.error("Expected only one result, received: " + str(cur.rowcount))
			#print("Expected only one result, received: " + str(cur.rowcount))
			raise InvalidReportId("Expected only one result, received: " + str(cur.rowcount))
		
		# Assign to variable. More efficient - even with the extra variable assignment, this skips repeated string conversions.
		sql_fun_name = str(row[1])
		sql_fun_file_name = str(row[2])
		sql_fun_file_ext = str(row[3])
		sql_fun_has_date = str(row[4])
		sql_fun_param_count = str(row[5])
		sql_fun_param_1 = str(row[6]) 
		sql_fun_param_2 = str(row[7])
		sql_fun_param_3 = str(row[8])
		sql_fun_param_4 = str(row[9])
		
		# Set the sql function based on the number of parameters
		if sql_fun_param_count == '0':
			sql_function = "SELECT " + sql_fun_name + "()"
		elif sql_fun_param_count == '1':
			sql_function = "SELECT " + sql_fun_name + "('" + sql_fun_param_1 + "')"
		elif sql_fun_param_count == '2':
			sql_function = "SELECT " + sql_fun_name + "('" + sql_fun_param_1 + "', '" + sql_fun_param_2 + "')"
		elif sql_fun_param_count == '3':
			sql_function = "SELECT " + sql_fun_name + "('" + sql_fun_param_1 + "', '" + sql_fun_param_2 + "', '" + sql_fun_param_3 + "')"
		elif sql_fun_param_count == '4':
			sql_function = "SELECT " + sql_fun_name + "('" + sql_fun_param_1 + "', '" + sql_fun_param_2 + "', '" + sql_fun_param_3 + "', '" + sql_fun_param_4 + "')"
		else:
			print("Invalid number of parameters: " + sql_fun_param_count)
			logging.error("Invalid number of parameters: " + sql_fun_param_count + " at " + str(datetime.datetime.now().time()))
			
		# Determine which file we are writing to: 
		output_file_name = determine_output_file(sql_fun_file_name, sql_fun_file_ext, sql_fun_has_date)
		output_file = open(path_to_output + output_file_name, "w")
		#backup_file = open(path_to_output + output_file_name, "a")
		
		# Execute the given row 
		print("Executing: " + str(sql_function))
		logging.info("Given: " + str(row))
		logging.info("Executing: " + str(sql_function))
		table_cur.execute(sql_function)
		fin_row = table_cur.fetchone()
		#print(str(fin_row))

		# Write every line we receive to an output file
		while fin_row is not None:
			num_records_attempted += 1
			try:								
				# Write each row to file
				output_file.write(''.join(fin_row) + "\n")
				#backup_file.write(''.join(fin_row) + "\n")
				logging.info("Added " + ''.join(fin_row) + " \n")
				# Iterate to the next row
				fin_row = table_cur.fetchone()
				num_records_succesful += 1
			except (Exception, psycopg2.OperationalError) as error:
				logging.error(str(error) + " occurred at " + str(datetime.datetime.now().time()))
				print(error)
				#raise(error)
				num_records_failed += 1
			
		# Iterate to the next row
		row = cur.fetchone()
		
		# Log the number of records and their success state
		logging.info("Writing completed at " + str(datetime.datetime.now().time()))
		logging.info("Number of records attempted: " + str(num_records_attempted))
		logging.info("Number of successful records: " + str(num_records_succesful))
		logging.info("Number of failed records: " + str(num_records_failed))
		print("Number of records attempted: " + str(num_records_attempted))
		print("Number of successful records: " + str(num_records_succesful))
		print("Number of failed records: " + str(num_records_failed))
		
		# Close our files
		logging.info("Finished. Process closing at " + str(datetime.datetime.now().time()))
		output_file.close()
		#backup_file.close()
		
	except (Exception, psycopg2.DatabaseError) as error:
		print(error)
		logging.error(str(error) + " occurred at " + str(datetime.datetime.now().time()))
		raise
	
def close_all():
	cur.close()
	table_cur.close()
	if conn is not None:
		conn.close()

# Determines the corresponding output file for a given input.
def determine_output_file(file_name, file_ext, dated):
	# If dated, then we're adding a YYYYMMDD
	if dated:
		return (file_name + cur_day + file_ext)
	elif not dated:
		return (file_name + file_ext)
	else:
		print("Unable to find correct file for output, using GenericOutput.txt instead.")
		logging.error("Unable to find correct file for output, using GenericOutput_n.txt instead. Error occurred at " + str(datetime.datetime.now().time()))
		return ("GenericOutput_" + generic_n + ".txt")
		generic_n += 1

# List of possible Errors.
class InvalidReportId(Exception): 
	pass

# We run our main function repeatedly for multiple parameters. 
if __name__ == '__main__':
	arg_list = sys.argv[1:]
	if len(sys.argv) < 2:
		print("Add 1 or more report ids as parameters! ")
	elif len(arg_list) > 1:
		for i in range(len(arg_list)): 
			postgresql_output(arg_list[i])
	else:
		postgresql_output(sys.argv[1])
	close_all()


