import requests

from googleapiclient.discovery import build
from imports import *

load_dotenv()
TWITCH_GROOT_ID = os.getenv('TWITCH_GROOT_ID')
TWITCH_AUTHC = os.getenv('TWITCH_AUTHC')
YOUTUBE_ID = os.getenv('YOUTUBE_ID')
YOUTUBE_SECRET = os.getenv('YOUTUBE_SECRET')
YOUTUBE_APIKEY = os.getenv('YOUTUBE_APIKEY')
TWITTER_APIKEY = os.getenv('TWITTER_KEY')
TWITTER_SECRET = os.getenv('TWITTER_SECRET')
TWITTER_BEARER = os.getenv('TWITTER_BEARER')
FACEIT_KEY = os.getenv('FACEIT_KEY')
ELEMENTS_ID = os.getenv('ELEMENTS_ID')
ELEMENTS_SECRET = os.getenv('ELEMENTS_SECRET')


def twitch(user, url):
    my_headers = {
        'Client-ID': TWITCH_GROOT_ID,
        'Authorization': f'Bearer {TWITCH_AUTHC}',
        "Cache-Control": "no-cache",
        "Pragma": "no-cache",
        'Accept': 'application/vnd.twitchtv.v5+json'
    }
    my_params = user
    response = requests.get(url, headers=my_headers, params=my_params)
    data = response.json()
    if response.status_code != 200:
        raise Exception(
            "Request returned an error: {} {}".format(
                response.status_code, response.text
            )
        )
    return data['data']


def twitch_reset_auth():
    url = os.getenv('TWITCH_REFRESH_CLIENT_CREDENTIALS')
    response = requests.post(url)
    data = response.json()
    return data


def youtube(channel_id):
    y = build('youtube', 'v3', developerKey=YOUTUBE_APIKEY)
    request = y.activities().list(
        part='snippet',
        channelId=channel_id
    )
    response = request.execute()
    return response


def twitter(url, my_params):
    my_headers = {
        'Authorization': f'Bearer {TWITTER_BEARER}',
        "Cache-Control": "no-cache",
        "Pragma": "no-cache"
    }
    response = requests.request("GET", url, headers=my_headers, params=my_params)

    data = response.json()
    if response.status_code != 200:
        raise Exception(
            "Request returned an error: {} {}".format(
                response.status_code, response.text
            )
        )
    return data


def elements(url, type):
    headers = {
        "Accept": "application/json",
        'Authorization': f'Bearer {ELEMENTS_SECRET}'
    }
    response = requests.request(type, url, headers=headers)
    data = response.json()
    if response.status_code != 200:
        raise Exception(
            "Request returned an error: {} {}".format(
                response.status_code, response.text
            )
        )
    return data


def faceit(url):
    my_headers = {
        "Accept": "application/json",
        'Authorization': f'Bearer {FACEIT_KEY}'
    }
    response = requests.request("GET", url, headers=my_headers)
    data = response.json()
    if response.status_code != 200:
        raise Exception(
            "Request returned an error: {} {}".format(
                response.status_code, response.text
            )
        )
    return data


class Con:

    def __init__(self):
        self.name = 'connect'

    def get_twitter_user(self, user):
        usernames = f"usernames={user}"
        params = {"user.fields": "created_at"}
        url = "https://api.twitter.com/2/users/by?{}".format(usernames)
        return twitter(url, params)['data']

    def get_twitter_user_tweets(self, user_id, time):
        params = {"tweet.fields": "created_at", "max_results": 5, "expansions": "author_id"}
        if time:
            params['start_time'] = time
        url = "https://api.twitter.com/2/users/{}/tweets".format(user_id)
        return twitter(url, params)

    def get_twitch_user(self, user):
        url = 'https://api.twitch.tv/helix/users'
        parm = {'login': user}
        return twitch(parm, url)

    def get_twitch_status(self, user):
        url = 'https://api.twitch.tv/helix/streams'
        parm = {'user_login': user}
        return twitch(parm, url)

    def get_twitch_clips(self, ntime):
        user = 'spajkk'
        parm = {'login': user, "broadcaster_id": 70962587, "started_at": ntime}
        url = f'https://api.twitch.tv/helix/clips'
        return twitch(parm, url)

    def get_youtube_videos(self, channel_id):
        return youtube(channel_id)

    def get_faceit_user_by_name(self, user):
        url = f'https://open.faceit.com/data/v4/players?nickname={user}'
        return faceit(url)

    def get_faceit_user_by_id(self, user_id):
        url = f'https://open.faceit.com/data/v4/players/{user_id}'
        return faceit(url)

    def get_ele_user(self, user):
        url = f"https://api.streamelements.com/kappa/v2/points/{ELEMENTS_ID}/{user}"
        return elements(url, "GET")

    def add_ele_points(self, user, amount):
        url = f"https://api.streamelements.com/kappa/v2/points/{ELEMENTS_ID}/{user}/{amount}"
        return elements(url, "PUT")

    def test_connection(self, url):
        web_up = True
        try:
            requests.get(url, timeout=3)
        except Exception as e:
            print("Error at:", url, e)
            web_up = False
        return web_up

    def restart_outh(self):
        return twitch_reset_auth()
