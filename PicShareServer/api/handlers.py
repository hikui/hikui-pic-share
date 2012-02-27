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
        pass

