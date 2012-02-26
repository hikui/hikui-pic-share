from piston.handler import BaseHandler,AnonymousBaseHandler
from piston.utils import rc
from PicShareServer.PicShare.models import *


class AnonymousPublicTimelineHandler(AnonymousBaseHandler):
    def read(self,request):
        return rc.FORBIDDEN

class PublicTimelineHandler(BaseHandler):
    anonymous = AnonymousPublicTimelineHandler
    allowed_methods=('GET',)
    model = Status
    def read(self,request):
        statuses = Status.objects.all()
        resultArray = []
        for aStatus in statuses:
            tempDict = {}
            tempDict['timestamp']=aStatus.timestamp
            tempDict['image']=aStatus.image
            tempDict['tag']=aStatus.tag.tag_name
            tempDict['location']=aStatus.location
            tempDict['text']=aStatus.text
            tempDict['id']=aStatus.id
            tempDict['status_type']=aStatus.status_type
            tempDict['user']=aStatus.user.username
            resultArray.append(tempDict)
        return {'info':resultArray}

