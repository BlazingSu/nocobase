import requests
from pytools import memoize

API_URL = 'http://localhost:13000/api'
COLLECTION = 'product'
FIELD = 'id'

@memoize()
def update_field_type():
    url = f"{API_URL}/collections/{COLLECTION}/fields:update"
    params = {'filterByTk': FIELD}
    data = {
        'values': {
            'type': 'integer'
        }
    }
    response = requests.post(url, params=params, json=data)
    response.raise_for_status()
    return response.json()

if __name__ == '__main__':
    result = update_field_type()
    print('Update result:', result)
