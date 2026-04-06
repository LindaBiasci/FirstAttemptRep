#Linda Biasci
"""A Python program that prints the relative frequence of each letter of the alphabet -
without distinguishing between lower and upper case - in a book.
Some specifics: prints out the processing time, allows to represent data in a histogram.
"""

import time
import argparse
import string
import matplotlib.pyplot as plt

#initial instant: code starts running
time_start = time.time()

#allowing to enter the file path from command line
parser=argparse.ArgumentParser(
    description='Choose a book: frequencies of each letter in the text will be printed, ' \
    'along with a histogram that displays them. Keep in mind: only .txt file are accepted.')
parser.add_argument('txt_file', type=str, help='Enter file path')
book=parser.parse_args()

#initialising a dictionary with all null values, keys being english letters
alphabet = set(string.ascii_lowercase)
FreqDict = dict.fromkeys(alphabet, 0)

def char_freq(some_book):
    """A dictionary might be used for this purpose:
    each letter of the english alphabet is a key, each correspondent int value is its frequence.
    In order to populate the dictionary:
    - only letters have to be considered (not taking into account other characters)
    - both lower and upper case letters have to be added in the count
    - everytime a specific letter (key) is found, its frequency (value) has to be incremented
    """
    #opening and reading the txt file
    with open(some_book.txt_file, 'r', encoding='utf-8') as file:
        mytext = file.read()

    for j in mytext:
        if j.isalpha():
            j = j.lower()
            if j in alphabet:
                FreqDict[j] += 1
    return FreqDict

letter_frequency = char_freq(book)

#printing ordered letters with respective frequencies
for k in sorted(letter_frequency):
    print(f'{k} letter (either lower or upper case): {letter_frequency[k]} times')

#final instant: code finishes running
time_end = time.time()
elapsed_time = time_end - time_start
print(f'Total processing time: {elapsed_time} seconds')

#Additional utility: data representation in a histogram
letters = sorted(FreqDict.keys())
freqs = [FreqDict[i] for i in letters]

plt.bar(letters, freqs)
plt.xlabel('Letters')
plt.ylabel('Frequence')
plt.grid(axis='y', linestyle='--', alpha = 0.7)
plt.tight_layout()
plt.show()
