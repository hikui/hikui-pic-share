from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from PicShareServer.api.handlers import *
from piston.authentication import HttpBasicAuthentication


auth = HttpBasicAuthentication(realm="auth")
get_all_categories_handler = Resource(GetAllCategoriesHandler)
get_boards_of_category_handler = Resource(GetBoardsOfCategoryHandler)
get_picture_handler = Resource(GetPictureHandler)

urlpatterns = patterns('',

    (r'^category/get_all.json$',get_all_categories_handler),
    (r'^board/get_category_boards.json$',get_boards_of_category_handler),
    (r'^picture/get.json$',get_picture_handler),
)