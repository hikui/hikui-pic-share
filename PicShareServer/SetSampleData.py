#coding:utf-8
from django.core.management import setup_environ
import settings
setup_environ(settings)

from django.contrib.auth.models import User
from PicShareServer.PicShare.models import *
import datetime

userList = []
boardList = []
for i in range(1,6):
    u = User.objects.create_user('user'+str(i),'user'+str(i)+'@test.com','user'+str(i))
    userList.append(u)

for i in range(1,6):
    board = Board.objects.create(owner=userList[i-1],name="board"+str(i*2-1))
    board = Board.objects.create(owner=userList[i-1],name="board"+str(i*2))
    boardList.append(board)

for i in range(1,36):
    p = Picture.objects.create(timestamp=datetime.datetime.now(),image="http://localhost/picture/"+str(i)+".jpg", location="上海")
    ps = PictureStatus.objects.create(picture=p,description='ps'+str(i),board=boardList[i%10])
    