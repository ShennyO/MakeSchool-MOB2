from flask import Flask, request
import json

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/person')
def person_route():
    person = {"name": "Eliel", 'age': 23}
    json_person = json.dumps(person)
    return (json_person, 200, None)

@app.route('/my_page')
def my_page_route():
    return 'This is my page'

@app.route('/pets')
def pets_route():
    pets = [{"type": "dog"},{"type": "cat"}]
    json_list = json.dumps(pets)
    return (json_list, 200, None)

@app.route('/pets', methods=['POST'])
def pets_post_route():
    received_object = request.json
    json_list = json.dumps(received_object)
    return (json_list, 200, None)



if __name__ == '__main__':
    app.run()
