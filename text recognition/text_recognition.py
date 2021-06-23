import os, io
from google.cloud import vision
# from google.cloud.vision_v1 import types
# from PIL import Image
import re
import nltk
from autocorrect import Speller
# from difflib import SequenceMatcher
import pkg_resources
from symspellpy import SymSpell, Verbosity
import similarity

# <class '_io.BufferedReader'>
# <class 'bytes'>
def recognize(content, model_answer):
    # os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'text recognition\MP-Project-5039d0814b97.json'
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'MP-Project-5039d0814b97.json'
    client = vision.ImageAnnotatorClient()
    print(type(content))
    image = vision.Image(content=content)
    print(type(image))
    response = client.document_text_detection(image=image)
    # print(response)

    docText = response.full_text_annotation.text
    print(docText)
    #fucntion call to spell checker
    docText = spellChecker(docText)
    # sim = similarity.SimilarityModule()
    # marks = sim.evaluate(docText, model_answer)
    # print(marks)
    return docText
    # return marks
    # return ""

def spellChecker(text):
    sym_spell = SymSpell(max_dictionary_edit_distance=2, prefix_length=7)
    dictionary_path = pkg_resources.resource_filename(
        "symspellpy", "frequency_dictionary_en_82_765.txt")
    bigram_path = pkg_resources.resource_filename(
        "symspellpy", "frequency_bigramdictionary_en_243_342.txt")
    # term_index is the column of the term and count_index is the
    # column of the term frequency
    sym_spell.load_dictionary(dictionary_path, term_index=0, count_index=1)
    sym_spell.load_bigram_dictionary(bigram_path, term_index=0, count_index=2)

    rep = { '\n': ' ', '\\': ' ', '\"': '"', '-': ' ', '"': ' " ', 
            '"': ' " ', '"': ' " ', ',':' , ', '.':' . ', '!':' ! ', 
            '?':' ? ', "n't": " not" , "'ll": " will", '*':' * ', 
            '(': ' ( ', ')': ' ) ', "s'": "s '"}
    rep = dict((re.escape(k), v) for k, v in rep.items()) 
    pattern = re.compile("|".join(rep.keys()))
    text = pattern.sub(lambda m: rep[re.escape(m.group(0))], text)
    def get_personslist(text):
        personslist=[]
        for sent in nltk.sent_tokenize(text):
            for chunk in nltk.ne_chunk(nltk.pos_tag(nltk.word_tokenize(sent))):
                if isinstance(chunk, nltk.tree.Tree) and chunk.label() == 'PERSON':
                    personslist.insert(0, (chunk.leaves()[0][0]))
        return list(set(personslist))
    personslist = get_personslist(text)
    ignorewords = personslist + ["!", ",", ".", "\", '?', '(', ')', '*', """]
    # using enchant.checker.SpellChecker, identify incorrect words
    d = Speller("en")
    words = text.split()
    incorrectwords = [w for w in words if not d(w)==w and w not in ignorewords]
    # using enchant.checker.SpellChecker, get suggested replacements
    suggestedwords = [d(w) for w in incorrectwords]
    originalwords = [w for w in incorrectwords]
    # replace incorrect words with [MASK]
    for w in incorrectwords:
        text = text.replace(w, sym_spell.lookup_compound((w), max_edit_distance=2,transfer_casing=True)[0].term)
        # text_original = text_original.replace(w, '[MASK]')
        # text = text.replace(w, d(w))
    # text.replace("ICS Scanned with CamScanner", "")
    print(text)
    return text