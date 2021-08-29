from imports import *


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class jsons(metaclass=Singleton):

    def __init__(self):
        self.data = {}
        self.get_started()

    def get_started(self):
        self.data = {}
        for filename in os.listdir('jsons'):
            if filename.endswith('.json'):
                name = filename[:-5]
                with open(f'jsons/{name}.json', 'r', encoding='utf8') as file:
                    self.data[f'{name}'] = json.load(file)

    def get_channels(self, guild, name):
        for used_guild in self.data['channels']:
            if used_guild == str(guild):
                for data in self.data['channels'][f'{guild}']:
                    if data == name:
                        return self.data['channels'][f'{guild}'][f'{name}']
        return None

    def get_colors(self, name):
        for data in self.data['colors']:
            if data == name:
                return self.data['colors'][f'{name}']

    def get_pref(self, name):
        for data in self.data['prefix']:
            if data == name:
                return self.data['prefix'][f'{name}']

        return None

    def get_groot(self, name):
        for data in self.data['grott']:
            if data == name:
                return self.data['grott'][f'{name}']

    def get_roles(self, guild, name):
        for data in self.data['roles'][f'{guild}']:
            if data == name:
                return self.data['roles'][f'{guild}'][f'{name}']

    def get_rss(self, name):
        for data in self.data['rss']:
            if data == name:
                return self.data['rss'][f'{name}']

    def get_rss_settings(self, name):
        for data in self.data['rss']['settings']:
            if data == name:
                return self.data['rss']['settings'][f'{name}']

    def get_twitch(self, name):
        for data in self.data['rss']['twitch']:
            if data == name:
                return self.data['rss']['twitch'][f'{name}']

    def get_twitter(self, name):
        for data in self.data['rss']['twitter']:
            if data == name:
                return self.data['rss']['twitter'][f'{name}']

    def get_youtube(self, name):
        for data in self.data['rss']['youtube']:
            if data == name:
                return self.data['rss']['youtube'][f'{name}']

    def get_youtube_time(self, name):
        for users in self.data['rss']['settings']['youtube']:
            if users == name:
                return self.data['rss']['settings']['youtube'][f'{name}']

    def get_auth(self, id):
        for data in self.data['auth']:
            if len(self.data['auth']) != 0:
                if int(data) == int(id):
                    return self.data['auth'][f'{id}']
        return None

    def get_character(self):
        return self.data['character']

    def get_character_enemy(self):
        return self.data['character_enemy']

    def get_actions(self):
        return self.data['actions']

    def get_items(self):
        return self.data['items']

    def get_map(self):
        return self.data['map']

    def get_property(self):
        return self.data['property']

    def get_shop(self, name):
        for data in self.data['shop']:
            if data == name:
                return self.data['shop'][f'{name}']

    def get_subscription(self):
        return self.data['subscription']

    def get_csgo_settings(self):
        return self.data['config']['csgo']

    def get_lfm_settings(self):
        return self.data['config']['lfm']

    def get_categories(self, guild, name):
        return self.data['categories'][f'{guild}'][f'{name}']

    def set_youtube(self, name, user, data_send):
        for data in self.data['rss']['youtube']:
            if data == name:
                self.data['rss']['youtube'][f'{name}'][f'{user}'] = data_send
                if self.save('rss'):
                    return True

    def set_twitch(self, name, user, data_send):
        for data in self.data['rss']['twitch']:
            if data == name:
                self.data['rss']['twitch'][f'{name}'][f'{user}'] = data_send
                if self.save('rss'):
                    return True

    def set_twitter(self, name, user, data_send):
        for data in self.data['rss']['twitter']:
            if data == name:
                self.data['rss']['twitter'][f'{name}'][f'{user}'] = data_send
                if self.save('rss'):
                    return True

    def set_rss_settings(self, name, user, data_send):
        for data in self.data['rss']['settings']:
            if data == name:
                self.data['rss']['settings'][f'{name}'][f'{user}'] = data_send
                if self.save('rss'):
                    return True

    def set_pref(self, id, pref):
        self.data['prefix'][f'{id}'] = pref
        if self.save('prefix'):
            return True

    def set_auth(self, guild, id, code):
        self.data['auth'][f'{id}'] = {
            "guild": guild,
            "code": code
        }
        if self.save('auth'):
            return True

    def set_status(self, status):
        self.data['grott']['status'].append(status)
        if self.save('grott'):
            return True

    def set_csgo_settings(self, name, data):
        self.data['config']['csgo'][f'{name}'] = data
        if self.save('config'):
            return True

    def set_lfm_settings(self, name, data):
        self.data['config']['lfm'][f'{name}'] = data
        if self.save('config'):
            return True

    def set_categories(self, guild, name, data):
        self.data['categories'][f'{guild}'][f'{name}'] = data
        if self.save('config'):
            return True

    def del_twitter(self, name, user):
        for data in self.data['rss']['twitter']:
            if data == name:
                if self.data['rss']['twitter'][f'{name}'][f'{user}'] is not None:
                    del self.data['rss']['twitter'][f'{name}'][f'{user}']
                    if self.save('rss'):
                        return True
        return False

    def del_twitch(self, name, user):
        for data in self.data['rss']['twitch']:
            if data == name:
                if self.data['rss']['twitch'][f'{name}'][f'{user}'] is not None:
                    del self.data['rss']['twitch'][f'{name}'][f'{user}']
                    if self.save('rss'):
                        return True
        return False

    def del_auth(self, id):
        del self.data['auth'][f'{id}']
        if self.save('auth'):
            return True

    def del_status(self, id):
        del self.data['grott']['status'][int(id)]
        if self.save('grott'):
            return True

    def save(self, name):
        with open(f'jsons/{name}.json', 'w', encoding='utf8') as file:
            json.dump(self.data[f'{name}'], file, ensure_ascii=False, indent=4)
            return True

    def save_all(self):
        for filename in os.listdir('jsons'):
            if filename.endswith('.json'):
                name = filename[:-5]
                with open(f'jsons/{name}.json', 'w', encoding='utf8') as file:
                    json.dump(self.data[f'{name}'], file, ensure_ascii=False, indent=4)

                self.get_started()
