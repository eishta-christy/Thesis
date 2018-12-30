# -*- coding: utf-8 -*-
"""
@author: Kristina Kolesova
"""

#sentence = 'Almost all IKEA products are designed to for ﬂat packaging, which reduces shipping costs, minimizes transport damage, increases store inventory capacity, and makes it easier for customers to take the furniture home themselves, rather than needing delivery.'
#print(tagger.tag(sentence.split())) #list of tuples
print("We start...")
t = ''

def calculate_corpus_size_in_words(rootdirectory):
	""" Calculates the size of the corpus and subcorpora in words. """
	t = ''
	import os
	import re
	from log_creating import write_log
	corpus_length = 0
	subcorpora_lenth = 0
	subcorpora_lenths = {}
	for subdir, dirs, files in os.walk(rootdirectory):
		for file in files:
			#print(subdir)
			sub = re.sub(".*/", "", subdir)
			filepath = subdir+ os.sep + file # 
			if filepath.endswith(".txt"):
				print(filepath)
				t = prepare_full_doc(filepath)
				t_length = len(t.split())
				corpus_length += t_length
				subcorpora_lenth += t_length
		subcorpora_lenths[subdir] = subcorpora_lenth
		subcorpora_lenth = 0
	write_log(rootdirectory, "Length of the corpus is " + str(corpus_length) + " words.")
	for key in subcorpora_lenths.keys():
		write_log(rootdirectory, "Length of " + key + " corpus is " + str(subcorpora_lenths[key]) + " words.")
	return corpus_length, subcorpora_lenths

def empty_the_parts_output(parts_directory):
	""" Empties the folder with txtxs with CNCs' pre-context """
	import os
	import re
	for subdir, dirs, files in os.walk(parts_directory):
		for file in files:
			filepath = subdir+ os.sep + file # 
			if filepath.endswith(".txt"):
				os.remove(filepath)

def prepare_full_doc(filepath):
	from log_creating import write_log
	import re
	""" Cleans raw pdf-to-txt documet: Prepares a text for analysis. Subs citations to (We cite this);
	subs Name et al. not at the end of a sentence with Name;
	"""
	with open(filepath, 'r', encoding = 'utf-8') as f:
		t = ""
		for line in f:
			t += line
	#try:
	#	t = re.split("Introduction", t)[1]
	#except:
	#	pass
	try:
		t = re.split("Acknowledgements", t)[0]
	except:
		pass
	try:
		t = re.split("References", t)[0]
	except:
		pass
	replacements = [#('(Corresponding|Correspondence).*?Elsevier B.V. All rights reserved.', ''),
					##('© 201\d Elsevier B.V. All rights reserved.', ''),
					('(\n){2,}', '\n'),
					('-\n', ''),
					('- \n', ''),
					('\n.{1,7}\n', ''),
				    ##('et( |\n)al\.(?=( |\n)?([^A-Z]|[,\(\"]))', 'N') #Papageorgiou et al. (1998)
				    ]
	for old, new in replacements:
		t = re.sub(old, new, t)
	t = t + " <Ending>"
	return(t)

def create_maxCNC_txt_in_parts_if_up3_and_count(df, words_for_CNCs, CNC_up_3_count, maxCNCstring, maxCNC, parts_directory, sub, file, Current_teil, sent_number, word_number, sentences):
	""" If an input CNC is of length >= 3, then a doc in parts folder is created with all the text before this CNC in it """
	import re
	import pandas as pd
	from log_creating import write_log, add_to_df
	if maxCNC>=3:
		CNC_up_3_count += 1
		words_for_CNCs += maxCNC
		#print("CNC_up_3_count = ", CNC_up_3_count)
		maxCNCstring = re.sub("[,\(\):;]", "", maxCNCstring)
		maxCNCstring = maxCNCstring.strip()
		#print("new CNC: ", maxCNCstring)
		write_log(parts_directory, maxCNCstring + " in sent: " + str(sent_number) + " with maxCNC: " + str(maxCNC))
		try:
			with open(parts_directory + sub + file[0:len(file)-4] + "_" + str(sent_number) + "_" + maxCNCstring + ".txt", 'w', encoding='utf-8') as sent_f:
				for s in sentences[0:sent_number+1]:
					sent_f.write(s + ". ")
		except:
			write_log(parts_directory, "cannot create file" + parts_directory + sub + file[0:len(file)-4] + "_" + str(sent_number) + "_" + maxCNCstring + ".txt")
		#print(df, sub, "Quant/Qual", file, "Intro/Middle/Conclusion", sent_number, maxCNCstring, maxCNC)
		df = add_to_df(df, sub, "Quant/Qual", file, Current_teil, sent_number, word_number-maxCNC, maxCNCstring, maxCNC)

		## nice output
		##with pd.option_context('display.max_rows', None, 'display.max_columns', None):
		##	print(df)
	return CNC_up_3_count, words_for_CNCs, df

