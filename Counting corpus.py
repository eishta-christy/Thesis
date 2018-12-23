# -*- coding: utf-8 -*-
"""
@author: Kristina Kolesova
"""
##calculate_corpus_size_in_words(rootdirectory)
#function calculate nouns per part per article
#function calculate percentage of nouns per part per article and total for article
#function calculate nouns in CNCs per part per article
#function calculate percentage of all nouns in CNCs
def calculate_nouns_per_doc_per_part(rootdirectory, df_file_from_pos):
	from pos import prepare_full_doc
	import pandas as pd
	import re
	import os
	from log_creating import df_into_csv
	from nltk.tag.stanford import StanfordPOSTagger
	""" This function lets you calculate number of words per part per article per corpus;
	calculate nouns per part per article per corpus """
	df = pd.DataFrame({'Subcorpus': [], 'Type of Article': [], 'Article': [], 'Teil': [], 'WordsN': [], 'NounsN': []})
	print("df is created", df)
	t = ''
	Teil1  = "<Intro>"
	Teil2 = "<Middle>"
	Teil3 = "<Conclusion>"
	path_to_model = "C:/Users/kole021/Downloads/stanford-postagger-full-2017-06-09/models/english-bidirectional-distsim.tagger"
	path_to_jar = "C:/Users/kole021/Downloads/stanford-postagger-full-2017-06-09/stanford-postagger.jar"
	tagger=StanfordPOSTagger(path_to_model, path_to_jar)
	java_path = "C:\\Program Files\\Java\\jdk1.8.0_181\\bin\\java.exe"
	os.environ['JAVAHOME'] = java_path
	tagger.java_options='-mx4096m'
	for subdir, dirs, files in os.walk(rootdirectory):
		for file in files:
			#print(subdir)
			sub = re.sub(".*/", "", subdir)
			filepath = subdir + os.sep + file #
			
			if (filepath.endswith(".txt"))&(file.startswith("log.txt")==False)&(file.startswith("README.txt")==False):
				word_count = 0
				CNC_up_3_count = 0
				words_for_CNCs = 0
				print(sub)
				print(filepath)
				print(file)
				print("Processing " + file + " in " + sub)
				t = prepare_full_doc(filepath)
				sentences = re.split("\.|\?|:|;", t)
				last_first_word = ""
				noun_count = 0
				word_number = 0
				Teile = {Teil1: [0, 0], Teil2: [0, 0], Teil3: [0, 0]} #0 = words number; 1 = nouns number;
				Current_teil = Teil1
				for sent in sentences:
					p = []
					sent = re.sub('\n', ' ',sent ) ###add more deleting enters
					try:
						p = tagger.tag(re.split(" ", sent)) #list of tuples for every sentence
					except:
						print("failed to tag the sentence: " + sent)
					for word in p:
						word_number += 1
						if ((len(word[0])>2) & (re.search("[\d@+]", word[0])==None) & (re.search("\(.\)",word[0])==None))&(  (word[1] == 'NN')|(word[1] == 'NNS')  ):
							noun_count += 1
						if word[0] == Teil2:
							print("End of Introduction")
							print("Teil 1", word_number, noun_count)
							Teile[Teil1][0] = word_number
							Teile[Teil1][1] = noun_count
							word_number = 0
							noun_count = 0
							Current_teil = Teil2
						elif word[0] == Teil3:
							print("End of Middle")
							print("Teil 2", word_number, noun_count)
							Teile[Teil2][0] = word_number
							Teile[Teil2][1] = noun_count
							word_number = 0
							noun_count = 0
							Current_teil = Teil3
				print("Teil 3", word_number, noun_count)
				print("End of Conclusion")
				Teile[Teil3][0] = word_number
				Teile[Teil3][1] = noun_count
				word_number = 0
				noun_count = 0
				df = df.append({'Subcorpus': sub, 'Type of Article': "", 'Article': file, 'Teil': "<Intro>", 'WordsN': Teile[Teil1][0], 'NounsN': Teile[Teil1][1]}, ignore_index=True)
				df = df.append({'Subcorpus': sub, 'Type of Article': "", 'Article': file, 'Teil': "<Middle>", 'WordsN': Teile[Teil2][0], 'NounsN': Teile[Teil2][1]}, ignore_index=True)
				df = df.append({'Subcorpus': sub, 'Type of Article': "", 'Article': file, 'Teil': "<Conclusion>", 'WordsN': Teile[Teil3][0], 'NounsN': Teile[Teil3][1]}, ignore_index=True)
				print(df)
	##for_changes = pd.read_csv(df_file_from_pos, sep = '\t', header = 0)
	##table = pd.pivot_table(for_changes, index = ['Article', 'Teil'], values = 'CNC Length', aggfunc = np.sum)
	##print(type(table))

	df_into_csv(df, "df_nouns_and_all_words_counts_whole_corpus_part_2.csv")

calculate_nouns_per_doc_per_part("C:/Users/kole021/git/CNC/intros/", "C:/Users/kole021/git/CNC/biology_parts/df_biology nicht kaputt - Kopie.tsv")