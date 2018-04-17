import requests

#Place following line at the desired breakpoint
#import pdb; pdb.set_trace()

class YugiohX2ClientException(Exception):
    def __init__(self, response):
        super().__init__(response.json()["message"])
        self.response = response

class YugiohX2Client:
    TIMEOUT = 5000

    def __init__(self, server_url="http://localhost:2000"):
        self.server_url = server_url

    def healthcheck(self):
        json = self.__get("/healthcheck")
        return json

    def db_names(self):
        json = self.__get("/cards/db_names")
        return json

    def card(self, db_name):
        end_point = "/cards/get?db_name=%s" % db_name
        json = self.__get(end_point)
        return json

    def login(self, username, password):
        json = self.__post("/login", { "username": username, "password": password })
        return json

    def user(self, uuid):
        json = self.__get("/users/get", {"uuid": uuid})
        return json

    def user_cards(self, uuid):
        json = self.__get("/users/cards", {"uuid": uuid})
        return json

    def logout(self, uuid):
        json = self.__post("/logout", {}, {"uuid": uuid})
        return json

    #admin
    def deposit(self, username, dp_amount):
        json = self.__post("/users/deposit", {"username": username, "amount": dp_amount})
        return json

    #admin
    def password_machine(self, uuid, serial_number):
        json = self.__post("/shops/password_machine", {"serial_number": serial_number}, {"uuid": uuid})
        return json

    #private
    def __get(self, end_point, headers={}):
        url = "%s%s" % (self.server_url, end_point)
        response = requests.get(url, timeout=self.TIMEOUT, headers=headers)
        self.__validate_response(response)
        return response.json()

    def __post(self, end_point, payload={}, headers={}):
        url = "%s%s" % (self.server_url, end_point)
        response = requests.post(url, timeout=self.TIMEOUT, headers=headers, json=payload)
        self.__validate_response(response)
        return response.json()

    def __validate_response(self, response):
        if response.status_code != 200:
            raise YugiohX2ClientException(response)