def	get_CNCs_up_3_of_a_txt_file(df2, df, filepath, file, sub, parts_directory): 
	""" Gets all CNCs of one text and creates files in parts folder for them """
	#print("get_CNCs_up_3_of_a_txt_file",df)
	import os
	import pandas as pd
	from nltk.tag.stanford import StanfordPOSTagger
	path_to_model = "C:/Users/kole021/Downloads/stanford-postagger-full-2017-06-09/models/english-bidirectional-distsim.tagger"
	path_to_jar = "C:/Users/kole021/Downloads/stanford-postagger-full-2017-06-09/stanford-postagger.jar"
	tagger=StanfordPOSTagger(path_to_model, path_to_jar)
	java_path = "C:\\Program Files\\Java\\jdk1.8.0_181\\bin\\java.exe"
	os.environ['JAVAHOME'] = java_path
	tagger.java_options='-mx4096m'
	from log_creating import write_log
	import re
	words_for_CNCs = 0
	word_count = 0
	CNC_up_3_count = 0
	noun_count = 0
	if (filepath.endswith(".txt"))&(file.startswith("log.txt")==False)&(file.startswith("README.txt")==False):
		word_count = 0
		noun_count = 0
		Teil1  = "<Intro>"
		Teil2 = "<Middle>"
		Teil3 = "<Conclusion>"
		Ende  = "<Ending>"
		Teile2 = {Teil1: [0, 0], Teil2: [0, 0], Teil3: [0, 0]} 
		CNC_up_3_count = 0
		words_for_CNCs = 0
		print(sub)
		print (filepath)
		print(file)
		write_log(parts_directory, "Processing " + file + " in " + sub)
		t = prepare_full_doc(filepath)
		sentences = re.split("\.|\?|:|;", t)
		last_first_word = ""
		sent_number = 0
		word_number = 0

		Teile = {Teil1: [0, 0, 0, 0], Teil2: [0, 0, 0, 0], Teil3: [0, 0, 0, 0]} #0 = word count; 1 = CNC p 3 count; 2  = how many words contain CNCs; 3=what part of all words that are in CNCs are the CNCs in this particular part
		Current_teil = Teil1
		for sent in sentences:
			p = []
			sent = re.sub('\n', ' ',sent ) ###add more deleting enters
			sent_number += 1
			try:
				p = tagger.tag(re.split(" ", sent)) #list of tuples for every sentence
			except:
				write_log(parts_directory, "failed to tag the sentence: " + sent)
			maxCNC = 0
			maxCNCstring = ""
			other_word = False
			for word in p:
				#print(word)
				word_number += 1
				#print(word_number)
				word_count += 1
				##print("word_count = ", word_count)
				if ((len(word[0])>2) & (re.search("[\d@+]", word[0])==None) & (re.search("\(.\)",word[0])==None))&(  (word[1] == 'NN')|(word[1] == 'NNS')|( ((word[1] == 'JJ')|(word[1] == 'JJR')|(word[1] == 'JJS'))&(maxCNC == 0) )  ):
					word_word = word[0]
					if ((len(word[0])>2) & (re.search("[\d@+]", word[0])==None) & (re.search("\(.\)",word[0])==None))&(  (word[1] == 'NN')|(word[1] == 'NNS')  ):
							noun_count += 1 
					#print(word)
					if re.search("/", word_word)==None:
						word_word = re.split("/",word_word)[0]
					if other_word == True:
						if last_first_word != "":
							maxCNCstring = last_first_word + word_word
							last_first_word = ""
							maxCNC = 2
							other_word = False
						else:							
							other_word = False
							CNC_up_3_count, words_for_CNCs, df = create_maxCNC_txt_in_parts_if_up3_and_count(df, words_for_CNCs, CNC_up_3_count, maxCNCstring, maxCNC, parts_directory, sub, file, Current_teil, sent_number, word_number, sentences)
							maxCNC = 1
							maxCNCstring = word_word
					else:
						if ((word_word[len(word_word)-1]==")")|(word_word[len(word_word)-1]=="’")|(word_word[len(word_word)-1]=="’")|(word_word[len(word_word)-1]==",")|(word_word[len(word_word)-1]==";")|(word_word[len(word_word)-1]=="'")|(word_word[len(word_word)-1]=="'")|(word_word[len(word_word)-1]==":")):
							other_word  = True
						else:
							try:
								if re.search("[:\"\(\[]", word_word[0])!=None:
									last_first_word = word_word
									other_word = True
								else:
									maxCNC += 1
									maxCNCstring += " " + word_word
							except:
								write_log(parts_directory, "Fail to process ( in word_word: " + word_word)
					##if ((word_word[len(word_word)-2]==")")|(word_word[len(word_word)-2]=="’")|(word_word[len(word_word)-2]=="’")|(word_word[len(word_word)-2]==",")|(word_word[len(word_word)-2]==";")|(word_word[len(word_word)-2]=="'")|(word_word[len(word_word)-2]=="'")|(word_word[len(word_word)-2]==":")):
					##	other_word  = True
				else:
					other_word  = True
				if word[0] == Teil2:
					write_log(parts_directory, "End of Introduction")
					print("Teil 1", word_count, CNC_up_3_count, words_for_CNCs)
					Teile[Teil1][0] = word_count
					Teile[Teil1][1] = CNC_up_3_count
					Teile[Teil1][2] = words_for_CNCs

					Teile2[Teil1][0] = word_count
					Teile2[Teil1][1] = noun_count
					word_count = 0
					noun_count = 0

					CNC_up_3_count = 0
					words_for_CNCs = 0
					Current_teil = Teil2
				elif word[0] == Teil3:
					write_log(parts_directory, "End of Middle")
					print("Teil 2", word_count, CNC_up_3_count, words_for_CNCs)
					Teile[Teil2][0] = word_count
					Teile[Teil2][1] = CNC_up_3_count
					Teile[Teil2][2] = words_for_CNCs

					Teile2[Teil2][0] = word_count
					Teile2[Teil2][1] = noun_count
					noun_count = 0
					word_count = 0

					CNC_up_3_count = 0
					words_for_CNCs = 0
					Current_teil = Teil3
				#elif word[0] == Ende:
		print(word[0], " THIS IS WORD 0 BY ENDE")
		print("Teil 3", word_count, CNC_up_3_count, words_for_CNCs)
		write_log(parts_directory, "End of Conclusion")
		Teile[Teil3][0] = word_count
		Teile[Teil3][1] = CNC_up_3_count
		Teile[Teil3][2] = words_for_CNCs

		Teile2[Teil3][0] = word_count
		Teile2[Teil3][1] = noun_count
		word_count = 0
		noun_count = 0
		df2 = df2.append({'Subcorpus': sub, 'Type of Article': "", 'Article': file, 'Teil': "<Intro>", 'WordsN': Teile2[Teil1][0], 'NounsN': Teile2[Teil1][1]}, ignore_index=True)
		df2 = df2.append({'Subcorpus': sub, 'Type of Article': "", 'Article': file, 'Teil': "<Middle>", 'WordsN': Teile2[Teil2][0], 'NounsN': Teile2[Teil2][1]}, ignore_index=True)
		df2 = df2.append({'Subcorpus': sub, 'Type of Article': "", 'Article': file, 'Teil': "<Conclusion>", 'WordsN': Teile2[Teil3][0], 'NounsN': Teile2[Teil3][1]}, ignore_index=True)
		print("new line in df2:", df2)

		CNC_up_3_count = 0
		words_for_CNCs = 0
		sum_CNCs = 0
		sum_total = 0
		for teil in Teile.keys():
			print("teil in Keys()", teil)
			write_log(parts_directory, "words in the " + teil + str(Teile[teil][0]))
			write_log(parts_directory, "CNCs up 3 in the " + teil + str(Teile[teil][1]))
			write_log(parts_directory, "words that contains CNCs(N>=3) in " + teil + str(Teile[teil][2]))
			sum_CNCs += Teile[teil][2]
			sum_total += Teile[teil][0]
		full_ratio = sum_CNCs/sum_total
		for teil in Teile.keys():
			try:
				Teile[teil][3] = Teile[teil][2]/Teile[teil][0]
			except ZeroDivisionError:
				Teile[teil][3]  = 0 
			write_log(parts_directory, "words that contains CNCs(N>=3) in " + teil + " are " + str(Teile[teil][3]) + " \% of this teil")
		write_log(parts_directory, "In this document CNCs >=3 are " + str(full_ratio) + "\% of the text.")
	return df

def get_CNCs_up_3_of_a_corpus(rootdirectory, parts_directory):
	import pandas as pd
	import re
	import os
	from log_creating import write_log, df_into_csv
	""" This function lets you find all CNC of length 3 and longer 
	and its sentences number. It goes through every txt in the directory. """
	df2 = pd.DataFrame({'Subcorpus': [], 'Type of Article': [], 'Article': [], 'Teil': [], 'WordsN': [], 'NounsN': []})
	print("df2 is created")
	df = pd.DataFrame({'Subcorpus': [], 'Type of Article': [], 'Article': [], 'Teil': [], 'Sentence number': [], 'CNC String': [], 'CNC Length': []})
	print("df is created", df)
	t = ''
	for subdir, dirs, files in os.walk(rootdirectory):
		for file in files:
			#print(subdir)
			sub = re.sub(".*/", "", subdir)
			filepath = subdir + os.sep + file #
			df = get_CNCs_up_3_of_a_txt_file(df2, df, filepath, file, sub, parts_directory)
	df_into_csv(df, "linguistics_df1.csv")
	df_into_csv(df2, "linguistics_df2.csv")

#########TODO:
## 4. Empty the parts output Verbessern
## 6. add Type of article