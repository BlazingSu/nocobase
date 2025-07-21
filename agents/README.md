# NocoBase Python Tools

This directory provides lightweight helpers for interacting with a NocoBase instance.
The modules are organised as simple functions so they can be reused in scripts or
notebooks.

## Installation

The only runtime dependency is [`requests`](https://pypi.org/project/requests/):

```bash
pip install requests
```

## Usage

```python
from agents.auth import authenticate_user
from agents.noco_api import NocoAPI
from agents.image_uploader import upload_image
from agents.csv_generator import generate_csv

# Authenticate and create an API client
api_url = "http://localhost:13000/api"
token = authenticate_user(api_url, "admin@example.com", "secret")
api = NocoAPI(api_url, token)

# Inspect collections and their fields
collections = api.list_collections()
print(collections)
fields = api.list_fields(collections[0]["name"])
print(fields)

# Upload an image and generate a CSV file that references it
image_url = upload_image(api_url, token, "attachments", "/path/to/image.png")
records = [{"name": "Example"}]
field_names = ["name", "image"]

generate_csv("output.csv", field_names, records,
             image_field="image", image_url=image_url)
```

## Running the Tests

Unit tests are provided for each module. Use `pytest` with the current
repository on the Python path:

```bash
PYTHONPATH=. pytest -q
```
