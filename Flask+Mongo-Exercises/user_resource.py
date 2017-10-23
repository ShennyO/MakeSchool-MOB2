from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
# from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
import bcrypt
import json

class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)


app = Flask(__name__)
mongo = MongoClient('localhost', 27017)
app.db = mongo.local
app.bcrypt_rounds = 12
api = Api(app)

class User(Resource):



    def patch(self):
        #patch request is basically getting the document with a get request
        #and then updating the value
        hunters_collection = app.db.Hunters
        name_result = request.json
        searched_name = request.args['name']
        searched_obj = hunters_collection.find_one({'name': searched_name})
        if searched_obj is None:
            not_found_msg = {'error': 'Name not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)
        hunters_collection.update({'name': searched_name}, {'name': name_result['name']})
        json_searched_obj = JSONEncoder().encode(searched_obj)
        return (json_searched_obj, 200, None)

    def post(self):

      new_hunter = request.json

      hunters_collection = app.db.Hunters

      if ('name' in new_hunter and 'str' in new_hunter):
          result = hunters_collection.insert_one(new_hunter)
          hunter_object = hunters_collection.find_one({"_id": ObjectId(result.inserted_id)})
          return (hunter_object, 201, None)
      error_dict = {'error': 'Missing Parameters'}
      json_error_obj = json.dumps(error_dict)

      return (json_error_obj, 400, None)


	  #querying for the object we just inserted into the database


    def get(self):
      #getting the collection
      hunters_collection = app.db.Hunters
      hunters_name = request.args['name']
      result = hunters_collection.find_one({'name': hunters_name})
      if result is None:
         not_found_msg = {'error': 'Name not found'}
         json_not_found = json.dumps(not_found_msg)
         return (json_not_found, 400, None)
      response_json = JSONEncoder().encode(result)
      return (response_json, 200, None)






    #   if myobject is None:
    #     response = jsonify(data=[])
    #     response.status_code = 404
    #     return response
    #   else:
    #     return myobject

api.add_resource(User, '/Hunters')



@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp

if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
