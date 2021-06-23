# from PIL import Image
import re
import nltk
from autocorrect import Speller
# from difflib import SequenceMatcher
import pkg_resources
from symspellpy import SymSpell, Verbosity

# text = """Most District reports indicate somewhat stronger regional economic
# activity on balance in December and early January than at the time of the last
# reports in November, with much of the growth centered in the retail and
# industrial sectors. It would appear, on the basis of these reports, that the
# national economy gained momentum in recent weeks as contvmer spending
# strengthened, manufacturing activity continaad to rise, and producers
# scheduled more investment in plant and equipment."""

# text = """Sence content is shopping Cout, interface is
# Payment Strategy. The interface encapsulate
# the algorithms Credit Card Strategy and Paytm Strategy
# Stralegy design pattern is used so now we
# developer can add more payment method without
# charging the context."""

text = """means first come first served. It
operating Systems scheduling
algorithm that automatically executes
queued requests and processes in order
of their arrival Advantages is that
it is simple and easy to understand-
Disadvantages is that the process
with less execution time suffer that
waiting time is often quite lo
long
is"""

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
    
print(text)