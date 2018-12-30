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