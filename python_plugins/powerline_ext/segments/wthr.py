# vim:fileencoding=utf-8:noet
from datetime import datetime, timedelta
import os
import tempfile

from powerline.lib.threaded import ThreadedSegment
from powerline.segments import with_docstring
import requests

TEMP_FILE = os.path.join(tempfile.gettempdir(), '.temperature.temp')
CONFIG_BASE = os.path.join(os.getenv('HOME'), 'dotfiles', 'scripts', '.config')


def should_reload(fname):
  if not os.path.exists(fname):
    return True
  mod_time = datetime.fromtimestamp(os.path.getmtime(fname))
  return datetime.now() - mod_time > timedelta(minutes=5)


def slurp(fname):
  with open(fname, 'r') as f:
    return f.readline().strip()


class WeatherSegment(ThreadedSegment):
  min_sleep_time = 600
  interval = 600
  api_key = ''
  lat = ''
  lon = ''

  def run(self):
    pass

  def update(self, _):
    if not self.api_key:
      self.api_key = slurp(os.path.join(CONFIG_BASE, 'apikey'))

    if not should_reload(TEMP_FILE):
      try:
        data = slurp(TEMP_FILE)
        temp, emoji = data.split(' ')
        return float(temp), emoji
      except ValueError:
        pass

    if not self.lat:
      loc = slurp(os.path.join(CONFIG_BASE, 'location'))
      [self.lat, self.lon] = loc.split(' ')

    req = (
        'http://api.openweathermap.org/data/2.5/weather?'
        'lat={lat}&lon={lon}&units=metric&appid={key}'.format(
            lat=self.lat, lon=self.lon, key=self.api_key
        )
    )
    resp = requests.get(req)

    data = resp.json()
    try:
      temp = data['main']['temp']
      for weather in data['weather']:
        icon = weather['icon']
        if icon.startswith('01'):
          emoji = '☀️'
        elif icon.startswith('02'):
          emoji = '⛅️'
        elif icon.startswith('03') or icon.startswith('04'):
          emoji = '☁️'
        elif icon.startswith('09'):
          emoji = '☔️'
        elif icon.startswith('10'):
          emoji = '🌦'
        elif icon.startswith('11'):
          emoji = '⚡️'
        elif icon.startswith('13'):
          emoji = '❄️'
        elif icon.startswith('50'):
          emoji = '🌁'
        if emoji:
          break

      with open(TEMP_FILE, 'w+') as f:
        f.write(str('{temp} {emoji}'.format(temp=temp, emoji=emoji)))
      return temp, emoji
    except Exception as e:
      self.error(f'something went wrong: {repr(e)}')
      return 0, ''

  def render(self, data, **_kwargs):
    temp, emoji = data
    temp_format = '{temp:.1f}°C {emoji}'
    if temp <= -30:
      gradient_level = 0
    elif temp >= 40:
      gradient_level = 100
    else:
      gradient_level = (temp + 30) * 100.0 / 70
    return [
        {
            'contents': temp_format.format(temp=temp, emoji=emoji),
            'highlight_groups': [
                'weather_temp_gradient',
                'weather_temp',
                'weather',
            ],
            'divider_highlight_group': 'background:divider',
            'gradient_level': gradient_level,
        },
    ]


weather = with_docstring(
    WeatherSegment(),
    """Divider highlight group used: ``background:divider``.

                          Highlight groups used: ``weather_conditions`` or ``weather``, ``weather_temp_gradient`` (gradient) or ``weather``.
                          """,
)
