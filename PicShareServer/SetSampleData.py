#coding:utf-8
from django.core.management import setup_environ
import settings
setup_environ(settings)

from django.contrib.auth.models import User
from PicShareServer.PicShare.models import *
from relationships.models import *
import datetime

_category = Category.objects.create(name="建筑")
Category.objects.create(name="艺术")
Category.objects.create(name="设计")
Category.objects.create(name="教育")
Category.objects.create(name="DIY")
Category.objects.create(name="电影")
Category.objects.create(name="音乐")
Category.objects.create(name="书籍")
Category.objects.create(name="运动")
Category.objects.create(name="美食")
Category.objects.create(name="园艺")
Category.objects.create(name="Geek")
Category.objects.create(name="历史")
Category.objects.create(name="旅游")
Category.objects.create(name="宠物")
Category.objects.create(name="自然科学")
Category.objects.create(name="高科技")
Category.objects.create(name="生活")
Category.objects.create(name="其他")

#RelationshipStatus.objects.create(name='follow',verb='follow to',from_slug='following',to_slug='follower',symmertrical_slug='friends',login_required=0,private=0)


userList = []
boardList = []
for i in range(1,6):
    u = User.objects.create_user('user'+str(i),'user'+str(i)+'@test.com','user'+str(i))
    userList.append(u)

for i in range(1,6):
    board = Board.objects.create(owner=userList[i-1],name="board"+str(i*2-1),category=_category)
    board2 = Board.objects.create(owner=userList[i-1],name="board"+str(i*2),category=_category)
    boardList.append(board)
    boardList.append(board2)

# for i in range(1,36):
#     p = Picture.objects.create(timestamp=datetime.datetime.now(),image="http://localhost/picture/"+str(i)+".jpg", location="上海")
#     ps = PictureStatus.objects.create(picture=p,description='ps'+str(i),board=boardList[i%10])
    