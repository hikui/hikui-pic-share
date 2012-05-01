from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('',

    (r'^index/$','PicShare.views.theIndex'),
)