from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from PicShareServer.api.handlers import *
from piston.authentication import HttpBasicAuthentication


auth = HttpBasicAuthentication(realm="auth")
get_all_categories_handler = Resource(GetAllCategoriesHandler)
get_boards_of_category_handler = Resource(GetBoardsOfCategoryHandler)
get_picture_handler = Resource(GetPictureHandler)
get_boards_of_user_handler = Resource(GetBoardsOfUserHandler)
get_followers_handler = Resource(GetFollowersHandler)
get_following_handler = Resource(GetFollowingHandler)
get_user_detail_handler = Resource(GetUserDetailHandler)
upload_picture_handler = Resource(UploadPictureHandler,authentication=auth)
urlpatterns = patterns('',

    (r'^category/get_all.json$',get_all_categories_handler),
    (r'^board/get_category_boards.json$',get_boards_of_category_handler),
    (r'^board/get_user_boards.json$',get_boards_of_user_handler),
    (r'^picture/get.json$',get_picture_handler),
    (r'^relationship/followers.json$',get_followers_handler),
    (r'^relationship/following.json$',get_following_handler),
    (r'^user/detail.json$',get_user_detail_handler),
    (r'^picture/upload.json$',upload_picture_handler)
)