import asyncio
import json

from winrt.windows.media.control import \
    GlobalSystemMediaTransportControlsSessionManager as MediaManager

def obj_to_dict(o):
    if isinstance(o, (str, int, float, bool)):
        return o
    ret = {}
    for a in dir(o):
        # a[0] != '_' ignores system attributes
        if a[0] == '_':
            continue
        ret[a] = obj_to_dict(o.__getattribute__(a))
    return ret

async def get_media_info():
    sessions = await MediaManager.request_async()

    current_session = sessions.get_current_session()
    if not current_session:  # there needs to be a media session running
        raise Exception('TARGET_PROGRAM is not the current media session')

    ret = {}
    ret['timeline'] = obj_to_dict(current_session.get_timeline_properties())
    playback_info = current_session.get_playback_info()
    ret['playback'] = obj_to_dict(playback_info)
    if 'SpotifyAB' in current_session.source_app_user_model_id:
        info = await current_session.try_get_media_properties_async()

        ret['song'] = obj_to_dict(info)
    else:
        return None

    return ret


if __name__ == '__main__':
    current_media_info = asyncio.run(get_media_info())
    print(json.dumps(current_media_info))
