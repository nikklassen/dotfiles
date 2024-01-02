#!/usr/bin/env python3
import os, sys, requests
from datetime import datetime, timedelta

base = os.path.dirname(os.path.realpath(__file__))
temp_file = f'{base}/.temp'

def should_reload(fname):
  if not os.path.exists(fname):
    return True
  mod_time = datetime.fromtimestamp(os.path.getmtime(fname))
  return datetime.now() - mod_time > timedelta(minutes=5)

def slurp(fname):
  with open(fname, 'r') as f:
    return f.readline().strip()

def main():
  if not should_reload(temp_file):
    print(slurp(temp_file))
    return

  api_key = slurp(f'{base}/.config/apikey')
  loc = slurp(f'{base}/.config/location')
  [lat, lon] = loc.split(' ')

  req = f'http://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&appid={api_key}'
  resp = requests.get(req)
  data = resp.json()

  temp = round(data['main']['temp'], 1)
  temp_str = f'{temp} °C'

  for weather in data['weather']:
    icon = weather['icon']
    if icon.startswith('01'):
      emoji="☀️"
    elif icon.startswith('02'):
      emoji="⛅️"
    elif icon.startswith('03') or icon.startswith('04'):
      emoji="☁️"
    elif icon.startswith('09'):
      emoji="☔️"
    elif icon.startswith('10'):
      emoji="🌦"
    elif icon.startswith('11'):
      emoji="⚡️"
    elif icon.startswith('13'):
      emoji="❄️"
    elif icon.startswith('50'):
      emoji="🌁"
    if emoji:
      temp_str += f' {emoji}'
      break

  print(temp_str)
  with open(temp_file, 'w+') as f:
    f.write(temp_str)

if __name__ == "__main__":
  main()
