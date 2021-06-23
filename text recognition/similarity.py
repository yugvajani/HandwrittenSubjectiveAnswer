from gensim.models import Word2Vec
from gensim.models import KeyedVectors
import json
from rake_nltk import Rake
from nltk.stem import WordNetLemmatizer 
from nltk import word_tokenize, pos_tag
from pyemd import emd
import math

class SimilarityModule():
    def __init__(self):
        print("in constructor")
        self.r = Rake()
        self.model = KeyedVectors.load("D:\Sarika\Handwritten-Subjective-Answer-Evaluation-System\wmd\word2vec.model")
        print("after model load")



    def penn_to_wn(self, tag):
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


    def sentence_similarity(self, model_key, student_key):
        lemmatizer = WordNetLemmatizer() 

        model_answer_tokenized = word_tokenize(model_key)
        model_pos_tagged = pos_tag(model_answer_tokenized)
        model_tagged = [lemmatizer.lemmatize(word[0].lower(),self.penn_to_wn(word[1])) for word in model_pos_tagged]

        student_answer_tokenized = word_tokenize(student_key)
        student_pos_tagged = pos_tag(student_answer_tokenized)
        student_tagged = [lemmatizer.lemmatize(word[0].lower(),self.penn_to_wn(word[1])) for word in student_pos_tagged]
        
    #     print(model_tagged,student_tagged)
        return self.model.wmdistance(model_tagged, student_tagged)

    def evaluate(self, student_answer, model_answer):
        print("in evaluate")
        self.r.extract_keywords_from_text(student_answer)
        student_keywords = self.r.get_ranked_phrases()
        print(student_keywords)
        marks = 0
        for sentence in model_answer.keys():
            sum = 0
            self.r.extract_keywords_from_text(sentence)
            sentence_keywords = self.r.get_ranked_phrases()
            print(sentence_keywords)
            for sentence_keyword in sentence_keywords:
                best = None
                match = None
                for student_keyword in student_keywords:
                    sim = self.sentence_similarity(sentence_keyword, student_keyword)
                    if best is None:
                        best = sim
                        match = student_keyword
                    elif sim<best:
                        best = sim
                        match = student_keyword
                if best != math.inf:
                    sum += best
                    print(sentence_keyword,",",match,",", best)
            if round(sum/len(sentence_keywords),1) <= 1:
                marks += float(model_answer[sentence])
            elif round(sum/len(sentence_keywords),1) > 1 and round(sum/len(sentence_keywords),1) <= 1.1:
                marks += float(model_answer[sentence]) *0.5
        print(marks)
        return str(marks)
