#coding:utf-8
from piston.handler import BaseHandler,AnonymousBaseHandler
from piston.utils import rc
from piston.utils import validate
from PicShareServer.PicShare.models import *
from django.contrib.auth import authenticate
from django.contrib.auth.models import User, AnonymousUser
from django.contrib.sites.models import Site
from django.http import HttpRequest
import datetime
import UploadImage
from django import forms
from django.db.models import Q

def errorResponse(ret,errorcode,message,httpStatus):
    errorDict = {
                'ret':ret,
                'errorcode':errorcode,
                'msg': message
    }
    
    resp = httpStatus
    resp.content = errorDict
    return resp

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

def getBoardDictFull(request,board):
    if board is None:
        return None
    owner = board.owner
    ownerResultDict = getUserDict(request,owner)
    picturesResultArray = []
    for ps in board.pictureStatuses.all():
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
        
#################################
class UploadPictureForm(forms.Form):
    board_id = forms.IntegerField(min_value=1)
    description = forms.Textarea()
    latitude = forms.FloatField(required=False)
    longitude = forms.FloatField(required=False)
    #pic = forms.ImageField()


class UploadPictureHandler(BaseHandler):
    allowed_methods=('POST',)
    @validate(UploadPictureForm)
    def create(self,request):
        # get information
        upload_description = request.POST.get('description')
        board_id = int(request.POST.get('board_id'))
        theBoard = Board.objects.get(pk = board_id)
        print theBoard
        latitude = float(request.POST.get('latitude',-1))
        longitude = float(request.POST.get('longitude',-1))
        if theBoard.owner.id == request.user.id:
            # have permission to upload
            if request.FILES.get('pic') == None:
                # here is a bug in piston that the form validation can't validate
                # file type, such as FileField and ImageField.
                # I have to do this all by myself.
                return errorResponse(1,0,'请求错误',rc.BAD_REQUEST)
    
            filename = UploadImage.handle_upload_image(request.FILES['pic'])
            host = request.get_host()
            imageUrl = 'http://'+host+'/media/pictures/'+filename
            thePicture = Picture.objects.create(image=imageUrl,timestamp = datetime.datetime.now())
            print thePicture
            pictureStatus = PictureStatus.objects.create(picture=thePicture,description = upload_description,board = theBoard)
            print pictureStatus
            return getPictureStatusDict(request,pictureStatus)
        else :
            return errorResponse(0,2,'您不拥有该相册！',rc.FORBIDDEN)
          
class GetHomeTimelineHandler(BaseHandler):
    allowed_methods = ('GET',)
    def read(self,request):
        
        user = request.user
        page = int(request.GET.get('page',1))
        count = int(request.GET.get('count',4))
        sinceIdStr = request.GET.get('since_id')
        maxIdStr = request.GET.get('max_id')
        
        followingBoards = user.following_boards.all()
        myBoards = user.my_boards.all()
        from itertools import chain
        followingBoards = list(chain(followingBoards,myBoards))
        q1 = Q()
        q2 = Q()
        
        if sinceIdStr is not None:
            sinceId = int(sinceIdStr)
            q1 = Q(id__gt = sinceId)
        if maxIdStr is not None:
            maxId = int(maxIdStr)
            q2 = Q(id__lte = maxIdStr)
        
        totalCount = PictureStatus.objects.filter(Q(board__in=followingBoards)&q1&q2).count()
        pictureStatuses = PictureStatus.objects.filter(Q(board__in=followingBoards)&q1&q2).order_by('-id')[(page-1)*count:page*count]
        
        psArray = []
        for aPS in pictureStatuses:
            psArray.append(getPictureStatusDict(request,aPS))
            
        resultDict = {}
        resultDict['pictures']=psArray
        if page*count >= totalCount:
            resultDict['hasnext'] = 0
        else:
            resultDict['hasnext'] = 1
        return resultDict
        
class GetBoardHandler(BaseHandler):
    allowed_methods = ('GET',)
    def read(self,request):
        boardId = request.GET.get('board_id')
        if boardId is not None:
            boardId = int(boardId)
            board = Board.objects.get(pk=boardId)
            boardDict = getBoardDictFull(request,board)
            return boardDict;
        else:
            return errorResponse(1,0,"参数错误",rc.BAD_REQUEST)
    
class FollowHandler(BaseHandler):
    allowed_methods = ('POST',)
    def create(self,request):
        boardIdStr = request.POST.get('board_id')
        userIdStr = request.POST.get('user_id')
        user = request.user
        if boardIdStr is not None:
            boardId = int(boardIdStr)
            board = None
            try:
                board = Board.objects.get(pk=boardId)
            except:
                return errorResponse(0,1,'相册不存在',rc.NOT_FOUND)
            board.followers.add(user)
            return errorResponse(0,0,'操作成功',rc.ALL_OK)
        if userIdStr is not None:
            userId = int(userIdStr)
            if userId == user.id:
                return errorResponse(0,2,rc.FORBIDDEN)
            try:
                targetUser = User.objects.get(pk=userId)
            except:
                return errorResponse(0,1,'用户不存在',rc.NOT_FOUND)
            user.relationships.add(targetUser)
            for aBoard in targetUser.my_boards.all():
                aBoard.followers.add(user)
            return errorResponse(0,0,'操作成功',rc.ALL_OK)
        
        return errorResponse(1,0,'参数错误',rc.BAD_REQUEST)

