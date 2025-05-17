import json
import os
from os import path
from typing import Tuple, cast
import google.auth
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request as GoogleRequest
from httpie.plugins import AuthPlugin
from requests.auth import AuthBase
from requests import Request
from pathlib import Path
from datetime import datetime, timedelta

CACHE_FILE = Path.home() / '.cache' / 'httpie-google-auth-plugin' / 'token.json'

class GoogleAuth(AuthBase):
  def _load_token(self) -> Tuple[str, str]:
    if path.exists(CACHE_FILE):
      with open(CACHE_FILE, 'r') as f:
        data = json.load(f)
        token = data['token']
        project = data['project']
        expiry = datetime.fromisoformat(data['expiry'])
        if expiry > datetime.now() + timedelta(seconds=60):
          return token, project

    credentials, project = google.auth.default()
    project = cast(str, project)
    credentials = cast(Credentials, credentials)
    credentials.refresh(GoogleRequest())
    self._save_token(credentials.token, project)
    return credentials.token, project

  def _save_token(self, token: str, project: str):
    os.makedirs(path.dirname(CACHE_FILE), exist_ok=True)
    with open(CACHE_FILE, 'w') as f:
      json.dump({
        'token': token,
        'project': project,
        'expiry': (datetime.now() + timedelta(seconds=3600)).isoformat(),
      }, f)

  def __call__(self, r: Request) -> Request:
    token, project = self._load_token()
    r.headers['Authorization'] = f'Bearer {token}'
    r.headers['x-goog-user-project'] = project
    return r


class GoogleAuthPlugin(AuthPlugin):
  name = 'Google Auth Plugin'
  description = 'Authentication plugin for Google APIs using google.auth.'

  auth_type = 'gcp'
  auth_require = False
  auth_parse = False
  promt_password = False

  def get_auth(self):
    return GoogleAuth()
