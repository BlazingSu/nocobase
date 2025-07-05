import requests

API_URL = 'http://localhost:13000/api'
USERNAME = 'admin@nocobase.com'
PASSWORD = 'Qaz19981108@'
AUTHENTICATOR = 'goout'
COLLECTION = 'products'
FIELD = 'id'


def sign_in():
    url = f"{API_URL}/auth:signIn"
    headers = {
        'Content-Type': 'application/json',
        'X-Authenticator': AUTHENTICATOR,
    }
    data = {
        'email': USERNAME,
        'password': PASSWORD,
    }
    resp = requests.post(url, headers=headers, json=data)
    resp.raise_for_status()
    return resp.json()['data']['token']


def update_field_type(token: str):
    url = f"{API_URL}/collections/{COLLECTION}/fields/{FIELD}"
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json',
        'X-Authenticator': AUTHENTICATOR,
    }
    data = {'type': 'integer'}
    resp = requests.patch(url, json=data, headers=headers)
    resp.raise_for_status()
    return resp.json()


if __name__ == '__main__':
    token = sign_in()
    result = update_field_type(token)
    print('Update result:', result)
