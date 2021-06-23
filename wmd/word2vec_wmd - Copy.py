#!/usr/bin/env python
# coding: utf-8

# https://medium.com/@tarekseif0/document-similarity-using-word-movers-distance-and-cosine-similarity-d698ad435422

# In[1]:


from gensim.models import Word2Vec
from gensim.models import KeyedVectors
import json
from rake_nltk import Rake
from nltk.stem import WordNetLemmatizer 
from nltk import word_tokenize, pos_tag
from pyemd import emd
import math


# In[2]:


answers1 = []
f = open('answers2.txt',encoding='utf-8')
lines = f.readlines()

for line in lines:
    if line!='\n':
        answers1 += [line.replace('\n', '')]


# In[3]:


with open('model_answers.txt') as f: 
    data = f.read() 
  
print("Data type before reconstruction : ", type(data)) 
      
# reconstructing the data as a dictionary 
model_answer_list = json.loads(data) 
  
print("Data type after reconstruction : ", type(model_answer_list)) 
# print(model_answer_list) 


# In[4]:


def penn_to_wn(tag):
    """ Convert between a Penn Treebank tag to a simplified Wordnet tag """
    if tag.startswith('N'):
        return 'n'
 
    if tag.startswith('V'):
        return 'v'
 
    if tag.startswith('J'):
        return 'a'
 
    if tag.startswith('R'):
        return 'r'
 
    return 'n'


# In[5]:


r = Rake()
model = KeyedVectors.load("word2vec.model")


# In[6]:


def sentence_similarity(model_key, student_key):
    lemmatizer = WordNetLemmatizer() 

    model_answer_tokenized = word_tokenize(model_key)
    model_pos_tagged = pos_tag(model_answer_tokenized)
    model_tagged = [lemmatizer.lemmatize(word[0].lower(),penn_to_wn(word[1])) for word in model_pos_tagged]

    student_answer_tokenized = word_tokenize(student_key)
    student_pos_tagged = pos_tag(student_answer_tokenized)
    student_tagged = [lemmatizer.lemmatize(word[0].lower(),penn_to_wn(word[1])) for word in student_pos_tagged]
    
#     print(model_tagged,student_tagged)
    return model.wmdistance(model_tagged, student_tagged)


# In[7]:


def evaluate(student_answer, model_answer):
    r.extract_keywords_from_text(student_answer)
    student_keywords = r.get_ranked_phrases()
#     print(student_keywords)
    marks = 0
    for sentence in model_answer.keys():
        sum = 0
        r.extract_keywords_from_text(sentence)
        sentence_keywords = r.get_ranked_phrases()
#         print(sentence_keywords)
        for sentence_keyword in sentence_keywords:
            best = None
            match = None
            for student_keyword in student_keywords:
                sim = sentence_similarity(sentence_keyword, student_keyword)
                if best is None:
                    best = sim
                    match = student_keyword
                elif sim<best:
                    best = sim
                    match = student_keyword
            if best != math.inf:
                sum += best
#                 print(sentence_keyword,",",match,",", best)
        if round(sum/len(sentence_keywords),1) <= 1:
            marks += model_answer[sentence]
    print(marks)


# In[8]:


for student_answer,model_answer in zip(answers1,model_answer_list):
    print("Student -\n",student_answer, "\nModel answer\n",''.join(model_answer.keys()))
    evaluate(student_answer, model_answer)


# In[ ]:




