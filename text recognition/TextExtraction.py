import os, io
from google.cloud import vision_v1
from google.cloud.vision_v1 import types
import pandas as pd

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'text recognition\MP-Project-5039d0814b97.json'
client = vision_v1.ImageAnnotatorClient()

FOLDER_PATH = "D:\\Sarika\MP\\text recognition\\"
IMAGE_FILE = "test1.jpeg"
FILE_PATH = os.path.join(FOLDER_PATH, IMAGE_FILE)

with io.open(FILE_PATH, 'rb') as image_file:
    content = image_file.read()

# print(content)
image = vision_v1.types.Image(content=content)
response = client.document_text_detection(image=image)

docText = response.full_text_annotation.text
print(docText)