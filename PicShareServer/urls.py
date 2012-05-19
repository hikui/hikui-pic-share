from django.conf.urls.defaults import patterns, include, url
from PicShareServer import settings


# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'PicShareServer.views.home', name='home'),
    # url(r'^PicShareServer/', include('PicShareServer.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
    (r'^api/', include('PicShareServer.api.urls')),
    (r'^media/',include('PicShareServer.Picture.urls')), #handle different image size
    (r'^web/',include('PicShareServer.PicShare.urls')),
)

if settings.DEBUG:
    urlpatterns += patterns('',
        url(r'^local_media/(?P<path>.*)$', 'django.views.static.serve', {
                'document_root': settings.MEDIA_ROOT,
            }),
   )