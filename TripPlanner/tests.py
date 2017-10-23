import server
import unittest
import json
import bcrypt
import base64
from pymongo import MongoClient
import pdb


class TripPlannerTestCase(unittest.TestCase):

    # def generateBasicAuth(username, password):
        


    def setUp(self):

      self.app = server.app.test_client()
      # Run app in testing mode to retrieve exceptions and stack traces
      server.app.config['TESTING'] = True

      mongo = MongoClient('localhost', 27017)
      global db

      # Reduce encryption workloads for tests
      server.app.bcrypt_rounds = 4

      db = mongo.trip_planner_test
      server.app.db = db

      db.drop_collection('users')
      db.drop_collection('trips')

    # User tests, fill with test methods
    def testCreateUser(self):

        self.app.post(
            '/users',
            data=json.dumps(dict(
            username="Ouyeezyy",
            password="test",
            email="sunnyouyang.ehs@gmail.com",
            id="51011123"
            )), content_type='application/json'
        )


        response = self.app.get(
        '/users',
        query_string=dict(email="sunnyouyang.ehs@gmail.com")
        )


        self.assertEqual(response.status_code, 200)





    def testUserParam(self):

        response = self.app.post(
            '/users',
            data=json.dumps(dict(
            username="Shenny",
            password="testzzz"

            )), content_type = 'application/json'

        )


        print("IT WORKED")

        self.assertEqual(response.status_code, 400)

    def testPatchUser(self):


        #to do the Patch, I get the user with a get request with the user's email in the URL parameters
        #and then i'll change the parameters with the body of the request.
        #to test the patch, I want to see if the parameters I changed is equal
        #to the client's post request.

        changed_username="BlackOuyeezy"

        self.app.post(
            '/users',
            data=json.dumps(dict(
            username="BOuyeezy",
            password="test",
            email="sunnyouyangs.ehs@gmail.com",
            id="51011123"
            )), content_type='application/json'
        )


        #the patch is going to take both a query string, for the request arguments and also take data thats from our body
        response = self.app.patch(
            '/users',
            query_string=dict(email="sunnyouyangs.ehs@gmail.com"),
            data=json.dumps(dict(
            username="BlackOuyeezy",
            password="test",
            email="sunnyouyang.ehs@gmail.com",
            id="51011123"
            )), content_type='application/json'
        )

        self.assertEqual(response.status_code, 200)

    def test_invalid_get_user(self):

        self.app.post(
            '/users',
            data=json.dumps(dict(
            username="Ouyeezyy",
            password="test",
            email="sunnyouyang.ehs@gmail.com",
            id="51011123"
            )), content_type='application/json'
        )

        response = self.app.get(
        '/users',
        query_string=dict(email="sunnyouyangs.ehs@gmail.com")
        )

        self.assertEqual(response.status_code, 400)

    def test_nonexistent_patch_user(self):

        response = self.app.patch(
            '/users',
            query_string=dict(email="sunnyouyangs.ehs@gmail.com"),
            data=json.dumps(dict(
            username="BlackOuyeezy",
            password="test",
            email="sunnyouyang.ehs@gmail.com",
            id="51011123"
            )), content_type='application/json'
        )

        self.assertEqual(response.status_code, 401)

    # def test_delete_user(self):



    def test_create_trips(self):
        #in this func we want to test if we get back the selected trip correctly
        #able to test both the post and get at once

        self.app.post(
            '/trips',
            data=json.dumps(dict(
            destination="foshan",
            start_date="Start date",
            end_date="end date",
            completed=False,
            waypoints=[{
            'name': 'LamHoi',
            'lat': 23.0,
            'long': 40.0
            }],
            email="sunnyouyang.ehs@gmail.com"
            )), content_type='application/json'
        )


        response = self.app.get(
        '/trips',
        query_string=dict(email="sunnyouyang.ehs@gmail.com", destination="foshan")
        )


        self.assertEqual(response.status_code, 200)

    def test_trip_patch(self):
        #in here we test if we can correctly update a value of one of our trips
        self.app.post(
            '/trips',
            data=json.dumps(dict(
            destination="foshan",
            start_date="Start date",
            end_date="end date",
            completed=False,
            waypoints=[],
            email="sunnyouyang.ehs@gmail.com"
            )), content_type='application/json'
        )

        response = self.app.patch(
        '/trips',
        query_string=dict(email="sunnyouyangs.ehs@gmail.com", destination="foshan"),
        data=json.dumps(dict(
        completed=True,
        waypoints=[{'name': 'LamHoi', 'lat': 32.0, 'long': 5.0}]
        )), content_type='application/json'

        )

        self.assertEqual(response.status_code, 200)

    def test_trip_delete(self):
        #here we check if we can correctly delete a trip from the trips collection

        self.app.post(
            '/trips',
            data=json.dumps(dict(
            destination="foshan",
            start_date="Start date",
            end_date="end date",
            completed=False,
            waypoints=[],
            email="sunnyouyang.ehs@gmail.com"
            )), content_type='application/json'
        )

        response = self.app.delete(
        '/trips',
        query_string=dict(email="sunnyouyang.ehs@gmail.com", destination="foshan")
        )
        self.assertEqual(response.status_code, 200)

    def test_invalid_trip_get(self):
        #Here we'll purposely enter in the wrong parameter to see if the error hits

        self.app.post(
            '/trips',
            data=json.dumps(dict(
            destination="foshan",
            start_date="Start date",
            end_date="end date",
            completed=False,
            waypoints=[{
            'name': 'LamHoi',
            'lat': 23.0,
            'long': 40.0
            }],
            email="sunnyouyang.ehs@gmail.com"
            )), content_type='application/json'
        )


        response = self.app.get(
        '/trips',
        query_string=dict(email="sunnyouyangs.ehs@gmail.com", destination="foshans")
        )

        self.assertEqual(response.status_code, 400, None)



    def test_invalid_trip_post(self):
        #check to see if we enter invalid body for post request
        result = self.app.post(
            '/trips',
            data=json.dumps(dict(
            destination="foshan",
            start_date="Start date",
            endd_date="end date",
            completed=False,
            waypoints=[{
            'name': 'LamHoi',
            'lat': 23.0,
            'long': 40.0
            }],
            email="sunnyouyang.ehs@gmail.com"
            )), content_type='application/json'
        )

        self.assertEqual(result.status_code, 400, None)

    #
    # def test_nonexistent_patch_trip(self):
    #     #check to see if we can patch when there's nothing to patch
    #
    # def test_invalid_trip_delete(self):
    #     #check what happens when we run an invalid delete request








if __name__ == '__main__':
    unittest.main()
