from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('',

    (r'^pictures/(?P<picPath>\w+\.(jpg|png|gif))$','Picture.views.getPicture',{'img_type':0}),
    (r'^avatar/(?P<picPath>\w+\.(jpg|png|gif))$','Picture.views.getPicture',{'img_type':1}),
)