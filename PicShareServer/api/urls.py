from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from PicShareServer.api.handlers import *
from piston.authentication import HttpBasicAuthentication


auth                           = HttpBasicAuthentication(realm="auth")
get_all_categories_handler     = Resource(GetAllCategoriesHandler)
get_boards_of_category_handler = Resource(GetBoardsOfCategoryHandler)
get_picture_handler            = Resource(GetPictureHandler)
get_boards_of_user_handler     = Resource(GetBoardsOfUserHandler)
get_followers_handler          = Resource(GetFollowersHandler)
get_following_handler          = Resource(GetFollowingHandler)
get_user_detail_handler        = Resource(GetUserDetailHandler)
upload_picture_handler         = Resource(UploadPictureHandler,authentication=auth)
get_home_timeline_handler      = Resource(GetHomeTimelineHandler,authentication=auth)
get_board_handler              = Resource(GetBoardHandler)
follow_handler                 = Resource(FollowHandler,authentication=auth)
unfo_handler                   = Resource(UnfoHandler,authentication=auth)
update_board_handler           = Resource(UpdateBoardHandler,authentication=auth)
create_board_handler           = Resource(CreateBoardHandler,authentication=auth)
repin_handler                  = Resource(RepinPictureHandler,authentication=auth)
update_user_handler            = Resource(UpdateUserHandler,authentication=auth)
create_comment_handler         = Resource(CreateCommentHandler,authentication=auth)
get_comments_of_a_ps = Resource(GetCommentsOfAPictureStatusHandler)
urlpatterns = patterns('',

    (r'^category/get_all.json$',get_all_categories_handler),
    
    (r'^board/get.json$',get_board_handler),
    (r'^board/get_category_boards.json$',get_boards_of_category_handler),
    (r'^board/get_user_boards.json$',get_boards_of_user_handler),
    (r'^board/update.json$',update_board_handler),
    (r'^board/create.json$',create_board_handler),
    
    (r'^picture/get.json$',get_picture_handler),
    (r'^picture/upload.json$',upload_picture_handler),
    (r'^picture/repin.json$',repin_handler),
    (r'^picture/get_comments.json$',get_comments_of_a_ps),
    
    (r'^relationship/followers.json$',get_followers_handler),
    (r'^relationship/following.json$',get_following_handler),
    (r'^relationship/follow.json$',follow_handler),
    (r'^relationship/unfollow',unfo_handler),
    
    (r'^user/detail.json$',get_user_detail_handler),
    (r'^user/update.json$',update_user_handler),
    
    (r'^timeline/home_timeline.json$',get_home_timeline_handler),
    
    (r'^comment/create.json$',create_comment_handler),
    
)