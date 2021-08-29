import mysql.connector
import ast

from mysql.connector import connect, Error
from imports import *
load_dotenv()

config = {
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PW'),
    'host': os.getenv('MYSQL_HOST'),
    'database': os.getenv('MYSQL_DB'),
    'raise_on_warnings': True,
    'auth_plugin': 'mysql_native_password'
}


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class Database(metaclass=Singleton):

    def __init__(self):
        start = False
        try:
            mysql.connector.connect(**config)
            start = True
        except Exception as e:
            print("Error at:")
            print(e)
            print()
            print("Exiting...")
            exit()
        if start:
            self.db = connect(**config)
            self.database = {}
            self.get_started()

    def get_started(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM users")
        users = db.fetchall()
        field_names = [i[0] for i in db.description]
        self.database['users'] = {}
        for i in range(0, len(users)):
            user = users[i]
            val = {
                f"{field_names[2]}": user[2],
                f"{field_names[3]}": json.loads(user[3].decode("utf-8")),
                f"{field_names[4]}": json.loads(user[4].decode("utf-8")),
                f"{field_names[5]}": json.loads(user[4].decode("utf-8")),
                f"{field_names[6]}": user[6],
                f"{field_names[7]}": user[7]
            }
            self.database['users'][f'{user[1]}'] = val
        db.close()

    def get_users_db(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM users")
        users = db.fetchall()
        db.close()
        return users

    def get_user_db(self, discord_id):
        db = self.db.cursor()
        sql = "SELECT * FROM users WHERE discord_id = %s"
        val = (discord_id, )
        db.execute(sql, val)
        users = db.fetchall()
        db.close()
        return users

    def insert_user(self, discord_id, username, auth):
        if str(discord_id) not in self.database['users']:
            val = {
                    "username": f"{username}",
                    "data": {
                        "twitch": {
                            "connected": False,
                            "description": "Twitch"
                        },
                        "lol": {
                            "connected": False,
                            "description": "League of Legends"
                        },
                        "faceit": {
                            "connected": False,
                            "description": "Faceit"
                        },
                        "csgo": {
                            "connected": False,
                            "description": "Counter-Strike: Global Offensive"
                        },
                        "steam": {
                            "connected": False,
                            "description": "Steam"
                        },
                        "riot": {
                            "connected": False,
                            "description": "Riot Games"
                        }
                    },
                    "level_data": {
                        "discord": {
                            "level": 1,
                            "exp": 0
                        },
                        "csgo": {
                            "faceit_elo": 1,
                            "faceit_rank": 0,
                            "csgo_rank": 0,
                            "csgo_elo": 0,
                            "gather_rank": 0,
                            "gather_elo": 0
                        },
                        "lol": {
                            "lol_elo": 1,
                            "lol_rank": 0,
                            "gather_rank": 0,
                            "gather_elo": 0
                        },
                    },
                    "extended_data": {

                    },
                    "auth": f"{int(auth)}",
                    "created_at": f"{dt.datetime.now()}"
                }
            self.database['users'][f'{discord_id}'] = val
            self.save(discord_id)
            return True
        else:
            return False

    def update_add_user(self, discord_id, level, platform, data, value):
        if str(discord_id) in str(self.database['users']):
            kaka = self.database['users'][f'{discord_id}'][f'{level}'][f'{platform}']
            kaka[f'{data}'] = value
            return True
        return False

    def update_del_user(self, discord_id, level, platform, data):
        if str(discord_id) in str(self.database['users']):
            kaka = self.database['users'][f'{discord_id}'][f'{level}'][f'{platform}']
            del kaka[f'{data}']
            return True
        return False

    def get_user(self, discord_id):
        if str(discord_id) in str(self.database['users']):
            return self.database['users'][f'{discord_id}']
        else:
            return None

    def get_users(self):
        refresh = self.database['users']
        return refresh

    def get_users_twitch(self):
        users_con_twitch = {}
        for user in self.database['users']:
            if self.database['users'][f'{user}']['data']['twitch']['connected']:
                users_con_twitch[f'{user}'] = self.database['users'][f'{user}']['data']['twitch']['id']
        return users_con_twitch

    def save(self, discord_id):
        try:
            users = self.get_users_db()
            db = self.db.cursor()
            if str(discord_id) in str(users):
                sql = "UPDATE users SET username=%s,data=%s, level_data=%s, extended_data=%, auth=%s, created_at=%s WHERE discord_id=%s"
                val = (
                    self.database['users'][f'{discord_id}']['username'],
                    json.dumps(self.database['users'][f'{discord_id}']['data']),
                    json.dumps(self.database['users'][f'{discord_id}']['level_data']),
                    json.dumps(self.database['users'][f'{discord_id}']['extended_data']),
                    self.database['users'][f'{discord_id}']['auth'],
                    self.database['users'][f'{discord_id}']['created_at'],
                    int(discord_id)
                )
            else:
                sql = "INSERT INTO users (discord_id, username, data, level_data, extended_data, auth, created_at) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                val = (
                    int(discord_id),
                    self.database['users'][f'{discord_id}']['username'],
                    json.dumps(self.database['users'][f'{discord_id}']['data']),
                    json.dumps(self.database['users'][f'{discord_id}']['level_data']),
                    json.dumps(self.database['users'][f'{discord_id}']['extended_data']),
                    self.database['users'][f'{discord_id}']['auth'],
                    self.database['users'][f'{discord_id}']['created_at']
                )
            db.execute(sql, val)
            self.db.commit()
            return True
        except Exception as e:
            print('error', e)
            return False

    def save_all(self):
        try:
            users = self.get_users_db()
            db = self.db.cursor()
            values_update = []
            values_insert = []
            update = "UPDATE users SET username=%s, data=%s, level_data=%s, extended_data=%s, auth=%s, created_at=%s WHERE discord_id=%s"
            insert = "INSERT INTO users (discord_id, username, data, level_data, extended_data, auth, created_at) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            for user in self.database['users']:
                if str(user) in str(users):
                    val = (
                        self.database['users'][f'{user}']['username'],
                        json.dumps(self.database['users'][f'{user}']['data']),
                        json.dumps(self.database['users'][f'{user}']['level_data']),
                        json.dumps(self.database['users'][f'{user}']['extended_data']),
                        self.database['users'][f'{user}']['auth'],
                        self.database['users'][f'{user}']['created_at'],
                        user
                    )
                    values_update.append(val)
                else:
                    val = (
                        user,
                        self.database['users'][f'{user}']['username'],
                        json.dumps(self.database['users'][f'{user}']['data']),
                        json.dumps(self.database['users'][f'{user}']['level_data']),
                        json.dumps(self.database['users'][f'{user}']['extended_data']),
                        self.database['users'][f'{user}']['auth'],
                        self.database['users'][f'{user}']['created_at']
                    )
                    values_insert.append(val)
            if len(values_update) > 0:
                db.executemany(update, values_update)
            if len(values_insert) > 0:
                db.executemany(insert, values_insert)
            self.db.commit()
            return True
        except Exception as e:
            print('error', e)
            return False


class Rooms(metaclass=Singleton):

    def __init__(self):
        start = False
        try:
            mysql.connector.connect(**config)
            start = True
        except Exception as e:
            print("Error at:")
            print(e)
            print()
            print("Exiting...")
            exit()
        if start:
            self.db = connect(**config)
            self.rooms = {}
            self.get_started()

    def get_started(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM rooms")
        rooms = db.fetchall()
        field_names = [i[0] for i in db.description]
        for i in range(0, len(rooms)):
            room = rooms[i]
            val = {
                f"{field_names[2]}": room[2],
                f"{field_names[3]}": room[3],
                f"{field_names[4]}": json.loads(room[4]),
                f"{field_names[5]}": room[5],
            }
            self.rooms[f'{room[1]}'] = val
        db.close()

    def insert_room(self, owner_id, text_id, voice_id, time):
        db = self.db.cursor()
        try:
            insert = "INSERT INTO rooms (owner, text_room_id, voice_room_id, time, created_at) VALUES (%s, %s, %s, %s, %s)"
            val = (
                owner_id,
                text_id,
                voice_id,
                json.dumps(time),
                dt.datetime.now()
            )
            db.execute(insert, val)
            self.db.commit()
            self.get_started()
            return True
        except Exception as e:
            print(e, 'error in DB at 296')
            return False

    def delete_room(self, voice_id):
        db = self.db.cursor()
        for owner in self.rooms:
            if self.rooms[f'{owner}']['voice_room_id'] == voice_id:
                delete = f"DELETE FROM rooms WHERE owner = {owner} AND voice_room_id = {voice_id}"
                db.execute(delete)
                self.db.commit()
                self.get_started()
                return True
        return False

    def get_room(self):
        return self.rooms


class Mute(metaclass=Singleton):

    def __init__(self):
        start = False
        try:
            mysql.connector.connect(**config)
            start = True
        except Exception as e:
            print("Error at:")
            print(e)
            print()
            print("Exiting...")
            exit()
        if start:
            self.db = connect(**config)
            self.mute = {}
            self.get_started()

    def get_started(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM mute")
        rooms = db.fetchall()
        field_names = [i[0] for i in db.description]
        for i in range(0, len(rooms)):
            room = rooms[i]
            val = {
                f"{field_names[2]}": room[2],
                f"{field_names[3]}": room[3],
                f"{field_names[4]}": room[4],
                f"{field_names[5]}": room[5],
                f"{field_names[6]}": json.loads(room[6]),
            }
            self.mute[f'{room[1]}'] = val
        db.close()

    def insert_muted(self, author, muted_id, guild_id, time, reason, created_at):
        db = self.db.cursor()
        try:
            insert = "INSERT INTO mute (author, muted_id, guild_id, time, reason, created_at) VALUES (%s, %s, %s, %s, %s, %s)"
            val = (
                author,
                muted_id,
                guild_id,
                time,
                reason,
                json.dumps(created_at)
            )
            db.execute(insert, val)
            self.db.commit()
            self.get_started()
            return True
        except Exception as e:
            print(e, 'error in DB at 364')
            return False

    def delete_room(self, muted_id):
        db = self.db.cursor()
        for author in self.mute:
            if self.mute[f'{author}']['muted_id'] == muted_id:
                delete = f"DELETE FROM mute WHERE author = {author} AND voice_room_id = {muted_id}"
                db.execute(delete)
                self.db.commit()
                self.get_started()
                return True
        return False

    def get_muted(self):
        return self.mute


class GameDatabase(metaclass=Singleton):

    def __init__(self):
        start = False
        try:
            mysql.connector.connect(**config)
            start = True
        except Exception as e:
            print("Error at:")
            print(e)
            print()
            print("Exiting...")
            exit()
        if start:
            self.db = connect(**config)

    def get_started(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM databorne")
        game = db.fetchall()
        field_names = [i[0] for i in db.description]
        for i in range(0, len(game)):
            user = game[i]
            val = {

            }

    def character_check(self, discord_id):
        db = self.db.cursor()
        db.execute("SELECT discord_id FROM databorne")
        databorne = db.fetchall()
        if len(databorne) != 0:
            for k in databorne:
                if discord_id == k:
                    return True
            return True
        return False

    def insert_character(self, discord_id, username, auth):
        if not self.character_check(discord_id):
            db = self.db.cursor()
            insert = "INSERT INTO users (discord_id, character_name, position, health, level, exp, attributes, active_items, items, wallet, bank, crypto, property, work) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            val = (
                int(discord_id),
                username,
                0,
                100,
                0,
                0,
                json.dumps(),

            )
            db.execute()
            self.db.commit()
            return True
        else:
            return False