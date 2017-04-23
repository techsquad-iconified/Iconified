from hashlib import sha1
import hmac
import binascii
import sys

arg1 = sys.argv[1]
re = '/v3/stops/location/'
therequest = re + arg1

def getUrl(request):
    devId = 3000212
    key = 'a256f6be-b7b2-4a37-8368-cb36f558c48a'
    request = request + ('&' if ('?' in request) else '?')
    raw = request+'devid={0}'.format(devId)
    hashed = hmac.new(key, raw, sha1)
    signature = hashed.hexdigest()
    return 'http://timetableapi.ptv.vic.gov.au'+raw+'&signature={1}'.format(devId, signature)
print getUrl(therequest)
