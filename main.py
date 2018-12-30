# -*- coding: utf-8 -*-
"""
@author: Kristina Kolesova
"""

import os
import sys
from pos import empty_the_parts_output, get_CNCs_up_3_of_a_corpus, calculate_corpus_size_in_words
if __name__ == "__main__":
    ##parts_directory = "C:/Users/kole021/git/CNC/parts/biology_parts_second_trial/"
    ##rootdirectory = "C:/Users/kole021/git/CNC/intros/biology_intros/biology_intros_second_trial/"
    parts_directory = "C:/Users/kole021/git/Thesis/parts/linguistics_parts/"
    rootdirectory = "C:/Users/kole021/git/Thesis/intros/"
    
    #empty_the_parts_output("C:/Users/kole021/git/CNC/parts/biology_parts/")
    
    empty_the_parts_output(parts_directory)
    get_CNCs_up_3_of_a_corpus(rootdirectory, parts_directory)
    
    
##check out et al. stuff, check may be later again..

##calculate corpus size!!!! for biology and economics
