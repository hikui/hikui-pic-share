from piston.handler import BaseHandler,AnonymousBaseHandler
from piston.utils import rc
from PicShareServer.PicShare.models import *
from django.contrib.auth import authenticate
from django.contrib.auth.models import User, AnonymousUser

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
        isAuthenticated = is_authenticated(request) #hava difference between authenticated user and anonymous user
        print isAuthenticated
        print request.user
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
            owner = board.owner
            isFollowing = False
            if isAuthenticated:
                isFollowing = owner in request.user.relationships.following()
            ownerResultDict = {
                'user_id':board.owner.id,
                'username':board.owner.username,
                'nick':board.owner.addition.nick,
                'avatar':board.owner.addition.avatar,
                'location':board.owner.addition.location,
                'introduction':board.owner.addition.introduction,
                'is_following':isFollowing
                }
            
            picturesResultArray = []
            for ps in board.pictureStatuses.all()[:10]:
                psResultDict = {
                    "ps_id":ps.id,
                    "timestamp":ps.picture.timestamp,
                    "image":ps.picture.image,
                    "location":ps.picture.location,
                    "description":ps.description,
                    "status_type":ps.status_type,
                    "comments_count":0,
                    "board_id":board.id,
                    "owner":ownerResultDict,
                    "via":ps.via,
                }
                picturesResultArray.append(psResultDict)
                
            boardResultDict = {
                'board_id':board.id,
                'board_name':board.name,
                'category_id':categoryId,
                'pictures_count':board.pictureStatuses.count(),
                'owner':ownerResultDict,
                'pictures':picturesResultArray
                }
            boardsResultArray.append(boardResultDict)
        resultDict['boards']=boardsResultArray
            
        return resultDict
        
        