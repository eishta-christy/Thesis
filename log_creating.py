import datetime

def write_log(directory, s):
	""" Creates a log document in a particular folder """
	try:
		log = open(directory + "log.txt", 'a', encoding = 'utf-8')
		date_now = str(datetime.datetime.now())
		log.write("[" + date_now + "]" + s + "\n")
	except:
		pass
def df_into_csv(df, file_name):
	import pandas as pd
	df.to_csv(file_name, sep='\t', encoding='utf-8')
def add_to_df(df, sub, Type, file, teil, sent_number, words_before, maxCNCstring, maxCNC):
	import pandas as pd
	df = df.append({'Subcorpus': sub, 'Type of Article': Type, 'Article': file, 'Teil': teil, 'Sentence number': sent_number, 'Words before': words_before, 'CNC String': maxCNCstring, 'CNC Length': maxCNC}, ignore_index=True)
	#print(df)
	return df

	""" Example of usage:
	import pandas as pd
	df = pd.DataFrame({'Subcorpus': [], 'Type of Article': [], 'Article': [], 'Teil': [], 'Sentence number': [], 'CNC String': [], 'CNC Length': []})
	df = add_to_df(df, "Biology", "Quant", "hfpcowa.txt", "Middle", 4, "trial access number", 3)
	df = add_to_df(df, "Economics", "Quant", "hfpcowa.txt", "Middle", 4, "trial access number", 3)
	df = add_to_df(df, "Biology", "Quant", "hfpcowa.txt", "Middle", 4, "trial access number", 3)

	print(df)

	df_into_csv(df, "df.csv") """

