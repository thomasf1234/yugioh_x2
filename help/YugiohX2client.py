import requests

class YugiohX2Exception(Exception):
    pass

class YugiohX2Client:
    TIMEOUT = 5000

    def __init__(self, server_ip="localhost", server_port="2000"):
        self.server_ip = server_ip
        self.server_port = server_port

    def healthcheck(self):
        __get("/healthcheck")

    #private
    def __get(self, end_point):
        url = "%s:%i%s" % (self.server_ip,self.server_port, end_point)
        response = requests.get(url, timeout=self.TIMEOUT)
        if response.status_code:
            return response.json()
        else:
            raise YugiohX2Exception()

