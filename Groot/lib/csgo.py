import a2s
from imports import *


class server_info():

    def __init__(self, config):
        self.config = config
        self.ip_address = config.get('IP')
        self.server_port = config.get('PORT')
        self.msg_id = config.get('msg_id')
        self.servers = []
        self.status = False
        self.info = {}

    async def get(self):
        self.servers = []
        for i in range(0, len(self.server_port)):
            port = self.server_port[i]
            try:
                server_info = a2s.info((self.ip_address, port))
                self.player_list = a2s.players((self.ip_address, port))
                self.info[f'{port}'] = {
                    "server_name": server_info.server_name + ' 🟢',
                    "curr_map": server_info.map_name.split('/')[-1],
                    "players": str(server_info.player_count) + '/' + str(server_info.max_players),
                    "ping": str(int((server_info.ping * 1000))) + 'ms',
                    "connect_link": 'steam://connect/' + str(self.ip_address) + ':' + str(port) + '/kkrp.cz',
                    "status": True
                }

            except Exception as e:
                self.info[f'{port}'] = {
                    "server_name": 'KKRP.cz #' + f'{i+1}' + ' 🔴',
                    "curr_map": 'Unknown',
                    "players": '-1',
                    "ping": '999ms',
                    "connect_link": 'steam://connect/' + str(self.ip_address) + ':' + str(port) + '/kkrp.cz',
                    "status": False
                }

            self.servers.append(self.info[f'{port}'])
            await asyncio.sleep(delay=1)
        self.status = True
