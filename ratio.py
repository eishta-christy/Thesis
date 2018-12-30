# -*- encoding: utf-8 -*-
"""
@author: Kristina Kolesova
"""
import io
import sys

name1 = "biology_intros"
name2 = "economics_intros"
name3 = "physics_intros"
def count_ratios(filepath):
	""" takes the output after all CNCs in one folder of articles 
		were found and count how many of what size are there and 
		proportions of CNC in every part of Intro,Middle,Conclusion words."""
	import re
	goto: parts_folder
	sum_intro = 0
	sum_middle = 0
	sum_conclusion  = 0
	sum_total = 0
	mean_intro = 0
	mean_middle = 0
	mean_conclusion = 0
	mean_total = 0
	count_intro = 0
	count_middle = 0
	count_conclusion = 0
	count_total = 0

	doc_count = 0
	doc_list = []
	maxKey = 0

	part_count = 1
	#with open(filepath, 'r', encoding = 'utf-8') as f:
	
	with io.open(filepath, 'rt', encoding='latin1') as f: #und das ist komisch:(
		try:
			for line in f:
				#print(line)
				if re.search("words that contains CNCs\(N>=3\) in \<Intro\> are ", line)!=None:
					m = re.search('(?<=words that contains CNCs\(N\>=3\) in \<Intro\> are )\d(.\d\d\d)?', line)
					sum_intro += float(m.group(0))
					count_intro += 1
				elif re.search("words that contains CNCs\(N>=3\) in \<Middle\> are ", line)!=None:
					m = re.search('(?<=words that contains CNCs\(N\>=3\) in \<Middle\> are )\d.(\d\d\d)?', line)
					sum_middle += float(m.group(0))
					count_middle += 1
				elif re.search("words that contains CNCs\(N>=3\) in \<Conclusion\> are ", line)!=None:
					m = re.search('(?<=words that contains CNCs\(N\>=3\) in \<Conclusion\> are )\d.(\d\d\d)?', line)
					sum_conclusion += float(m.group(0))
					count_conclusion += 1
				elif re.search("In this document CNCs \>=3 are ", line)!=None:
					m = re.search('(?<=In this document CNCs \>=3 are )\d.(\d\d\d)?', line)
					sum_total += float(m.group(0))
					count_total += 1
				#create list of dictionaries for texts
				if re.search("\]Processing ", line)!=None:
					doc_count += 1
					#version 1.0
					#doc_list.append({})
					#\version 1.0

					#version 2.0
					doc_list.append([{},{},{}])
					#\version 2

				# version 2.0 additional part for version 2.0
				if re.search("End of Introduction", line)!=None:
					part_count += 1
				elif re.search("End of Middle", line)!=None:
					part_count += 1
				elif re.search("End of Conclusion", line)!=None:
					part_count = 1
				#\version 2.0


				#schotajem skol'ko CNCs raznoj dliny v kazhdom tekste i save v doc_list
				if re.search("with maxCNC: ", line)!=None:
					m = re.search('(?<=with maxCNC: )\d(\d)?', line)
					CNC_length = int(m.group(0))

					#version 1.0
					#if CNC_length not in doc_list[doc_count - 1].keys():
					#	doc_list[doc_count-1][CNC_length] = 1
					#else:
					#	doc_list[doc_count-1][CNC_length] += 
					#\version 1.0

					#version 2
					if CNC_length not in doc_list[doc_count - 1][part_count - 1].keys():
						doc_list[doc_count - 1][part_count - 1][CNC_length] = 1
					else:
						doc_list[doc_count - 1][part_count - 1][CNC_length] += 1
					#\version 2
				
		except UnicodeDecodeError:
			print("UnicodeDecodeError")
	print("Distribution of CNCs of different lengths for every article: ", doc_list) #version 2: [[{3: 5}, {3: 18, 4: 2}, {3: 9, 4: 2, 5: 1}], [{},{},{}], [{},{},{}],.....]
	#vesrion 1.0
	#maxKey = max(doc_list[0].keys())
	#\version 1.0

	#version 2.0
	maxKey = max(doc_list[0][0].keys())
	#\version 2.0

	#version 1.0
	#for doc in doc_list:
	#	if max(doc.keys()) > maxKey:
	#		maxKey = max(doc.keys())
	#\version 1.0

	#version 2.0
	for doc in doc_list:
		for partN in range(len(doc)):
			try:
				if max(doc[partN].keys()) > maxKey:
					maxKey = max(doc[partN].keys())
			except ValueError:
				pass
	#\version 2.0

	print(maxKey)

	#version 1.0
	#keys_total = {}
	#for i in range(3, maxKey+1):
	#	keys_total[i] = 0
	#\version 1.0

	#version 2.0
	keys_total = [{},{},{}]
	for teilN in range(len(keys_total)):
		for i in range(3, maxKey+1):
			keys_total[teilN][i] = 0
	#\version 2.0

	#version 1.0
	#for doc in doc_list:
	#	for key in doc.keys():
	#		keys_total[key] += doc[key]
	#\version 1.0

	#version 2.0
	for doc in doc_list:
		for teilN in range(len(doc)):
			for key in doc[teilN].keys():
				keys_total[teilN][key] += doc[teilN][key]
	#\version 2.0:  


	print("Distribution od CNCs of different lengths: ", keys_total) 
	
	try:
		mean_intro = sum_intro/count_intro
	except ZeroDivisionError:
		mean_intro = 0 
	try:
		mean_middle = sum_middle/count_middle
	except ZeroDivisionError:
		mean_middle = 0 
	try:
		mean_conclusion = sum_conclusion/count_conclusion
	except ZeroDivisionError:
		mean_conclusion = 0
	try:
		mean_total = sum_total/count_total
	except ZeroDivisionError:
		mean_total = 0 
	return mean_intro, mean_middle, mean_conclusion, mean_total
print("We start with biology articles")
mean_intro, mean_middle, mean_conclusion, mean_total = count_ratios("C:/Users/kole021/git/CNC/parts/biology_parts/log.txt")
print("Ratio of CNCs equal or longer than 3 in Intros is {}%, in the Middle part is {}%, and in the Discussion/Conclusion is {}%.".format(mean_intro, mean_middle, mean_conclusion))
print("Ratio of CNCs in biology articles on average is", mean_total, "%")


			
			
			#- parse the name: [2018-10-25 10:25:37.274379]Processing -Lacking-warmth---Alexithymia-trait-is-related-to-warm-spe_2017_Biological-P.txt in biology_intros
			#(between procession and name1|name2|name3)
			#- parse the parse the parse the folder
			#(ends with one of the names)
			#	- ....with maxCNC: \d+ (count how many of 3, of 4, etc...) -> get number of words 

