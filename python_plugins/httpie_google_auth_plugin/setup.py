from setuptools import setup

setup(
  name='httpie-google-auth-plugin',
  version='0.0.1',
  description='Google Auth plugin for HTTPie',
  author='Nik Klassen',
  url='https://github.com/nikklassen/dotfiles/python_plugins/httpie-google-auth-plugin',
  py_modules=['httpie_google_auth_plugin'],
  install_requires=[
    'httpie',
    'google-auth',
  ],
  entry_points={
    'httpie.plugins.auth.v1': [
      'gcp = httpie_google_auth_plugin:GoogleAuthPlugin',
    ]
  },
)
