from flask import Flask, request
import json
from pymongo import MongoClient
from bson.objectid import ObjectId

# Custom JSONEncoder that extracts the strings from MongoDB ObjectIDs
# Thanks to http://stackoverflow.com/questions/16586180/typeerror-objectid-is-not-json-serializable
class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)


mongo = MongoClient('localhost', 27017)
app = Flask(__name__)
app.db = mongo.local


@app.route('/edit_hunters/<string:name>', methods=['PATCH'])
def edit_route(name):
    hunters_collection = app.db.Hunters
    name_result = request.json
    searched_obj = hunters_collection.find_one({'name': name})
    searched_obj['name'] = name_result['name']
    hunters_collection.update({'name': name}, {'name': name_result['name']})
    json_searched_obj = JSONEncoder().encode(searched_obj)
    return (json_searched_obj, 200, None)



@app.route('/count_hunters', methods=['GET'])
def count_route():
    hunters_collection = app.db.Hunters
    count = hunters_collection.count()
    json_count = json.dumps(count)
    return (json_count, 200, None)

@app.route('/get_all', methods=['GET'])
def get_all_route():
    hunters_collection = app.db.Hunters
    json_array = []
    for json_object in hunters_collection.find():
        json_array.append(json_object)
    return_array = JSONEncoder().encode(json_array)
    return (return_array, 200, None)



@app.route('/get_toby', methods=['GET'])
def get_route():
    hunters_collection = app.db.Hunters
    search_params = request.args
    if 'name' in search_params:
        hunter_name = search_params['name']
        result = hunters_collection.find_one({'name': hunter_name})
        if result is None:
            not_found_msg = {'error': 'Name not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)
        response_json = JSONEncoder().encode(result)
        return (response_json, 200, None)
    error_msg = {'error': 'Missing Parameters'}
    json_msg = json.dumps(error_msg)
    return (json_msg, 400, None)


@app.route('/Toby', methods=['POST'])
def toby_route():
    json_obj = request.json
    if ('name' in json_obj and 'str' in json_obj):
        hunters_collection = app.db.Hunters
        result = hunters_collection.insert_one(json_obj)
        obj_json = JSONEncoder().encode(json_obj)
        return (obj_json, 201, None)
    error_dict = {'error': 'Missing Parameters'}
    json_error_obj = json.dumps(error_dict)

    return (json_error_obj, 400, None)



if __name__ == '__main__':
    app.run()
