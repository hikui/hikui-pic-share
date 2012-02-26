from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from PicShareServer.api.handlers import *
from piston.authentication import HttpBasicAuthentication


auth = HttpBasicAuthentication(realm="auth")
public_timeline_handler = Resource(PublicTimelineHandler,authentication=auth)

urlpatterns = patterns('',

    (r'^status/public_timeline/', public_timeline_handler),
    
)