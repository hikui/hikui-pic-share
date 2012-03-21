from piston.handler import BaseHandler,AnonymousBaseHandler
from piston.utils import rc
from PicShareServer.PicShare.models import *
from django.contrib.auth import authenticate
from django.contrib.auth.models import User, AnonymousUser
import UploadImage

def is_authenticated(request):
    auth_string = request.META.get('HTTP_AUTHORIZATION', None)
    if not auth_string:
        return False
    try:
        (authmeth, auth) = auth_string.split(" ", 1)
        if not authmeth.lower() == 'basic':
            return False
        auth = auth.strip().decode('base64')
        (username, password) = auth.split(':', 1)
    except (ValueError, binascii.Error):
        return False
    request.user = authenticate(username=username, password=password) \
        or AnonymousUser()       
    return not request.user in (False, None, AnonymousUser())



def getUserDict(request,user):
    if user is None:
        return None
    
    isFollowing = False
    if is_authenticated(request):
        isFollowing = user in request.user.relationships.following()
    userBoards = user.my_boards.all()
    userPicCount = 0
    for userBoard in userBoards:
        userPicCount = userPicCount+userBoard.pictureStatuses.all().count()
    userDict = {
        'user_id':user.id,
        'username':user.username,
        'avatar':user.addition.avatar,
        'nick':user.addition.nick,
        'location':user.addition.location,
        'introduction':user.addition.introduction,
        'following_count':user.relationships.following().count(),
        'followers_count':user.relationships.followers().count(),
        'pictures_count':userPicCount,
        'is_following':isFollowing,
    }
    return userDict

def getPictureStatusDict(request,ps):
    if ps is None:
        return None
    psResultDict = {
        "ps_id":ps.id,
        "timestamp":ps.picture.timestamp,
        "image":ps.picture.image,
        "location":ps.picture.location,
        "description":ps.description,
        "status_type":ps.status_type,
        "comments_count":0,
        "board_id":ps.board.id,
        'board_name':ps.board.name,
        "owner":getUserDict(request,ps.board.owner),
        "via":getUserDict(request,ps.via),
    }
    return psResultDict

def getBoardDict(request,board):
    if board is None:
        return None
    owner = board.owner
    ownerResultDict = getUserDict(request,owner)
    picturesResultArray = []
    for ps in board.pictureStatuses.all()[:10]:
        psResultDict = getPictureStatusDict(request,ps)
        picturesResultArray.append(psResultDict)        
    boardResultDict = {
        'board_id':board.id,
        'board_name':board.name,
        'category_id':board.category.id,
        'pictures_count':board.pictureStatuses.count(),
        'owner':ownerResultDict,
        'pictures':picturesResultArray
    }
    return boardResultDict

class GetAllCategoriesHandler(BaseHandler):
    model = Category
    allowed_methods=('GET',)
    def read(self,request):
        categories = Category.objects.all()
        resultArray = []
        for aCategory in categories:
            tempDict = {}
            tempDict['category_id'] = aCategory.id
            tempDict['name'] = aCategory.name
            resultArray.append(tempDict)
        return {"categories":resultArray}
        
  
class GetBoardsOfCategoryHandler(BaseHandler):
    allowed_methods=('GET',)
    def read(self,request):
        categoryId = int(request.GET.get('category_id',1))
        page = int(request.GET.get('page',1))
        count = int(request.GET.get('count',3))
        category = Category.objects.get(pk=categoryId)
        boards = category.boards.all()[(page-1)*count:page*count]
        resultDict = {}
        total_count = category.boards.count()
        if page*count >= total_count:
            resultDict['hasnext'] = 0
        else:
            resultDict['hasnext'] = 1
        boardsResultArray = []
        for board in boards:
            boardResultDict = getBoardDict(request,board)
            boardsResultArray.append(boardResultDict)
        resultDict['boards']=boardsResultArray
        return resultDict
    
class GetBoardsOfUserHandler(BaseHandler):
    allowed_methods=('GET',)
    def read(self,request):
        userId = int(request.GET.get('user_id',1))
        page = int(request.GET.get('page',1))
        count = int(request.GET.get('count',3))
        user = User.objects.get(pk=userId)
        boards = user.my_boards.all()[(page-1)*count:page*count]
        resultDict = {}
        total_count = user.my_boards.count()
        if page*count >= total_count:
            resultDict['hasnext'] = 0
        else:
            resultDict['hasnext'] = 1
        boardsResultArray = []
        for board in boards:
            boardResultDict = getBoardDict(request,board)
            boardsResultArray.append(boardResultDict)
        resultDict['boards']=boardsResultArray
        return resultDict
        
class GetPictureHandler(BaseHandler):
    allowed_methods=('GET',)
    def read(self,request):
        psId = int(request.GET.get('ps_id',1))
        aPicStatus = PictureStatus.objects.get(pk=psId)
        resultDict = getPictureStatusDict(request,aPicStatus)
        return resultDict
    
class GetFollowersHandler(BaseHandler):
    allowed_methods=('GET',)
    def read(self,request):
        userId = int(request.GET.get('user_id',1))
        user = User.objects.get(pk=userId)
        count = int(request.GET.get('count',20))
        page = int(request.GET.get('page',1))
        resultDict = {}
        totalCount = user.relationships.followers().count()
        if page*count >= totalCount:
            resultDict['hasnext']=0
        else:
            resultDict['hasnext']=1
        followers = user.relationships.followers()[(page-1)*count:page*count]
        followersArray = []
        for aFollower in followers:
            followersArray.append(getUserDict(request,aFollower))
        resultDict['followers'] = followersArray
        return resultDict

class GetFollowingHandler(BaseHandler):
    allowed_methods=('GET',)
    def read(self,request):
        userId = int(request.GET.get('user_id',1))
        try:
            user = User.objects.get(pk=userId)
        except User.DoesNotExist:
            return {}
        count = int(request.GET.get('count',20))
        page = int(request.GET.get('page',1))
        resultDict = {}
        totalCount = user.relationships.following().count()
        if page*count >= totalCount:
            resultDict['hasnext']=0
        else:
            resultDict['hasnext']=1
        followings = user.relationships.following()[(page-1)*count:page*count]
        followingsArray = []
        for aFollowing in followings:
            followingsArray.append(getUserDict(request,aFollowing))
        resultDict['following'] = followingsArray
        return resultDict

class GetUserDetailHandler(BaseHandler):
    allowed_methods=('GET',)
    def read(self,request):
        userId = int(request.GET.get('user_id',1))
        user = User.objects.get(pk = userId)
        return getUserDict(request,user)
        
class UploadPictureHandler(BaseHandler):
    allowed_methods=('POST',)
    def create(self,request):
        UploadImage.handle_upload_image(request.FILES['pic'])
        return {}