import requests

class YugiohX2Exception(Exception):
    pass

class YugiohX2Client:
    TIMEOUT = 5000

    def __init__(self, server_ip="localhost", server_port="2000"):
        self.server_ip = server_ip
        self.server_port = server_port

    def healthcheck(self):
        json = self.__get("/healthcheck")
        return json

    #private
    def __get(self, end_point):
        url = "http://%s:%i%s" % (self.server_ip,self.server_port, end_point)
        response = requests.get(url, timeout=self.TIMEOUT)
        if response.status_code == 200:
            return response.json()
        else:
            raise YugiohX2Exception()