class UnfoHandler(BaseHandler):
    allowed_methods = ('POST',)
    def create(self,request):
        boardIdStr = request.POST.get('board_id')
        userIdStr = request.POST.get('user_id')
        user = request.user
        if boardIdStr is not None:
            boardId = int(boardIdStr)
            board = None
            try:
                board = Board.objects.get(pk=boardId)
            except:
                return errorResponse(0,1,'相册不存在',rc.NOT_FOUND)
            board.followers.remove(user)
            return errorResponse(0,0,'操作成功',rc.ALL_OK)
        if userIdStr is not None:
            userId = int(userIdStr)
            if userId == user.id:
                return errorResponse(0,2,rc.FORBIDDEN)
            try:
                targetUser = User.objects.get(pk=userId)
            except:
                return errorResponse(0,1,'用户不存在',rc.NOT_FOUND)
            user.relationships.remove(targetUser)
            for aBoard in targetUser.my_boards.all():
                aBoard.followers.remove(user)
            return errorResponse(0,0,'操作成功',rc.ALL_OK)
        return errorResponse(1,0,'参数错误',rc.BAD_REQUEST)

##################
class UploadBoardForm(forms.Form):
    board_id = forms.IntegerField(min_value=1)
    name = forms.CharField(max_length=140)
    category_id = forms.IntegerField(min_value=1)

class UpdateBoardHandler(BaseHandler):
    allowed_methods = ('POST',)
    @validate(UploadBoardForm)
    def create(self,request):
        board_id = request.form.cleaned_data['board_id']
        name = request.form.cleaned_data['name']
        category_id = request.form.cleaned_data['category_id']
        board = None
        category = None
        try:
            board = Board.objects.get(pk=board_id)
            category = Category.objects.get(pk=category_id)
        except:
            return errorResponse(0,1,'目标不存在',rc.NOT_FOUND)
        if board.owner.id != request.user.id:
            return errorResponse(0,2,rc.FORBIDDEN)
        board.name = name
        board.category = category
        board.save()
        return errorResponse(0,0,'操作成功',rc.ALL_OK)
        
class DeleteBoardHandler(BaseHandler):
    allowed_methods = ('POST',)
    def create(self,request):
        board_id_str = request.POST.get('board_id') 
        if board_id_str is not None:
            board = None
            board_id = int(board_id_str)
            try:
                board = Board.objects.get(board_id)
            except:
                return errorResponse(0,1,"目标不存在",rc.NOT_FOUND)
            board.pictureStatuses.delete()
            board.delete()
            return errorResponse(0,0,"操作成功",rc.ALL_OK)
        else:
            return errorResponse(1,0,'请求错误',rc.BAD_REQUEST)
  
class CreateBoardForm(forms.Form):
    name = forms.CharField(max_length=140)
    category_id = forms.IntegerField(min_value=1)          
class CreateBoardHandler(BaseHandler):
    allowed_methods = ('POST',)
    @validate(CreateBoardForm)
    def create(self,request):
        the_name = request.form.cleaned_data['name']
        category_id = request.form.cleaned_data['category_id']
        the_category = None
        try:
            the_category = Category.objects.get(pk=category_id)
        except:
            return errorResponse(0,1,"目标不存在",rc.NOT_FOUND)
        try:
            exist_board = request.user.my_boards.get(name=the_name)
            if exist_board is not None:
                return errorResponse(0,3,"目标已存在",rc.DUPLICATE_ENTRY)
        except:
            pass
        board = Board.objects.create(name=the_name,owner=request.user,category=the_category)
        board_dict = getBoardDict(request,board)
        return board_dict

class RepinPictureForm(forms.Form):
    ps_id = forms.IntegerField(min_value=1)
    description = forms.CharField(max_length=140,required=False)
    board_id = forms.IntegerField(min_value=1)
    
class RepinPictureHandler(BaseHandler):
    allowed_methods = ('POST',)
    @validate(RepinPictureForm)
    def create(self,request):
        the_ps_id = request.form.cleaned_data['ps_id']
        the_description = request.form.cleaned_data['description']
        the_board_id = request.form.cleaned_data['board_id']
        the_board = None
        source_ps = None
        user = request.user
        try:
            the_board = Board.objects.get(pk=the_board_id)
            source_ps = PictureStatus.objects.get(pk=the_ps_id)
        except:
            return errorResponse(0,1,"目标不存在",rc.NOT_FOUND)
        if the_board.owner.id != user.id:
            return errorResponse(0,2,"权限错误",rc.FORBIDDEN)
        new_ps = PictureStatus.objects.create(picture=source_ps.picture,description=the_description,via=source_ps.board.owner,board=the_board)
        source_ps.picture.retain()
        return getPictureStatusDict(request,new_ps)
        