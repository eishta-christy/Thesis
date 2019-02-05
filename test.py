# -*- coding: utf-8 -*-
"""
@author: Kristina Kolesova
"""
l = [5,6,7]
for i in range(len(l)):
	print(i)

import pandas as pd
 
df = pd.DataFrame({'key1': [], 'key2': [], 'key3': []})
for i in range(10):
    df = df.append({'key1': i, 'key2': i*2, 'key3': i**3}, ignore_index=True)
print(df)

import matplotlib.pyplot as plt
import numpy
import scipy.cluster.hierarchy as hcluster


mydata = pd.read_csv('C:/Users/kole021/git/Thesis/biology_parts/df_biology.csv', sep='\t', header=0, index_col=3)
towcolumns = mydata["Words before"].tolist()
for i in range(len(towcolumns)):
	towcolumns[i] = [int(towcolumns[i]), 1]
proportion_positions = []
for article in set(mydata.index):
	print(article)
	word_positions = mydata.loc[article]["Words before"].tolist()
	max_word = max(word_positions)
	for position in word_positions:
		proportion_positions.append([round(position/max_word, 3), 1])
print("proportions positions list", proportion_positions)


#print("two", type(towcolumns), towcolumns)
# generate 3 clusters of each around 100 points and one orphan point
N=100
data = numpy.random.randn(3*N,2)
#data[:N] += 5
for i in range (3*N):
	data[i][1] = 10
#data[-1:] -= 20
##print(data)



# clustering
thresh = 0.004
clusters = hcluster.fclusterdata(proportion_positions, thresh, criterion="distance")

# plotting
plt.scatter(*numpy.transpose(proportion_positions), c=clusters)
plt.axis("equal")
title = "threshold: %f, number of clusters: %d" % (thresh, len(set(clusters)))
plt.title(title)
plt.show()