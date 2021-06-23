import flask
from flask import request, jsonify
import io
from PIL import Image
import text_recognition
import json
import similarity

app = flask.Flask(__name__)
app.config["DEBUG"] = True


@app.route('/', methods = ['POST']) 
def home():
    if(request.method == 'POST'):
        received_image = Image.open(request.files['img'])
        print(request.form['model_answer'])
        # print(request)
        model_answer = request.form['model_answer']
        # model_answer += ', 

        # print(model_answer[1:-1].split(","))
        # model_answer.replace('\'','\"')
        # print([subString.split(": ") for subString in model_answer[1:-1].split(",")])
        # model_answer_map = dict(subString.split(": ") for subString in model_answer[1:-1].split(","))
        model_answer_map = json.loads(model_answer)
        print(model_answer_map)
        print(type(model_answer_map))
        # print(type(received_image))
        buffer = io.BytesIO()
        received_image.save(buffer, format='JPEG')
        byte_image = buffer.getvalue()
        text = text_recognition.recognize(byte_image, model_answer_map)
        # print(type(byte_im))
        return jsonify({'marks': sim.evaluate(text,model_answer_map), 'text': text}) 

# app.run()

if __name__ == '__main__':
    sim = similarity.SimilarityModule()
    # app.debug = True
    app.run(host = '192.168.0.102',port=5000, use_reloader=False)